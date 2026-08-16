<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core Medication — SHALL-level conformance</h1>
    <p class="testscript-description">Covers the SHALL-level AU Core Medication (2.0.0) requirements reachable via direct read: read by id, must-support element presence (code; code.coding pbs and amt slices), and profile conformance validation. AU Core Medication defines no AU-Core search parameters, so this TestScript is read-only by design — there is no per-search-param test block, unlike au-core-patient. Inferno's own coverage of au-core-medication is itself indirect: config.basic.json sets Medication: {skip_generation: true}, so no standalone Inferno group exists for this profile, and it is otherwise reached only via MedicationRequest's medication_request_medication_inclusion_validation_test.rb, which validates a Medication resource fetched through _include=MedicationRequest:medication. That inclusion pattern is covered separately by au-core-medicationrequest's TestScript (fhirfrog/au-core-compiler#14) and is not duplicated here. This TestScript instead exercises Medication directly by id, mirroring the SHALL-only scope precedent set for Patient (fhirfrog/au-core-compiler#6). See fhirfrog/au-core-compiler#13 for scope rationale.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCoreMedication</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-medication</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>medication-fixture</code>: au-core-medication-conformant (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${medicationId}</code> = Medication.id of medication-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Medication by id (${medicationId})</span>
        <code class="testscript-technical">READ Medication/${medicationId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupport</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Medication by id (${medicationId})</span>
        <code class="testscript-technical">READ Medication/${medicationId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Medication.code.exists()</span>
        <code class="testscript-technical">expression = Medication.code.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Medication.code.coding.where(system = 'http://pbs.gov.au/code/item').exists()</span>
        <code class="testscript-technical">expression = Medication.code.coding.where(system = 'http://pbs.gov.au/code/item').exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Medication.code.coding.where(system = 'http://snomed.info/sct').exists()</span>
        <code class="testscript-technical">expression = Medication.code.coding.where(system = 'http://snomed.info/sct').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Medication by id (${medicationId})</span>
        <code class="testscript-technical">READ Medication/${medicationId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-medication</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-medication</code>
      </li>
    </ol>
  </section>
</section>
