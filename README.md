<div align="center">

# OpenLyst Builds

*Multi-platform build & repository system for OpenLyst apps*

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![Python](https://img.shields.io/badge/Python-3.8+-3776AB?logo=python&logoColor=white)](https://www.python.org/)
[![Platform](https://img.shields.io/badge/Platforms-iOS%20%7C%20Android%20%7C%20macOS%20%7C%20Linux%20%7C%20Arch-success)](https://openlyst.ink)

[Website](https://openlyst.ink) &bull; [Releases](https://openlyst.github.io/builds/) &bull; [API Docs](https://openlyst.ink/docs/api)

</div>

---

A single Python script that fetches app metadata from the [OpenLyst API](https://openlyst.ink/api/v1/apps) and generates package repositories for five platforms from one source of truth. No more juggling separate build scripts per platform — `build.py` handles it all.

## Features

- **AltStore (iOS)** — Generates `apps.json` with app permissions, entitlements, and privacy descriptions
- **F-Droid (Android)** — Produces a full F-Droid repository with category mapping and APK indexing
- **Homebrew (macOS/Linux)** — Creates formulae and casks for both Intel and Apple Silicon
- **AUR (Arch Linux)** — Generates PKGBUILDs for `-bin` packages, including unstable builds from GitHub releases
- **Docker** — Publishes web app images to GitHub Container Registry (ghcr.io)
- **GitHub Actions** — Two workflows: one for building app binaries across platforms, one for generating and pushing all repositories

## Getting Started

### Prerequisites

- Python 3.8+
- `requests` library (`pip install -r requirements.txt`)

### Build Repositories Locally

```bash
pip install -r requirements.txt

# Build everything
python build.py --target all

# Or pick specific targets
python build.py --target altstore          # iOS only
python build.py --target fdroid            # Android only
python build.py --target homebrew          # Homebrew only
python build.py --target aur               # AUR PKGBUILDs only
python build.py --target altstore,fdroid   # Multiple at once

# Homebrew platform filter
python build.py --target homebrew --platform macOS
python build.py --target homebrew --platform Linux

# Extra options
python build.py --target all --calculate-sha256   # Include SHA256 hashes
python build.py --target all --verbose             # Debug logging
```

## Platforms

### AltStore (iOS)

Add this source URL in AltStore:

```
https://raw.githubusercontent.com/openlyst/builds/main/repo/apps.json
```

CDN mirror (faster): `https://cdn.jsdelivr.net/gh/openlyst/builds@main/repo/apps.json`

> [!NOTE]
> The source includes app permissions (privacy descriptions and entitlements) when available from the API.

### F-Droid (Android)

Add this repository in your F-Droid client:

```
https://raw.githubusercontent.com/openlyst/builds/main/fdroid-repo
```

### Homebrew (macOS/Linux)

```bash
# Add the tap
brew tap openlyst/builds https://github.com/openlyst/builds.git

# Install an app
brew install openlyst/builds/app-name

# Or install a cask (GUI apps on macOS)
brew install --cask openlyst/builds/app-name

# Search what's available
brew search openlyst/builds/
```

| Command | Description |
|---------|-------------|
| `brew update` | Pull latest formulae |
| `brew info openlyst/builds/app-name` | Show formula details |
| `brew uninstall app-name` | Remove an app |

### AUR (Arch Linux)

Known packages are updated automatically from the Openlyst API:

| Package | App |
|---------|-----|
| `finar-bin` | Finar (Jellyfin client) |
| `klit-bin` | Kilt |
| `doudou-bin` | Doudou (music player) |

> [!NOTE]
> `docan-bin`, `lystcode`, and `opentorrent-bin` are currently disabled. Their config entries are commented out in `build.py` and can be re-enabled at any time.

New apps with Linux builds get PKGBUILDs generated automatically — just create the package on AUR first, then the workflow handles the rest.

Install with:

```bash
yay -S finar-bin    # or any other package above
```

### Docker

Images are published to GitHub Container Registry for web-based apps.

```bash
# Pull and run Finar (Jellyfin web client)
docker pull ghcr.io/justacalico/finar:latest
docker run -d -p 8080:80 ghcr.io/justacalico/finar:latest

# With Jellyfin CORS proxy
docker run -d -p 8080:80 \
  -e JELLYFIN_URL=http://your-jellyfin-server:8096 \
  ghcr.io/justacalico/finar:latest
```

Then open http://localhost:8080.

Example `docker-compose.yml`:

```yaml
services:
  finar:
    image: ghcr.io/justacalico/finar:latest
    ports:
      - "8080:80"
    environment:
      - JELLYFIN_URL=http://your-jellyfin-server:8096
    restart: unless-stopped
```

| Tag | Description |
|-----|-------------|
| `latest` | Latest stable release |
| `x.y.z` | Specific version |
| `x.y.z-YYYY-MM-DD` | Version with build date |

## GitHub Actions

Two workflows handle everything:

### Build All Repositories (`build-unified.yml`)

Generates and pushes all repository outputs. Trigger it from the Actions tab.

| Input | Description | Default |
|-------|-------------|---------|
| `target` | `all`, `altstore`, `fdroid`, `homebrew`, or `aur` | `all` |
| `platform` | Homebrew only: `both`, `macOS`, or `Linux` | `both` |
| `calculate_hashes` | Include SHA256 hashes (slower) | `false` |

### Build Apps (`build.yml`)

Builds app binaries from source across iOS, Android, Windows, Linux, macOS, and web. Each app has its own toggle and platform selector in the workflow run form.

> [!IMPORTANT]
> AUR pushes require the `AUR_SSH_KEY_BASE64` and `AUR_SSH_KEY_PASSWORD` repository secrets. Android signing requires per-app keystore secrets (optional — omit for unsigned builds).

## Project Structure

```
├── build.py                    # Unified build script (all platforms)
├── requirements.txt            # Python dependencies
├── repo/                       # AltStore repository output
├── fdroid-repo/                # F-Droid repository output
├── homebrew-tap/               # Homebrew tap output
│   └── Formula/                # Homebrew formulae and casks
├── docs/                       # GitHub Pages site
└── .github/workflows/
    ├── build-unified.yml       # Repository generation workflow
    └── build.yml               # App binary build workflow
```
