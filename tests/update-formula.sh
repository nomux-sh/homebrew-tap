#!/bin/sh
# Test of scripts/update-formula.sh. The script reads the releases and the
# checksums from tests/fixtures/, not from the network. The fixtures have the
# releases 999.9.0, 999.10.0 and 999.11.0-beta.1.
#
# Usage: tests/update-formula.sh
set -eu

cd "$(dirname "$0")/.."
fixtures="$PWD/tests/fixtures"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

update() {
  NOMUX_RELEASE_API_URL="file://$fixtures/$1/releases.json" \
    NOMUX_RELEASE_DOWNLOAD_URL="file://$fixtures/$1/download" \
    scripts/update-formula.sh "$work/nomux.rb"
}

cp Formula/nomux.rb "$work/nomux.rb"
[ "$(update complete)" = "999.10.0" ] ||
  fail "The script did not select 999.10.0: the newest version by number that has no suffix."
while read -r checksum archive; do
  grep -A 1 "url \".*/v999.10.0/$archive\"" "$work/nomux.rb" | grep -q "sha256 \"$checksum\"" ||
    fail "The formula does not have the address of $archive with its checksum after it."
done <"$fixtures/complete/download/v999.10.0/SHA256SUMS"
[ "$(grep -c '^ *url "' "$work/nomux.rb")" -eq 4 ] || fail "The formula does not have four addresses."
[ "$(grep -c '^ *sha256 "' "$work/nomux.rb")" -eq 4 ] || fail "The formula does not have four checksums."

cp "$work/nomux.rb" "$work/current.rb"
[ -z "$(update complete)" ] || fail "The script printed a version for a formula that is current."
cmp -s "$work/nomux.rb" "$work/current.rb" || fail "The script changed a formula that is current."

cp Formula/nomux.rb "$work/nomux.rb"
if update incomplete >/dev/null 2>&1; then
  fail "The script accepted a SHA256SUMS file that does not have all four archives."
fi
cmp -s "$work/nomux.rb" Formula/nomux.rb || fail "The script changed the formula before it failed."

echo "update-formula.sh: all tests passed."
