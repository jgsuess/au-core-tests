This page describes how a single `TestScript` actually executes against a
target server, and what makes the difference between a pass and a fail.

### How a TestScript run works

Each `TestScript` in this package is executed by fhir-frog's
`TestScriptEngine` (in `fhir-frog-library`) against a single target FHIR
server. The flow is the same regardless of which TestScript is running:

1. **Load fixtures.** Every `TestScript.fixture` is loaded — either read
   from an inline/referenced resource or created on the target server —
   and `TestScript.variable` entries are initialized, including any
   `variable.sourceId` extracted from a loaded fixture.
2. **Setup.** `TestScript.setup` runs first: typically the operations that
   create or establish the precondition resources a test depends on
   (for example, a `Patient` and its related `Observation`s). If setup
   fails, the run stops early, teardown still runs, and the `TestReport`
   is finalized as failed.
3. **Test.** Each `TestScript.test` walks its own list of
   operation/assert action pairs: an *operation* performs a real FHIR
   interaction against the target server (read, search, create, and so
   on), and the following *assert* checks the response — via FHIRPath
   expression, profile validation, or resource-id matching. Every test
   runs regardless of whether an earlier test failed; the overall result
   is the logical AND of every individual test's result.
4. **Teardown.** Fixtures marked for autodelete are removed from the
   target server. This always runs, independent of pass or fail, so a
   failed run doesn't leave test data behind.
5. **Result.** The engine finalizes a `TestReport` resource linked to the
   `TestScript` that produced it: `status = completed`,
   `result = pass` or `fail`, plus every resolved variable and any
   fixture warnings (for example, a conditional-create fixture that
   matched an existing resource instead of creating a fresh one).

<div>{% include test-execution-sequence.svg %}</div>
<br clear="all"/>

*Sequence: a single TestScript's setup → test → teardown lifecycle against
one target server.*

### What determines pass or fail

Assertions are the only thing that can fail a test: an operation itself
only fails the run if the *assert* checking its response doesn't hold —
for example, a `responseCode` assertion checking for `200`, a FHIRPath
expression checking a returned bundle's contents, or a profile-conformance
assertion checking a returned resource validates against its declared AU
Core profile. A `TestReport.result` of `fail` always traces back to a
specific failed assertion in a specific test action, not to the harness
itself erroring out.
