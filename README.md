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

Originally developed inside
[`fhirfrog/au-core-compiler`](https://gitlab.com/fhirfrog/au-core-compiler)'s
gap-analysis trial and broken out here as its own standalone,
continuously-built package - see
[`docs/planning-strategy.md`](docs/planning-strategy.md) for the full
rationale behind this repo's existence, its GitLab/GitHub/build.fhir.org
architecture, and what's still open.

## Status: continuously built on build.fhir.org

Every push to `main` is validated with the real IG Publisher (not just
SUSHI) and auto-published at
<https://build.fhir.org/ig/jgsuess/au-core-tests/> — see
`docs/planning-strategy.md` for how that's wired up without a GitHub App
install. Also verified against a real HAPI FHIR server: `frog-runner`'s
`testPackage` support resolves this package via `fhir-frog-library`'s
`TestPackageResolver` and executes all 20 TestScripts - 13/14 of the
original 14 pass (the one failure is a known, already-filed flake,
`fhirfrog/fhir-frog#12`, unrelated to this IG); the 6 TestScripts added
since (`au-core-relatedperson`, `au-core-diagnosticresult`,
`au-core-diagnosticresult-path`, `au-core-smokingstatus`,
`au-core-sexassignedab`, `au-imagingresult`) are pending the same
comparative-run verification the earlier 14 already went through.

## What running the real IG Publisher surfaced (and fixed)

Running `sushi .` alone never validates against the base FHIR spec's own
required-field/datatype rules the way the real IG Publisher does. Two real
gaps turned up:

1. **`TestScript.setup.action.operation.encodeRequestUrl` and
   `.assert.warningOnly` are both `1..1` (required)** per the base FHIR R4
   TestScript StructureDefinition - confirmed directly against
   `hl7.fhir.r4.core#4.0.1`'s own snapshot. All TestScripts under
   `input/resources/` were missing them on most actions (350 IG Publisher
   errors on the original 14). Fixed: `encodeRequestUrl: true` added to
   every `operation`, `warningOnly: false` to every `assert` (semantically
   correct default - `warningOnly` isn't read anywhere by fhir-frog's own
   `AssertionEvaluator` today, so this didn't change execution behaviour,
   only fixed spec compliance).
2. **`validateProfileId` holds a full canonical URL, but the base spec
   types it as `id`** (a short token, no `/` or `:`), meant to reference a
   `TestScript.profile[]` entry by id rather than embed the URL directly.
   This is a deeper, cross-cutting issue - `ProfileValidator` doesn't
   resolve that indirection at all, so "fixing" the TestScript content
   without also fixing `ProfileValidator` would break execution. Filed as
   `fhirfrog/fhir-frog#13` rather than fixed here.

The remaining IG Publisher errors/broken links are website-narrative noise
(unresolvable "Home" nav links from a minimal `menu.xml`, fixture
cross-reference links in generated HTML) - expected for a resource-only IG
with no real website content, not a content defect.

## Build

```
sushi .                                # quick structural check - see qa summary
java -jar publisher.jar -ig . -tx n/a  # real build; -tx n/a skips slow/network-dependent
                                        # terminology validation (a single unreachable lookup
                                        # can cost 60s+ per resource otherwise)
./install-to-cache.sh                  # installs output/package.tgz into ~/.fhir/packages
                                        # under its real "0.1.0" version - NOT the "#dev"/"#current"
                                        # tag the Publisher's own build-time self-install always
                                        # uses (an internal build artifact, not the intended
                                        # distributable version - that special tag makes
                                        # FilesystemPackageCacheManager attempt a live currency
                                        # check against a real registry on every load, which throws
                                        # for a package that isn't published anywhere)
```

TestScripts and fixtures are authored directly under `input/resources/` -
this repo's own source of truth, no separate authoring location and no
sync step (unlike its earlier life split across two directories in
`au-core-compiler`).

An `ig.ini`/`fhir.base.template#current`-based build like this needs the
IG Publisher jar (see https://github.com/HL7/ig-publisher-scripts) - not
otherwise a project dependency. GitLab CI fetches it fresh in the `build`
job; see `.gitlab-ci.yml`.

The Test Cases pages (a readable, narrative-first page per TestScript,
linked from `test-cases.md`) aren't hand-authored here - they're generated
from `fhir-frog`'s `fhir-frog-testscript-render` module, built fresh from
that repo's own `main`, and the resulting `.md` files are committed to
this repository so HL7's auto-builder (which runs no custom CI step of
its own) has them available on a plain clone (see
`docs/planning-strategy.md`). Regenerate and re-commit them whenever
`input/resources/` or `fhir-frog`'s renderer changes - GitLab CI does this
automatically on every run as a drift check, but the committed copies are
what actually ships. To regenerate locally before pushing:

```
# Not --depth 1: fhir-frog computes its build version from git tag/history via jgitver - a
# shallow clone gives it nothing to work with and the build fails outright. -Djgitver.skip=true
# is also needed even with full history - see .gitlab-ci.yml's "build" job comment and
# docs/planning-strategy.md for why.
git clone https://gitlab.com/fhirfrog/fhir-frog.git /tmp/fhir-frog
(cd /tmp/fhir-frog && mvn -Djgitver.skip=true -pl fhir-frog-testscript-render -am package -DskipTests)
java -jar /tmp/fhir-frog/fhir-frog-testscript-render/target/fhir-frog-testscript-render-*.jar \
  input/resources input/pagecontent
sushi .
java -jar publisher.jar -ig . -tx n/a
```

## Try it

With `fhir-test-server`-style HAPI instance running and `frog-runner` up:

```
curl -X POST http://localhost:8080/api/runs \
  -H "Content-Type: application/json" \
  -d '{"testPackage":"fhirfrog.au-core-tests#0.1.0","serverUrl":"http://localhost:8080/fhir","igPackage":"hl7.fhir.au.core#2.0.0"}'
```

## What this is still *not*

- Not published to any real package registry - only in the local
  `~/.fhir/packages` cache via `install-to-cache.sh`, plus the
  build.fhir.org CI copy (discoverable, but not directly installable by
  `FilesystemPackageCacheManager`/`TestPackageResolver` today - see
  `docs/planning-strategy.md`).
- Fixtures are packaged as plain resources, **not** as IG Publisher
  "Example of `<profile>`" - most have no `meta.profile` today, and adding
  one would be a conformance-semantics change to files `TestScriptEngine`
  actively loads at runtime, not just a packaging decision.
- `TestPackageResolver` writes each fixture under both its original
  filename and a bare-id alias (`<id>.json`) so `TestScript.fixture.resource.reference`
  resolves regardless of which naming convention a given package uses -
  needed because the real IG Publisher always renames every resource to
  its own canonical `<ResourceType>-<id>.json` form on output, unlike this
  repo's own `input/resources/`, which keeps fixtures at their bare
  filename.
