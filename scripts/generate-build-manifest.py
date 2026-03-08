#!/usr/bin/env python3
import argparse
import hashlib
import json
import os
import re
from datetime import datetime, timezone
from pathlib import Path

EXT_PACKAGE_TYPE = {
    '.apk': 'apk',
    '.aab': 'aab',
    '.ipa': 'ipa',
    '.appimage': 'appimage',
    '.deb': 'deb',
    '.rpm': 'rpm',
    '.exe': 'exe',
    '.dmg': 'dmg',
    '.msi': 'msi',
    '.msix': 'msix',
    '.zip': 'zip',
    '.tar.gz': 'tar.gz',
}

APP_REPOS = {
    'doudou': 'https://gitlab.com/Openlyst/doudou',
    'docan': 'https://gitlab.com/Openlyst/docan',
    'finar': 'https://gitlab.com/Openlyst/finar',
    'klit': 'https://gitlab.com/Openlyst/klit',
    'repstore': 'https://gitlab.com/Openlyst/repstore',
    'opentorrent': 'https://gitlab.com/Openlyst/opentorrent',
}


def sha256sum(path: Path) -> str:
    h = hashlib.sha256()
    with path.open('rb') as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b''):
            h.update(chunk)
    return h.hexdigest()


def package_type_for(name: str) -> str:
    lower = name.lower()
    if lower.endswith('.tar.gz'):
        return EXT_PACKAGE_TYPE['.tar.gz']
    ext = Path(lower).suffix
    return EXT_PACKAGE_TYPE.get(ext, ext.lstrip('.') or 'file')


def detect_platform(name: str, package_type: str) -> str:
    n = name.lower()
    if '-ios-' in n or package_type == 'ipa':
        return 'ios'
    if '-android-' in n or package_type in {'apk', 'aab'}:
        return 'android'
    if '-windows-' in n or package_type in {'exe', 'msi', 'msix'}:
        return 'windows'
    if '-macos-' in n or package_type == 'dmg':
        return 'macos'
    if '-linux-' in n or package_type in {'appimage', 'deb', 'rpm'}:
        return 'linux'
    if '-web' in n:
        return 'web'
    return 'unknown'


def detect_slug(name: str) -> str:
    first = name.split('-', 1)[0].lower()
    return first if first in APP_REPOS else 'unknown'


def release_asset_url(repo: str, tag: str, filename: str) -> str:
    return f"https://github.com/{repo}/releases/download/{tag}/{filename}"


def source_commit_url(repo_url: str, commit_sha: str) -> str:
    if not repo_url or not commit_sha:
        return ''
    return f"{repo_url}/-/tree/{commit_sha}"


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument('--artifact-dir', default='.')
    p.add_argument('--output', default='build-manifest.json')
    p.add_argument('--release-tag', required=True)
    p.add_argument('--build-name', required=True)
    p.add_argument('--build-number', required=True)
    p.add_argument('--build-date', required=True)
    p.add_argument('--generated-at', default=datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'))
    p.add_argument('--source-repo', required=True)
    p.add_argument('--source-commit-sha', default='')
    p.add_argument('--source-commit-url', default='')
    p.add_argument('--app-commits-json', default='{}')
    args = p.parse_args()

    app_commits = json.loads(args.app_commits_json)
    artifact_dir = Path(args.artifact_dir)

    artifacts = []
    include_patterns = ['*.zip', '*.apk', '*.aab', '*.ipa', '*.deb', '*.rpm', '*.AppImage', '*.exe', '*.dmg', '*.msi', '*.msix', '*.tar.gz']
    files = []
    for pattern in include_patterns:
        files.extend(artifact_dir.glob(pattern))
    files = sorted({f.resolve() for f in files if f.is_file()})

    for path in files:
        filename = path.name
        package_type = package_type_for(filename)
        platform = detect_platform(filename, package_type)
        slug = detect_slug(filename)
        app_repo = APP_REPOS.get(slug, args.source_repo)
        app_commit = app_commits.get(slug, '')
        artifact = {
            'project_slug': slug,
            'platform': platform,
            'artifact_filename': filename,
            'artifact_path': str(path),
            'artifact_url': release_asset_url(args.source_repo.replace('https://github.com/', ''), args.release_tag, filename),
            'sha256': sha256sum(path),
            'size_bytes': path.stat().st_size,
            'package_type': package_type,
            'source_repo': app_repo,
            'source_commit_sha': app_commit,
            'source_commit_url': source_commit_url(app_repo, app_commit),
            'release_tag': args.release_tag,
            'build_name': args.build_name,
            'build_number': str(args.build_number),
            'build_date': args.build_date,
            'generated_at': args.generated_at,
        }
        artifacts.append(artifact)

    manifest = {
        'release_tag': args.release_tag,
        'build_name': args.build_name,
        'build_number': str(args.build_number),
        'build_date': args.build_date,
        'generated_at': args.generated_at,
        'source_repo': args.source_repo,
        'source_commit_sha': args.source_commit_sha,
        'source_commit_url': args.source_commit_url,
        'artifacts': artifacts,
    }

    Path(args.output).write_text(json.dumps(manifest, indent=2) + '\n', encoding='utf-8')


if __name__ == '__main__':
    main()
