#!/usr/bin/env bash
# One-line installer for File Manager+ -- macOS, Linux, and Windows under Git Bash / WSL.
#
# Finds the latest release, downloads the jdeploy installer built for this OS and CPU, and
# runs it. jdeploy takes it from there: it installs the app and auto-updates it on every
# launch afterwards, so this is only ever needed once.
#
#   curl -fsSL https://raw.githubusercontent.com/jpage4500/FileManagerPlus/main/scripts/public/install.sh | bash
#
#   ./install.sh                     the latest release
#   ./install.sh --version 1.0.43    one particular release tag
#   ./install.sh --dry-run           download and unpack, but don't run the installer
#
# Windows without a bash shell: use scripts/public/install.ps1 instead.
#
# NOTE: on a network that inspects TLS (Netskope, Zscaler, a corporate VPN) the jdeploy
#       installer dies with "Cannot load app info because the app.xml file could not be
#       found" -- its private JRE doesn't trust your company's root CA. That needs
#       scripts/public/install-corporate.sh, which imports the root first. This script says so
#       if the install doesn't finish.

set -euo pipefail

# the source repo is private; releases (and this script, synced with the README) are public
REPO="jpage4500/FileManagerPlus"
APP_NAME="File Manager+"
RAW_BASE="https://raw.githubusercontent.com/$REPO/main/scripts/public"
VERSION=""
DRY_RUN=0

while [ $# -gt 0 ]; do
  case "$1" in
    --version)   VERSION="${2:-}"; [ -n "$VERSION" ] || { echo "--version needs a tag" >&2; exit 2; }; shift 2 ;;
    --version=*) VERSION="${1#*=}"; shift ;;
    --dry-run)   DRY_RUN=1; shift ;;
    # $0 is "bash" when this is piped in from curl, so the help can't be read off the file
    -h|--help)
      echo "usage: install.sh [--version <tag>] [--dry-run]"
      echo "  installs the latest File Manager+ release for this OS and CPU"
      exit 0 ;;
    *) echo "usage: install.sh [--version <tag>] [--dry-run]" >&2; exit 2 ;;
  esac
done

die() { echo "error: $*" >&2; exit 1; }

command -v curl >/dev/null || die "curl not found"
command -v tar  >/dev/null || die "tar not found"

# ---------------------------------------------------------------- which build to fetch

# jdeploy names every asset "...Installer-<os>-<arch>-<version>_<hash>.<ext>", so the OS and
# the CPU together are all that's needed to pick one out of the release
# WSL reports Linux here and runs Linux binaries, so it correctly lands on the linux build
# rather than the exe; only a real Git Bash / MSYS shell reports a Windows kernel
case "$(uname -s)" in
  Darwin)                          OS=mac;   EXT='tgz' ;;
  Linux)                           OS=linux; EXT='tar\.gz' ;;
  MINGW*|MSYS*|CYGWIN*|Windows_NT) OS=win;   EXT='exe' ;;
  *) die "unsupported platform: $(uname -s)" ;;
esac

case "$(uname -m)" in
  arm64|aarch64) ARCH=arm64 ;;
  x86_64|amd64)  ARCH=x64 ;;
  *) die "unsupported architecture: $(uname -m)" ;;
esac

echo "Installing $APP_NAME for $OS-$ARCH..."

# ---------------------------------------------------------------- find the release

if [ -n "$VERSION" ]; then
  API="https://api.github.com/repos/$REPO/releases/tags/$VERSION"
else
  API="https://api.github.com/repos/$REPO/releases/latest"
fi

JSON=$(curl -fsSL "$API") \
  || die "could not reach api.github.com (offline? rate limited? no release tagged '$VERSION'?)"

TAG=$(printf '%s' "$JSON" | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -1)
DL=$(printf '%s' "$JSON" | grep -oE "https://[^\"]*Installer-$OS-$ARCH-[^\"]*\.$EXT" | head -1)
[ -n "$DL" ] || die "no $OS-$ARCH installer in release ${TAG:-latest}"
echo "  version ${TAG:-unknown}"

# ---------------------------------------------------------------- download

# the windows installer is a GUI exe that may hand off and return immediately, so it is kept
# rather than downloaded into a directory the exit trap deletes out from under it
if [ "$OS" = win ]; then
  WORK="${TMPDIR:-/tmp}/fm-install"
  mkdir -p "$WORK"
else
  WORK=$(mktemp -d -t fm-install)
  trap 'rm -rf "$WORK"' EXIT
fi

FILE="$WORK/${DL##*/}"
echo "Downloading..."
curl -fsSL -o "$FILE" "$DL" || die "download failed"

# ---------------------------------------------------------------- run the installer

# Only macOS is checked, because it's the only one where the installed path is known for
# certain. Guessing at where jdeploy drops a .desktop file or a Start Menu entry and getting
# it wrong would report a failure for an install that worked, which is worse than not saying.
#
# jdeploy names the installed bundle after the app title; a title with a space in it has
# turned up dotted in release filenames, so both spellings count as installed
is_installed_mac() {
  local dir
  for dir in "$HOME/Applications" "/Applications"; do
    [ -d "$dir/$APP_NAME.app" ] && return 0
    [ -d "$dir/${APP_NAME// /.}.app" ] && return 0
  done
  return 1
}

case "$OS" in
  mac)
    tar xzf "$FILE" -C "$WORK"
    APP=$(find "$WORK" -maxdepth 3 -name "*.app" -type d | head -1)
    [ -n "$APP" ] || die "no .app found in the downloaded archive"
    # without this macOS runs the installer from a read-only translocated path
    xattr -dr com.apple.quarantine "$APP" 2>/dev/null || true
    RUN=$(find "$APP/Contents/MacOS" -type f -perm -u+x | head -1)
    [ -n "$RUN" ] || die "no launcher binary inside $APP"
    ;;
  linux)
    tar xzf "$FILE" -C "$WORK"
    RUN=$(find "$WORK" -maxdepth 2 -type f -name "*Installer*" ! -name "*.tar.gz" | head -1)
    [ -n "$RUN" ] || die "no installer binary found in the downloaded archive"
    chmod +x "$RUN"
    # the jdeploy installer draws a window; on a headless box it has nowhere to draw it
    if [ -z "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]; then
      echo "  warning: no DISPLAY -- the installer is a graphical app and will likely fail here"
    fi
    ;;
  win)
    RUN="$FILE"
    chmod +x "$RUN" 2>/dev/null || true
    ;;
esac

if [ "$DRY_RUN" = 1 ]; then
  echo "  [dry-run] would launch: $RUN"
  exit 0
fi

echo "Starting the installer..."
"$RUN" || true

# ---------------------------------------------------------------- report

echo
if [ "$OS" = mac ] && is_installed_mac; then
  echo "Installed. Launch \"$APP_NAME\" and it will auto-update on every launch from now on."
elif [ "$OS" = mac ]; then
  echo "The installer did not finish."
  echo
  echo "If you're on a corporate network that inspects traffic, the installer can't verify"
  echo "its own download server. Fix the certificates and retry with:"
  echo "  curl -fsSL $RAW_BASE/install-corporate.sh | bash"
  exit 1
else
  echo "The installer has run -- follow its window through if it's still open."
  echo "$APP_NAME auto-updates on launch from then on."
  echo
  echo "If it stopped with \"Cannot load app info because the app.xml file could not be found\","
  echo "your network inspects TLS and the installer's own JRE doesn't trust your company's root"
  echo "CA. Import that root into that JRE's cacerts (under ~/.jdeploy) with keytool, then rerun."
fi
