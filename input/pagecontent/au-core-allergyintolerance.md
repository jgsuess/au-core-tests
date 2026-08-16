<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core AllergyIntolerance — SHALL-level conformance plus chained identifier search</h1>
    <p class="testscript-description">Covers the SHALL-level AU Core AllergyIntolerance (2.0.0) requirements: read, search by patient, must-support element presence, and profile conformance validation, plus a demonstration of the AU-specific chained patient.identifier (IHI) search that Inferno adds beyond generic us-core coverage. Also exercises the (MAY-level) standalone clinical-status search since it was explicitly called out for coverage in fhirfrog/au-core-compiler#7. Mirrors the relevant subset of au-fhir-core-inferno's AllergyIntoleranceGroup (allergy_intolerance_read_test, allergy_intolerance_patient_search_test, allergy_intolerance_clinical_status_search_test, allergy_intolerance_patient_ihi_chain_search_test, allergy_intolerance_must_support_test, allergy_intolerance_validation_test) — the SHOULD-level combined patient+clinical-status search, the Medicare/DVA chain variants (structurally identical to the IHI chain demonstrated here), the POST-search variant, and the reference-resolution test are not replicated; see fhirfrog/au-core-compiler#7 for scope rationale, following #6's precedent.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCoreAllergyIntolerance</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-allergyintolerance</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>patient-fixture</code>: au-core-patient-conformant (created before, and removed after, the run)</li>
      <li><code>allergyintolerance-fixture</code>: au-core-allergyintolerance-conformant (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${patientId}</code> = Patient.id of patient-fixture</li>
      <li><code>${allergyIntoleranceId}</code> = AllergyIntolerance.id of allergyintolerance-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read AllergyIntolerance by id (${allergyIntoleranceId})</span>
        <code class="testscript-technical">READ AllergyIntolerance/${allergyIntoleranceId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByPatient</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search AllergyIntolerance where patient = ${patientId}</span>
        <code class="testscript-technical">SEARCH AllergyIntolerance?patient=${patientId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(AllergyIntolerance).note.text.where($this.contains('Frog')).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(AllergyIntolerance).note.text.where($this.contains('Frog')).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByClinicalStatus</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search AllergyIntolerance where clinical-status = http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical|active</span>
        <code class="testscript-technical">SEARCH AllergyIntolerance?clinical-status=http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical|active</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(AllergyIntolerance).note.text.where($this.contains('Frog')).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(AllergyIntolerance).note.text.where($this.contains('Frog')).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByPatientIdentifierIHIChain</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search AllergyIntolerance where patient.identifier = http://ns.electronichealth.net.au/id/hi/ihi/1.0|8003608833357361</span>
        <code class="testscript-technical">SEARCH AllergyIntolerance?patient.identifier=http://ns.electronichealth.net.au/id/hi/ihi/1.0|8003608833357361</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(AllergyIntolerance).note.text.where($this.contains('Frog')).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(AllergyIntolerance).note.text.where($this.contains('Frog')).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupport</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read AllergyIntolerance by id (${allergyIntoleranceId})</span>
        <code class="testscript-technical">READ AllergyIntolerance/${allergyIntoleranceId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: AllergyIntolerance.clinicalStatus.exists()</span>
        <code class="testscript-technical">expression = AllergyIntolerance.clinicalStatus.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: AllergyIntolerance.verificationStatus.exists()</span>
        <code class="testscript-technical">expression = AllergyIntolerance.verificationStatus.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: AllergyIntolerance.code.exists()</span>
        <code class="testscript-technical">expression = AllergyIntolerance.code.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: AllergyIntolerance.patient.exists()</span>
        <code class="testscript-technical">expression = AllergyIntolerance.patient.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: AllergyIntolerance.onset.exists()</span>
        <code class="testscript-technical">expression = AllergyIntolerance.onset.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: AllergyIntolerance.note.exists()</span>
        <code class="testscript-technical">expression = AllergyIntolerance.note.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: AllergyIntolerance.reaction.exists()</span>
        <code class="testscript-technical">expression = AllergyIntolerance.reaction.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: AllergyIntolerance.reaction.manifestation.exists()</span>
        <code class="testscript-technical">expression = AllergyIntolerance.reaction.manifestation.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: AllergyIntolerance.reaction.severity.exists()</span>
        <code class="testscript-technical">expression = AllergyIntolerance.reaction.severity.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read AllergyIntolerance by id (${allergyIntoleranceId})</span>
        <code class="testscript-technical">READ AllergyIntolerance/${allergyIntoleranceId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-allergyintolerance</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-allergyintolerance</code>
      </li>
    </ol>
  </section>
</section>
