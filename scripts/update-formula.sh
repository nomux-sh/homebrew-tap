#!/bin/sh
# Moves Formula/nomux.rb to the newest nomux version that has no suffix: the
# version in the four archive addresses and the four SHA-256 checksums from the
# SHA256SUMS file of the release. It removes the `bottle` block, because the
# bottles contain the old version. The workflow update-formula.yml makes the
# bottles of the new version.
#
# Usage: scripts/update-formula.sh [<formula>]
#
# If the formula changed, the script prints the new version on the standard
# output. If the formula is current, it prints nothing there.
#
# NOMUX_RELEASE_API_URL and NOMUX_RELEASE_DOWNLOAD_URL replace the two GitHub
# addresses. The test of this script uses them to read local files.
set -eu

TARGETS="aarch64-apple-darwin x86_64-apple-darwin aarch64-unknown-linux-musl x86_64-unknown-linux-musl"
ARCHIVE_URL="https://github.com/nomux-sh/nomux/releases/download"
RELEASE_API_URL="${NOMUX_RELEASE_API_URL:-https://api.github.com/repos/nomux-sh/nomux/releases?per_page=100}"
RELEASE_DOWNLOAD_URL="${NOMUX_RELEASE_DOWNLOAD_URL:-$ARCHIVE_URL}"

fail() {
  echo "update-formula.sh: error: $1" >&2
  exit 1
}

# The same rule as install.sh in the nomux repository. `releases/latest` is
# not usable: it ignores pre-releases, and each 0.x release is a pre-release.
# A version with a suffix (0.2.0-beta.1) is not a candidate.
released_versions() {
  curl -fsSL "$RELEASE_API_URL" |
    tr ',' '\n' |
    sed -n 's/.*"tag_name": *"v\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\)".*/\1/p'
}

# The sort is numeric, thus 0.10.0 is newer than 0.9.0.
newest_of() {
  sort -t . -k 1,1n -k 2,2n -k 3,3n | tail -n 1
}

formula="${1:-Formula/nomux.rb}"
[ -f "$formula" ] || fail "The file $formula does not exist."

current="$(sed -n 's|.*/releases/download/v\([0-9.]*\)/.*|\1|p' "$formula" | sort -u)"
if [ -z "$current" ] || [ "$(echo "$current" | wc -l)" -ne 1 ]; then
  fail "The archive addresses in $formula do not have one version."
fi

released="$(released_versions)"
[ -n "$released" ] || fail "Found no release at $RELEASE_API_URL"
newest="$(echo "$released" | newest_of)"

if [ "$(printf '%s\n%s\n' "$current" "$newest" | newest_of)" = "$current" ]; then
  echo "The formula has nomux $current. The newest release is $newest. No change." >&2
  exit 0
fi

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

curl -fsSL -o "$work/SHA256SUMS" "$RELEASE_DOWNLOAD_URL/v$newest/SHA256SUMS" ||
  fail "Cannot download $RELEASE_DOWNLOAD_URL/v$newest/SHA256SUMS"
for target in $TARGETS; do
  archive="nomux-$newest-$target.tar.gz"
  checksum="$(awk -v name="$archive" '$2 == name { print $1 }' "$work/SHA256SUMS")"
  echo "$checksum" | grep -Eq '^[0-9a-f]{64}$' ||
    fail "SHA256SUMS of $newest has no SHA-256 checksum for $archive. The formula did not change."
done

# A `url` line names its target. The `sha256` line after it gets the checksum
# of the archive of that target.
awk -v version="$newest" -v url="$ARCHIVE_URL" -v targets="$TARGETS" -v sums="$work/SHA256SUMS" '
  BEGIN {
    count = split(targets, target, " ")
    while ((getline line < sums) > 0) {
      split(line, field, " ")
      checksum[field[2]] = field[1]
    }
  }
  /^ *url "/ {
    for (i = 1; i <= count; i++) {
      if (index($0, target[i])) {
        archive = "nomux-" version "-" target[i] ".tar.gz"
        sub(/url ".*"/, "url \"" url "/v" version "/" archive "\"")
      }
    }
  }
  /^ *sha256 "/ { sub(/sha256 ".*"/, "sha256 \"" checksum[archive] "\"") }
  /^  bottle do$/ { in_bottle = 1 }
  in_bottle && /^  end$/ { in_bottle = 0; after_bottle = 1; next }
  in_bottle { next }
  after_bottle && /^$/ { after_bottle = 0; next }
  { after_bottle = 0; print }
' "$formula" >"$work/formula"
cat "$work/formula" >"$formula"

echo "Moved the formula from nomux $current to nomux $newest." >&2
echo "$newest"
