#!/usr/bin/env python3
import argparse
import json
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, List


def now_iso() -> str:
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def run_git_ls_remote(repo_url: str, branch: str) -> str:
    ref = f"refs/heads/{branch}"
    result = subprocess.run(
        ["git", "ls-remote", repo_url, ref],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        check=False,
    )
    if result.returncode != 0 or not result.stdout.strip():
        raise RuntimeError(f"failed ls-remote for {repo_url}@{branch}: {result.stderr.strip()}")
    return result.stdout.strip().split()[0]


def load_json(path: Path, default: Any) -> Any:
    if not path.exists():
        return default
    return json.loads(path.read_text(encoding="utf-8"))


def save_json(path: Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", default="config/watched-repos.json")
    parser.add_argument("--state", default="state/watched-heads.json")
    parser.add_argument("--changes-out", default="out/changed-repos.json")
    parser.add_argument("--seed-only", action="store_true")
    parser.add_argument("--github-output", default="")
    args = parser.parse_args()

    config_path = Path(args.config)
    state_path = Path(args.state)
    changes_out_path = Path(args.changes_out)

    cfg = load_json(config_path, {})
    repos: List[Dict[str, Any]] = cfg.get("repos", [])
    state: Dict[str, Any] = load_json(state_path, {})

    changed: List[Dict[str, Any]] = []
    state_changed = False

    for repo in repos:
      slug = repo["slug"]
      branch = repo.get("branch", "main")
      head_commit = run_git_ls_remote(repo["repo_url"], branch)
      prev = state.get(slug, {}).get("last_seen_commit", "")

      if not prev:
          state[slug] = {"last_seen_commit": head_commit, "updated_at": now_iso()}
          state_changed = True
          continue

      if head_commit != prev:
          if not args.seed_only:
              changed.append(
                  {
                      "slug": slug,
                      "commit": head_commit,
                      "branch": branch,
                      "platforms": repo.get("platforms_default", ""),
                  }
              )
          state[slug] = {"last_seen_commit": head_commit, "updated_at": now_iso()}
          state_changed = True

    if state_changed:
      save_json(state_path, state)

    changes_payload = {
        "generated_at": now_iso(),
        "count": len(changed),
        "changed": changed,
    }
    save_json(changes_out_path, changes_payload)

    any_changed = "true" if len(changed) > 0 else "false"
    changed_matrix_json = json.dumps(changed)

    if args.github_output:
      with open(args.github_output, "a", encoding="utf-8") as out:
          out.write(f"any_changed={any_changed}\n")
          out.write("changed_matrix_json<<EOF\n")
          out.write(changed_matrix_json + "\n")
          out.write("EOF\n")

    print(json.dumps(changes_payload, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
