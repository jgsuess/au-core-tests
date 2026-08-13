#!/bin/bash
# Installs this Test IG's real IG-Publisher-built package (output/package.tgz) into the local
# FHIR package cache (~/.fhir/packages), under its own concrete "0.1.0" version - not the "#dev"/
# "#current" tag the IG Publisher's own build-time self-install always uses regardless of
# releaseLabel/version (an internal build artifact, not the intended distributable version): that
# special tag makes FilesystemPackageCacheManager attempt a live currency check against a real
# package registry on every load, which throws for a package that isn't published anywhere.
#
# Run `java -jar publisher.jar -ig . -tx n/a` first (from this directory) to (re)generate
# output/package.tgz - see README for why -tx n/a (skips slow/network-dependent terminology
# validation) and what the IG Publisher's own validation surfaced when this was last run.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_TGZ="$HERE/output/package.tgz"
PACKAGE_ID="fhirfrog.au-core-tests"
VERSION="0.1.0"
CACHE_DIR="$HOME/.fhir/packages/${PACKAGE_ID}#${VERSION}"

if [ ! -f "$PACKAGE_TGZ" ]; then
  echo "Missing $PACKAGE_TGZ - run the IG Publisher first (see README)." >&2
  exit 1
fi

rm -rf "$HOME/.fhir/packages/${PACKAGE_ID}#dev" "$CACHE_DIR"
mkdir -p "$CACHE_DIR"
tar -xzf "$PACKAGE_TGZ" -C "$CACHE_DIR"

echo "Installed ${PACKAGE_ID}#${VERSION} into ${CACHE_DIR}"
find "$CACHE_DIR/package" -iname "TestScript-*.json" | wc -l | xargs echo "TestScripts:"
