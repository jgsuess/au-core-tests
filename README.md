# au-core-tests (Test IG)

fhir-frog's AU Core TestScripts, packaged as their own real FHIR
Implementation Guide that depends on `hl7.fhir.au.core` without modifying
it - a "Test IG", as opposed to a fork or extension of AU Core itself.
Several such Test IGs could exist against the same AU Core version (this
repo's own, a vendor's, a jurisdiction's) with no coordination between
them required.

This directly answers a limitation of Inferno's approach: an AU Core test
kit there is a separate Ruby gem with its own bespoke packaging - it can't
be resolved as a FHIR dependency by canonical URL/version the way any other
IG can. Because fhir-frog TestScripts are themselves valid FHIR resources,
they can be distributed exactly like any other IG's content.

## Status: verified end-to-end, real IG Publisher build

Built with the actual FHIR IG Publisher (not just SUSHI), installed into
the local package cache under its real version (`fhirfrog.au-core-tests#0.1.0`),
and run for real: `frog-runner`'s `testPackage` support resolves it via
`fhir-frog-library`'s `TestPackageResolver` and executes all 14 TestScripts
against a live HAPI FHIR server - 13/14 pass (the one failure is a known,
already-filed flake, fhirfrog/fhir-frog#12, unrelated to this IG).

## What running the real IG Publisher surfaced (and fixed)

Running `sushi .` alone never validates against the base FHIR spec's own
required-field/datatype rules the way the real IG Publisher does. Two real
gaps turned up:

1. **`TestScript.setup.action.operation.encodeRequestUrl` and
   `.assert.warningOnly` are both `1..1` (required)** per the base FHIR R4
   TestScript StructureDefinition - confirmed directly against
   `hl7.fhir.r4.core#4.0.1`'s own snapshot. All 14 TestScripts in
   `../../testscripts/` were missing them on most actions (350 IG
   Publisher errors). Fixed: `encodeRequestUrl: true` added to every
   `operation`, `warningOnly: false` to every `assert` (semantically
   correct default - `warningOnly` isn't read anywhere by fhir-frog's own
   `AssertionEvaluator` today, so this didn't change execution behaviour,
   only fixed spec compliance).
2. **`validateProfileId` holds a full canonical URL, but the base spec
   types it as `id`** (a short token, no `/` or `:`), meant to reference a
   `TestScript.profile[]` entry by id rather than embed the URL directly.
   This is a deeper, cross-cutting issue - `ProfileValidator` doesn't
   resolve that indirection at all, so "fixing" the TestScript content
   without also fixing `ProfileValidator` would break execution. Filed as
   fhirfrog/fhir-frog#13 rather than fixed here.

The remaining ~100 IG Publisher errors/220 broken links are website-
narrative noise (unresolvable "Home" nav links from a minimal `menu.xml`,
fixture cross-reference links in generated HTML) - expected for a
resource-only IG with no real website content, not a content defect.

## Build

```
python3 sync-resources.py           # regenerate input/resources/ from ../../testscripts/
sushi .                             # quick structural check - see qa summary
java -jar publisher.jar -ig . -tx n/a   # real build; -tx n/a skips slow/network-dependent
                                         # terminology validation (a single unreachable lookup
                                         # can cost 60s+ per resource otherwise)
./install-to-cache.sh               # installs output/package.tgz into ~/.fhir/packages
                                     # under its real "0.1.0" version - NOT the "#dev"/"#current"
                                     # tag the Publisher's own build-time self-install always
                                     # uses (an internal build artifact, not the intended
                                     # distributable version - that special tag makes
                                     # FilesystemPackageCacheManager attempt a live currency
                                     # check against a real registry on every load, which throws
                                     # for a package that isn't published anywhere)
```

An `ig.ini`/`fhir.base.template#current`-based build like this needs the
IG Publisher jar (see https://github.com/HL7/ig-publisher-scripts) - not
otherwise a project dependency.

## Try it

With `fhir-test-server`-style HAPI instance running and `frog-runner` up:

```
curl -X POST http://localhost:8080/api/runs \
  -H "Content-Type: application/json" \
  -d '{"testPackage":"fhirfrog.au-core-tests#0.1.0","serverUrl":"http://localhost:8080/fhir","igPackage":"hl7.fhir.au.core#2.0.0"}'
```

## What this is still *not*

- Not published to any real package registry - only in the local
  `~/.fhir/packages` cache via `install-to-cache.sh`. A registry publish
  (or at minimum a shared CI artifact) is the remaining step for anyone
  other than this machine to consume it.
- Fixtures are packaged as plain resources, **not** as IG Publisher
  "Example of `<profile>`" - most have no `meta.profile` today, and adding
  one would be a conformance-semantics change to files `TestScriptEngine`
  actively loads at runtime, not just a packaging decision.
- `TestPackageResolver` writes each fixture under both its original
  filename and a bare-id alias (`<id>.json`) so `TestScript.fixture.resource.reference`
  resolves regardless of which naming convention a given package uses -
  needed because the real IG Publisher always renames every resource to
  its own canonical `<ResourceType>-<id>.json` form on output, unlike this
  repo's `sync-resources.py`, which deliberately keeps fixtures at their
  bare filename for `input/resources/`.
