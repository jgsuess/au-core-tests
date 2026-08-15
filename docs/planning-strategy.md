# Planning strategy: why this repo exists, and how it's built

This document is the "why", not the "how" — for build commands see the
root `README.md`. It exists so a future maintainer (including a future
session of whoever's working on this) can reconstruct the reasoning
without re-deriving it from git archaeology.

## 1. The Test IG pattern

`fhir-frog` needs a real, runnable AU Core conformance test suite to
demonstrate itself as a viable alternative to Inferno. The obvious wrong
answer is to fork or extend the AU Core IG itself — that couples this
project's test content to AU Core's own release cycle and governance, and
means every consumer has to know about the fork.

The pattern used instead: a **companion IG** that declares
`hl7.fhir.au.core` as a normal FHIR package dependency (see
`sushi-config.yaml`'s `dependencies:`), and packages its own TestScript
resources — nothing else — as its content. It doesn't modify AU Core, isn't
part of it, and doesn't need AU Core's maintainers' involvement to exist.
Nothing stops a vendor or jurisdiction from publishing their own,
differently-scoped Test IG against the same AU Core version, with zero
coordination required — that's the point of using a real FHIR package
dependency instead of a bespoke bundling format (contrast with Inferno's
own AU Core test kit, a Ruby gem that can't be resolved as a FHIR
dependency by canonical URL/version the way any other IG can).

Because a TestScript is itself a valid FHIR resource, a Test IG needs no
FSH authoring, no profiles, no logicals — just pre-built instances under
`input/resources/`. That's this whole repo.

## 2. Why a separate repo from `au-core-compiler`

This content used to live inside
[`fhirfrog/au-core-compiler`](https://gitlab.com/fhirfrog/au-core-compiler),
split awkwardly across two directories (`testscripts/` as hand-authored
source, `ig/au-core-tests/` as a generated SUSHI/IG-Publisher build
scaffold kept in sync by a `sync-resources.py` script). That repo's actual
job is the three-way gap analysis (AU Core spec vs Inferno vs fhir-frog)
that *produced* these TestScripts — a different lifecycle, a different
audience, and one that doesn't need its own package identity or CI.

Splitting the Test IG out here means:

- **Independent versioning.** This package can tag `0.2.0`, `1.0.0`, etc.
  on its own schedule, unrelated to gap-analysis milestones.
- **It's a reusable artifact**, not just this project's internal test
  fixture — anyone who wants an AU Core conformance test IG (for
  `fhir-frog` or, in principle, any other TestScript-capable runner) can
  depend on it the same way they'd depend on any other FHIR package.
- **One source of truth.** The old split (`testscripts/` vs
  `ig/au-core-tests/input/resources/`) had drifted before this move even
  happened — six TestScripts added after the last `sync-resources.py` run
  had never been synced into the packaged copy. Collapsing to one
  directory removes an entire class of "did you remember to sync" bugs.

`au-core-compiler` keeps the gap analysis (`docs/gap-analysis/`), the AU
Core version pin rationale (`ig/au-core/MANIFEST.md`), and the read-only
`au-fhir-core-inferno` submodule — none of that is Test IG content, all of
it stays exactly where it was.

## 3. Repo topology: GitLab canonical, GitHub mirror, explicit CI trigger

Every other `fhirfrog` repo (`fhir-frog`, `frog-runner`, `au-core-compiler`)
lives on GitLab, so this one does too —
`gitlab.com/fhirfrog/au-core-tests` is canonical: all authoring, issues,
and merge requests happen here.

The complication: **getting discovered on `build.fhir.org` requires
GitHub.** HL7's IG auto-builder
([`FHIR/auto-ig-builder`](https://github.com/FHIR/auto-ig-builder)) only
watches public GitHub repos — it's not a poller against some central
registry list, it's purely trigger-driven, and its triggers (a GitHub App
install, or a webhook) both assume the content lives on GitHub.

Rather than move authoring to GitHub (breaking the pattern every other
repo in this project follows) or give up on `build.fhir.org` entirely, this
repo uses a **thin, build-only GitHub mirror**:
`github.com/jgsuess/au-core-tests`. Nobody edits it directly; GitLab CI
pushes to it as a build step.

The remaining question was *how to trigger the auto-builder* against a
mirror nobody browses interactively (so there's no "click Install App on
GitHub" moment, and no guarantee GitHub's own webhook delivery fires the
way it would for a directly-authored repo). The auto-builder documents
exactly this case: a plain, unauthenticated POST endpoint that takes the
same payload shape as a GitHub push webhook —

```
curl -X POST "https://us-central1-fhir-org-starter-project.cloudfunctions.net/ig-commit-trigger" \
  -H "Content-type: application/json" \
  --data '{"ref": "refs/heads/main", "repository": {"full_name": "jgsuess/au-core-tests"}}'
```

— confirmed against the live `FHIR/auto-ig-builder` README, not assumed.
No GitHub App, no webhook config on the mirror repo at all: CI pushes to
GitHub, then calls this endpoint directly, once, right after. See
`.gitlab-ci.yml`'s `mirror` and `trigger-build` jobs.

Branch names for the auto-builder are restricted to `[A-Za-z0-9_-]`
(no `/`) — hence `main`, not e.g. a slash-containing feature-branch name,
for anything meant to reach `build.fhir.org`.

**A second, real gotcha found only by watching an actual failed build**: the
auto-builder's own harness (`FHIR/auto-ig-builder`'s `builder.py`) never
runs SUSHI itself — it installs `fsh-sushi` globally, then invokes the IG
Publisher directly with `-auto-ig-build`. That flag only makes the
Publisher auto-run SUSHI when it detects real FSH source under
`input/fsh/` (confirmed by diffing our failed `build.log` against a
working real IG's, `HL7/Vulcan-schedule-ig`, which has `input/fsh/`
content and logs `Run Sushi on ...`; ours has none and skipped straight to
loading the `ig.ini`-configured resource file directly — which didn't
exist yet). This repo has no FSH source to begin with (TestScripts and
fixtures are already valid FHIR JSON), so there's nothing for an
auto-sushi-run to compile anyway. Fix: commit `fsh-generated/` (SUSHI's
own output, previously gitignored as a pure build artifact) so the
auto-builder's raw clone already has what `ig.ini` points to. **Whoever
adds/removes a TestScript or fixture under `input/resources/` must
re-run `sushi .` and commit the refreshed `fsh-generated/` before
pushing** — it enumerates every resource, so it goes stale silently
otherwise (our own `.gitlab-ci.yml` build job regenerates its own
transient copy on every push and wouldn't catch this drift).

## 4. What "activated" gets you, concretely

Once a build succeeds, it's served at
`https://build.fhir.org/ig/jgsuess/au-core-tests/` (build log at the same
path + `/build.log`), and — this is the part that matters for `frog-runner`
— it's added to the aggregate
[`https://build.fhir.org/ig/qas.json`](https://build.fhir.org/ig/qas.json)
index that every other continuously-built IG in the world also reports
into.

`frog-runner`'s own `RegistryDiscoveryService`
(`org.fhirfrog.runner.registry.RegistryDiscoveryService`) already polls
exactly that index (`searchCiBuilds`) as part of its IG-package
autocomplete search, specifically so in-progress/unpublished IGs are
discoverable alongside real registry releases. That means: **no
frog-runner code change was needed** to make this Test IG searchable in
the running UI once it builds — it was already watching the right index,
it just had nothing of ours in it yet.

## 5. Versioning: two parallel, deliberately different identifiers

`sushi-config.yaml` pins a concrete `version: 0.1.0` with no
`releaseLabel: "ci-build"` — deliberately. A `ci-build`/`dev` releaseLabel
makes the IG Publisher self-install under the special `#dev`/`#current`
package-cache moniker, and that moniker makes
`FilesystemPackageCacheManager` attempt a live currency check against a
real package registry on every load — which throws, because this package
isn't published to any real registry. `install-to-cache.sh` installs
locally under the real `0.1.0` tag specifically to avoid that.

The `build.fhir.org` copy is a **separate, parallel distribution path**,
identified by its own CI branch (`main`) rather than by this same version
string — that's just how the auto-builder's own URL scheme works, not
something this repo controls. The two aren't meant to be the same
identifier; don't conflate "the CI build exists and is discoverable" with
"the local package cache now has a new version to install."

## 6. Known follow-up (not yet done)

`TestPackageResolver` (in `fhir-frog-library`) resolves a `testPackage`
spec via `FilesystemPackageCacheManager`, which reads from the real
package registry or the local `~/.fhir/packages` cache — it does not fetch
directly from a `build.fhir.org` URL. So today, "run the build.fhir.org
copy for real" still means: download `package.tgz` from
`https://build.fhir.org/ig/jgsuess/au-core-tests/package.tgz`, then
`install-to-cache.sh` it in, same mechanism as installing a locally-built
copy. Teaching `TestPackageResolver` (or a new frog-runner-side option) to
fetch a CI-build package straight from its `build.fhir.org` URL would close
that loop, but is out of scope for this repo's own extraction — it's a
`fhir-frog`/`frog-runner` change, tracked as a follow-up rather than
solved here.
