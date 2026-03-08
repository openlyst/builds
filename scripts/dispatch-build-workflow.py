#!/usr/bin/env python3
import argparse
import json
import os
import sys
import urllib.request


def load_config(path: str) -> dict:
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def build_inputs(config: dict, slug: str, commit: str) -> dict:
    repos = config.get("repos", [])
    inputs = {}
    target = None
    for r in repos:
        inputs[r["build_enabled_input"]] = "false"
        inputs[r["platforms_input_name"]] = r.get("platforms_default", "")
        inputs[r["commit_input_name"]] = ""
        if r["slug"] == slug:
            target = r
    if target is None:
        raise ValueError(f"unknown slug: {slug}")

    inputs[target["build_enabled_input"]] = "true"
    inputs[target["commit_input_name"]] = commit
    return inputs


def dispatch(repo: str, workflow: str, ref: str, token: str, inputs: dict) -> None:
    url = f"https://api.github.com/repos/{repo}/actions/workflows/{workflow}/dispatches"
    data = json.dumps({"ref": ref, "inputs": inputs}).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=data,
        method="POST",
        headers={
            "Accept": "application/vnd.github+json",
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
            "User-Agent": "openlyst-build-dispatcher",
        },
    )
    with urllib.request.urlopen(req) as resp:
        if resp.status not in (201, 204):
            raise RuntimeError(f"dispatch failed with status {resp.status}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", default="config/watched-repos.json")
    parser.add_argument("--slug", required=True)
    parser.add_argument("--commit", required=True)
    parser.add_argument("--repo", default=os.environ.get("GITHUB_REPOSITORY", ""))
    parser.add_argument("--workflow", default="build.yml")
    parser.add_argument("--ref", default="main")
    args = parser.parse_args()

    token = os.environ.get("GITHUB_TOKEN", "")
    if not token:
        raise RuntimeError("GITHUB_TOKEN is required")
    if not args.repo:
        raise RuntimeError("--repo or GITHUB_REPOSITORY is required")

    config = load_config(args.config)
    inputs = build_inputs(config, args.slug, args.commit)
    dispatch(args.repo, args.workflow, args.ref, token, inputs)
    print(json.dumps({"slug": args.slug, "commit": args.commit, "workflow": args.workflow, "ref": args.ref}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
