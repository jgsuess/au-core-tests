<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core MedicationRequest — SHALL-level conformance</h1>
    <p class="testscript-description">Covers the SHALL-level AU Core MedicationRequest (2.0.0) requirements: read, search by _id, authoredon, intent, status and patient, a search demonstrating the _include=MedicationRequest:medication inclusion mechanism, must-support element presence, and profile conformance validation. Mirrors the SHALL subset of au-fhir-core-inferno's MedicationRequestGroup (medication_request_read_test, medication_request__id_search_test, medication_request_authoredon_search_test, medication_request_intent_search_test, medication_request_status_search_test, medication_request_patient_search_test, medication_request_patient_include_medication_test, medication_request_must_support_test, medication_request_validation_test) — the SHOULD/MAY-level combinatorial search tests (chained patient.identifier searches, multi-param AND/OR combinations, the further patient+intent+authoredon/status _include variants) are not replicated here; see fhirfrog/au-core-compiler#6 for the general scope rationale established for Patient, applied here for #14. Known engine limitation, documented here rather than as a new issue: fhir-frog's AssertionEvaluator validateProfileId assertion validates whichever resource came back from the *last* operation directly; it cannot reach into a specific entry of a returned Bundle to separately validate an included resource (e.g. the Medication pulled in via _include) against its own profile as a sub-check. Consequently the IncludeMedication test below only demonstrates the retrieval mechanism — asserting via FHIRPath that the Bundle contains both a MedicationRequest and a Medication entry — and does not attempt to validateProfileId the included Medication against au-core-medication. MedicationRequest's own profile conformance is instead exercised separately in the ProfileValidation test via a plain read followed by validateProfileId, which the engine handles correctly. A second, unrelated engine quirk found during validation against a live HAPI server: HAPI's FHIRPathEngine (ca.uhn.fhir newFhirPath(), used by fhir-frog's assertion evaluator) does not resolve the suffixed choice-type accessor form (e.g. `medicationReference`) as a property name on a resource instance — only the base choice name (`medication`) or an explicit `.ofType(Reference)`/`as Reference` filter on it work. The MustSupport test below therefore asserts `MedicationRequest.medication.ofType(Reference).exists()` rather than `MedicationRequest.medicationReference.exists()` to check the specific slice actually populated by the fixture.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCoreMedicationRequest</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-medicationrequest</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>patient-fixture</code>: au-core-patient-conformant (created before, and removed after, the run)</li>
      <li><code>medication-fixture</code>: au-core-medicationrequest-medication (created before, and removed after, the run)</li>
      <li><code>medicationrequest-fixture</code>: au-core-medicationrequest-conformant (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${patientId}</code> = Patient.id of patient-fixture</li>
      <li><code>${medicationRequestId}</code> = MedicationRequest.id of medicationrequest-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read MedicationRequest by id (${medicationRequestId})</span>
        <code class="testscript-technical">READ MedicationRequest/${medicationRequestId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchById</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search MedicationRequest where _id = ${medicationRequestId}</span>
        <code class="testscript-technical">SEARCH MedicationRequest?_id=${medicationRequestId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(MedicationRequest).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(MedicationRequest).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByAuthoredOn</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search MedicationRequest where authoredon = 2024-03-15</span>
        <code class="testscript-technical">SEARCH MedicationRequest?authoredon=2024-03-15</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(MedicationRequest).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(MedicationRequest).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByIntent</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search MedicationRequest where intent = order</span>
        <code class="testscript-technical">SEARCH MedicationRequest?intent=order</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(MedicationRequest).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(MedicationRequest).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByStatus</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search MedicationRequest where status = active</span>
        <code class="testscript-technical">SEARCH MedicationRequest?status=active</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(MedicationRequest).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(MedicationRequest).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByPatient</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search MedicationRequest where patient = ${patientId}</span>
        <code class="testscript-technical">SEARCH MedicationRequest?patient=${patientId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(MedicationRequest).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(MedicationRequest).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchWithIncludeMedication</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search MedicationRequest where patient = ${patientId} and _include = MedicationRequest:medication</span>
        <code class="testscript-technical">SEARCH MedicationRequest?patient=${patientId}&amp;_include=MedicationRequest:medication</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(MedicationRequest).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(MedicationRequest).exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Medication).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Medication).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupport</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read MedicationRequest by id (${medicationRequestId})</span>
        <code class="testscript-technical">READ MedicationRequest/${medicationRequestId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationRequest.status.exists()</span>
        <code class="testscript-technical">expression = MedicationRequest.status.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationRequest.intent.exists()</span>
        <code class="testscript-technical">expression = MedicationRequest.intent.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationRequest.medication.exists()</span>
        <code class="testscript-technical">expression = MedicationRequest.medication.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationRequest.medication.ofType(Reference).exists()</span>
        <code class="testscript-technical">expression = MedicationRequest.medication.ofType(Reference).exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationRequest.subject.exists()</span>
        <code class="testscript-technical">expression = MedicationRequest.subject.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationRequest.encounter.exists()</span>
        <code class="testscript-technical">expression = MedicationRequest.encounter.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationRequest.authoredOn.exists()</span>
        <code class="testscript-technical">expression = MedicationRequest.authoredOn.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationRequest.requester.exists()</span>
        <code class="testscript-technical">expression = MedicationRequest.requester.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationRequest.reasonCode.exists()</span>
        <code class="testscript-technical">expression = MedicationRequest.reasonCode.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationRequest.reasonReference.exists()</span>
        <code class="testscript-technical">expression = MedicationRequest.reasonReference.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationRequest.dosageInstruction.exists()</span>
        <code class="testscript-technical">expression = MedicationRequest.dosageInstruction.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationRequest.dosageInstruction.text.exists()</span>
        <code class="testscript-technical">expression = MedicationRequest.dosageInstruction.text.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read MedicationRequest by id (${medicationRequestId})</span>
        <code class="testscript-technical">READ MedicationRequest/${medicationRequestId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-medicationrequest</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-medicationrequest</code>
      </li>
    </ol>
  </section>
</section>
