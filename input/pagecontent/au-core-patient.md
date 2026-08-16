<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core Patient — SHALL-level conformance</h1>
    <p class="testscript-description">Covers the SHALL-level AU Core Patient (2.0.0) requirements: read, search by _id, search by identifier, must-support element presence, and profile conformance validation. Mirrors the SHALL subset of au-fhir-core-inferno's PatientGroup (patient_read_test, patient__id_search_test, patient_identifier_search_test, patient_must_support_test, patient_validation_test) — the SHOULD/MAY-level combinatorial search tests (name, gender, birthdate, indigenous-status, gender-identity and their combinations) are not replicated here; see fhirfrog/au-core-compiler#6 for scope rationale.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCorePatient</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-patient</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>patient-fixture</code>: au-core-patient-conformant (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${patientId}</code> = Patient.id of patient-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Patient by id (${patientId})</span>
        <code class="testscript-technical">READ Patient/${patientId}</code>
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
        <span class="testscript-narrative">Search Patient where _id = ${patientId}</span>
        <code class="testscript-technical">SEARCH Patient?_id=${patientId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Patient).name.family.contains('Frog')</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Patient).name.family.contains('Frog')</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByIdentifier</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Patient where identifier = http://ns.electronichealth.net.au/id/hi/ihi/1.0|8003608833357361</span>
        <code class="testscript-technical">SEARCH Patient?identifier=http://ns.electronichealth.net.au/id/hi/ihi/1.0|8003608833357361</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Patient).name.family.contains('Frog')</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Patient).name.family.contains('Frog')</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupport</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Patient by id (${patientId})</span>
        <code class="testscript-technical">READ Patient/${patientId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.identifier.exists()</span>
        <code class="testscript-technical">expression = Patient.identifier.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.name.exists()</span>
        <code class="testscript-technical">expression = Patient.name.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.name.use.exists()</span>
        <code class="testscript-technical">expression = Patient.name.use.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.name.text.exists()</span>
        <code class="testscript-technical">expression = Patient.name.text.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.name.family.exists()</span>
        <code class="testscript-technical">expression = Patient.name.family.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.name.given.exists()</span>
        <code class="testscript-technical">expression = Patient.name.given.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.telecom.exists()</span>
        <code class="testscript-technical">expression = Patient.telecom.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.telecom.system.exists()</span>
        <code class="testscript-technical">expression = Patient.telecom.system.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.telecom.use.exists()</span>
        <code class="testscript-technical">expression = Patient.telecom.use.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.telecom.value.exists()</span>
        <code class="testscript-technical">expression = Patient.telecom.value.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.gender.exists()</span>
        <code class="testscript-technical">expression = Patient.gender.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.birthDate.exists()</span>
        <code class="testscript-technical">expression = Patient.birthDate.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.address.exists()</span>
        <code class="testscript-technical">expression = Patient.address.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.communication.exists()</span>
        <code class="testscript-technical">expression = Patient.communication.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.communication.language.exists()</span>
        <code class="testscript-technical">expression = Patient.communication.language.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.communication.preferred.exists()</span>
        <code class="testscript-technical">expression = Patient.communication.preferred.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.extension.where(url = 'http://hl7.org.au/fhir/StructureDefinition/indigenous-status').exists()</span>
        <code class="testscript-technical">expression = Patient.extension.where(url = 'http://hl7.org.au/fhir/StructureDefinition/indigenous-status').exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/individual-genderIdentity').exists()</span>
        <code class="testscript-technical">expression = Patient.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/individual-genderIdentity').exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/individual-pronouns').exists()</span>
        <code class="testscript-technical">expression = Patient.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/individual-pronouns').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Patient by id (${patientId})</span>
        <code class="testscript-technical">READ Patient/${patientId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-patient</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-patient</code>
      </li>
    </ol>
  </section>
</section>
