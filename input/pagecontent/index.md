This page is the entry point to **au-core-tests**: what it is, why it
exists as its own package, and where to go next depending on whether
you're here to read about how it works or to run it yourself.

### What this is

**au-core-tests** is a Test IG: a package of [FHIR `TestScript`](https://hl7.org/fhir/testscript.html)
resources that exercise [AU Core](http://hl7.org.au/fhir/core/)'s SHALL-level
conformance requirements against a real FHIR server. It declares
`hl7.fhir.au.core` as an ordinary FHIR package dependency (see this IG's
`dependencies:` in `sushi-config.yaml`) and adds nothing to AU Core itself —
no profile changes, no governance overlap. Any number of Test IGs like this
one could exist against the same AU Core version, published independently,
with no coordination required between them.

The TestScripts here are generated for and executed by
[**fhir-frog**](https://gitlab.com/fhirfrog/fhir-frog) — a JUnit 5
extension and standalone CLI for authoring and running FHIR TestScripts
against a real server, built on the HAPI FHIR client. Where a typical
clinical IG's content is profiles and examples read by humans and
validators, this IG's content is *executable* — every resource under
`input/resources/` is either a `TestScript` or a fixture instance it
depends on, and running this package means literally sending FHIR requests
to a server and checking the responses.

That's also this project's answer to a real gap: Inferno's own AU Core
test kit ([`au-fhir-core-inferno`](https://github.com/hl7au/au-fhir-core-inferno))
is a Ruby gem with its own bespoke packaging — it can't be resolved as a
FHIR dependency by canonical URL/version the way any other IG can. Because
a `TestScript` is itself a valid FHIR resource, this Test IG can be
distributed, versioned, and depended upon exactly like any other IG.

### Finding your way around

- **[Test Procedure](test-procedure.html)** — how a TestScript run actually
  works: fixtures, setup, the operation/assert loop, teardown, and what
  "pass" means.
- **[Test Targets](test-targets.html)** — what's being validated (which AU
  Core resources/profiles this package covers) and which servers this suite
  has actually been run against.
- **[Artifacts](artifacts.html)** — the generated list of every `TestScript`
  and fixture resource in this package.

### Where this fits

```
gitlab.com/fhirfrog/test-igs/au/au-core-tests   canonical source, issues, merge requests
        │
        ├─ CI: real IG Publisher build on every push to main
        ├─ mirrored (build-only) to github.com/jgsuess/au-core-tests
        └─ published continuously to build.fhir.org
```

See [`docs/planning-strategy.md`](https://gitlab.com/fhirfrog/test-igs/au/au-core-tests/-/blob/main/docs/planning-strategy.md)
in the source repo for the full rationale behind this repo's existence and
how the GitLab → GitHub → build.fhir.org pipeline is wired up.
