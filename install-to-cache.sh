#!/bin/bash
# Manually assembles this Test IG into the local FHIR package cache
# (~/.fhir/packages), the same cache FilesystemPackageCacheManager reads -
# standing in for a real IG Publisher build + package registry publish,
# which are both out of scope for this trial (see README).
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_ID="fhirfrog.au-core-tests"
VERSION="0.1.0"
CACHE_DIR="$HOME/.fhir/packages/${PACKAGE_ID}#${VERSION}/package"

rm -rf "$CACHE_DIR"
mkdir -p "$CACHE_DIR"

cp "$HERE"/input/resources/*.json "$CACHE_DIR"/
cp "$HERE"/fsh-generated/resources/ImplementationGuide-*.json "$CACHE_DIR"/

cat > "$CACHE_DIR/package.json" <<EOF
{
  "name": "${PACKAGE_ID}",
  "version": "${VERSION}",
  "type": "IG",
  "canonical": "http://fhirfrog.org/fhir/au-core-tests",
  "fhirVersions": ["4.0.1"],
  "dependencies": {
    "hl7.fhir.au.core": "2.0.0"
  }
}
EOF

echo "Installed ${PACKAGE_ID}#${VERSION} into ${CACHE_DIR}"
ls "$CACHE_DIR" | wc -l
