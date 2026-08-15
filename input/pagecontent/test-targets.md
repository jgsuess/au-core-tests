This page covers what this package actually checks and which real FHIR
servers it has been validated against.

### What's being validated

This package's 20 TestScripts exercise AU Core's SHALL-level conformance
requirements — profile validation, required search parameters, and known
obligation-pair behaviour — across the following AU Core resources and
profiles:

| Resource | TestScript(s) |
|---|---|
| AllergyIntolerance | SHALL-level conformance plus chained identifier search |
| Condition | SHALL-level conformance |
| Encounter | SHALL-level conformance |
| HealthcareService | SHALL-level conformance |
| Immunization | SHALL-level conformance plus vaccineCode slice coverage |
| Location | SHALL-level conformance |
| Medication | SHALL-level conformance |
| MedicationRequest | SHALL-level conformance |
| MedicationStatement | SHALL-level conformance |
| Observation — Diagnostic Result | Search & obligation-pair conformance |
| Observation — Pathology Result | Search & obligation-pair conformance |
| Observation — Smoking Status | SHALL-level conformance |
| Observation — Sex Assigned at Birth extension | Presence & profile conformance |
| Observation — Imaging Result | Optionality-discovery template |
| Organization | SHALL-level conformance |
| Patient | SHALL-level conformance |
| Practitioner | SHALL-level conformance |
| PractitionerRole | Core search & profile conformance |
| Procedure | SHALL-level conformance |
| RelatedPerson | SHALL-level conformance |

See [Artifacts](artifacts.html) for the full list with links to each
`TestScript`'s own generated page.

### Where this has actually been run

fhir-frog's `frog-runner` resolves this package via
`fhir-frog-library`'s `TestPackageResolver` and executes every TestScript
in it against a real, running FHIR server — this is not a static
conformance checklist, it's a suite that has to actually pass against
live servers to mean anything. It has been run against:

- **A local HAPI FHIR server** (`docker run hapiproject/hapi:latest`), used
  for fast local iteration while authoring or changing a TestScript.
- **[SPARKED](https://sparked.csiro.au/)'s `FHIRFROG` test tenant**
  (`smile.sparked-fhir.com/aucore/fhir/FHIRFROG`), a shared AU Core FHIR
  server used to validate against a real, independently-hosted
  implementation rather than only a local instance.

The three-way gap analysis that originally produced these TestScripts (AU
Core "as specified" vs. Inferno's own AU Core test kit "as implemented" vs.
fhir-frog "as executable") lives in a separate repo,
[`fhirfrog/au-core-compiler`](https://gitlab.com/fhirfrog/au-core-compiler) —
Inferno's test kit was a comparison point during that analysis, not a
server this suite runs against.

<div>{% include architecture.svg %}</div>
<br clear="all"/>

*How this package reaches a target server: resolved as a FHIR package by
`frog-runner`, loaded and executed by fhir-frog's `TestScriptEngine`,
against whichever server is configured for the run.*
