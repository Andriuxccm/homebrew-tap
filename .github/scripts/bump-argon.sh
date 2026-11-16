#!/usr/bin/env bash
# Points Casks/argon.rb at the release announced in latest.json.
# Exits 0 without touching the cask when it is already current, when the feed
# goes backwards, or when the versioned DMG is not uploaded yet (next run retries).
# Needs macOS: hdiutil + PlistBuddy check the app inside the DMG, brew maps macOS names.
set -euo pipefail

CASK="${CASK:-Casks/argon.rb}"
FEED="${FEED:-https://argonmac.com/releases/latest.json}"
BASE="${BASE:-https://argonmac.com/releases}"
# Argon's Developer ID team: the cask only moves to an app signed by it and notarized by Apple.
TEAM_ID="${TEAM_ID:-CM7Z3M6V2Y}"

feed="$(curl -fsSL --retry 3 "$FEED")"
latest="$(jq -r '.version // empty' <<<"$feed")"
min_os="$(jq -r '.minMacOS // empty' <<<"$feed")"
current="$(sed -nE 's/^  version "([^"]+)"$/\1/p' "$CASK")"

[[ "$latest" =~ ^[0-9]+(\.[0-9]+)+$ ]] || { echo "Unexpected version in the feed: '$latest'" >&2; exit 1; }
[[ -n "$current" ]] || { echo "No version line in $CASK" >&2; exit 1; }

if [[ "$latest" == "$current" ]]; then
  echo "Cask is current ($current)."
  exit 0
fi
if [[ "$(printf '%s\n%s\n' "$current" "$latest" | sort -V | tail -1)" != "$latest" ]]; then
  echo "Feed says $latest, older than the cask's $current: leaving the cask alone."
  exit 0
fi

dmg_url="$BASE/Argon-$latest.dmg"
if ! curl -fsSIL --retry 3 -o /dev/null "$dmg_url"; then
  echo "$dmg_url is not up yet: will retry on the next run."
  exit 0
fi

tmp="$(mktemp -d)"
mnt="$tmp/mnt"
cleanup() {
  hdiutil detach "$mnt" -quiet -force 2>/dev/null || true
  [[ -e "$mnt/Argon.app" ]] || rm -rf "$tmp"
}
trap cleanup EXIT

curl -fsSL --retry 3 -o "$tmp/Argon.dmg" "$dmg_url"
sha="$(shasum -a 256 "$tmp/Argon.dmg" | cut -d' ' -f1)"

mkdir "$mnt"
hdiutil attach -nobrowse -readonly -noautoopen -mountpoint "$mnt" "$tmp/Argon.dmg" >/dev/null
app_version="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$mnt/Argon.app/Contents/Info.plist")"
requirement="notarized and anchor apple generic and certificate leaf[subject.OU] = \"$TEAM_ID\""
if ! codesign --verify --deep --check-notarization -R="$requirement" "$mnt/Argon.app" 2>"$tmp/codesign.log"; then
  echo "Argon.app in Argon-$latest.dmg is not notarized and signed by team $TEAM_ID: refusing to bump." >&2
  cat "$tmp/codesign.log" >&2
  exit 1
fi
hdiutil detach "$mnt" -quiet
if [[ "$app_version" != "$latest" ]]; then
  echo "Argon-$latest.dmg holds Argon $app_version, not $latest: fix the upload first." >&2
  exit 1
fi

sed_args=(
  -e "s/^  version \"[^\"]+\"$/  version \"$latest\"/"
  -e "s/^  sha256 \"[0-9a-f]{64}\"$/  sha256 \"$sha\"/"
)
if [[ -n "$min_os" ]]; then
  macos="$(brew ruby -e 'puts MacOSVersion.new(ARGV.first).to_sym' "$min_os" 2>/dev/null | tail -1)"
  [[ "$macos" =~ ^[a-z_]+$ && "$macos" != dunno ]] || { echo "brew could not name macOS '$min_os'" >&2; exit 1; }
  sed_args+=(-e "s/^  depends_on macos: :[a-z_]+$/  depends_on macos: :$macos/")
fi
sed -i.bak -E "${sed_args[@]}" "$CASK"
rm -f "$CASK.bak"

grep -q "^  version \"$latest\"$" "$CASK" && grep -q "^  sha256 \"$sha\"$" "$CASK" \
  || { echo "The cask did not take the new version/sha256" >&2; exit 1; }

echo "Bumped $CASK: $current -> $latest (sha256 $sha, macOS ${macos:-unchanged})"
[[ -n "${GITHUB_OUTPUT:-}" ]] && echo "version=$latest" >>"$GITHUB_OUTPUT"
exit 0
