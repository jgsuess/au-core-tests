<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core Immunization — SHALL-level conformance plus vaccineCode slice coverage</h1>
    <p class="testscript-description">Covers the SHALL-level AU Core Immunization (2.0.0) requirements: read, search by patient, the SHALL search-combo patient+status, must-support element presence (including FHIRPath presence checks for the vaccineCode.coding:amtVaccineCode and vaccineCode.coding:airVaccineCode slices), and profile conformance validation. Reuses the shared au-core-patient-conformant fixture for the patient reference. Mirrors the SHALL subset of au-fhir-core-inferno's ImmunizationGroup (immunization_read_test, immunization_patient_search_test, immunization_patient_status_search_test, immunization_must_support_test, immunization_validation_test). Also includes standalone (MAY-level) SearchByDate and SearchByVaccineCode tests since date/status/vaccine-code/patient search were explicitly named in fhirfrog/au-core-compiler#11 — following the precedent set in #7/#8 of demonstrating an explicitly-called-out MAY/SHOULD-level mechanism alongside the SHALL-only core. The remaining SHOULD/MAY-level combinatorial coverage (patient+date, patient+vaccine-code, vaccine-code multiple-or, date multiple-and, the DVA/IHI/Medicare patient identifier chain searches, and the reference-resolution test) is not replicated here; see fhirfrog/au-core-compiler#6 for the original SHALL-only scope rationale. The amtVaccineCode and airVaccineCode slices are discriminated in the AU Core StructureDefinition by a pattern/$this rule bound to the amt-vaccine-1 and australian-immunisation-register-vaccine-1 ValueSets respectively rather than by a fixed coding.system element; in practice AMT codes are carried on the http://snomed.info/sct system and AIR codes on the https://www.humanservices.gov.au/organisations/health-professionals/enablers/air-vaccine-code-formats system (confirmed against the published au-core-immunization example Immunization-covid-1), so slice presence is asserted via a coding.where(system=...) FHIRPath check against those two systems.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCoreImmunization</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-immunization</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>patient-fixture</code>: au-core-patient-conformant (created before, and removed after, the run)</li>
      <li><code>immunization-fixture</code>: au-core-immunization-conformant (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${patientId}</code> = Patient.id of patient-fixture</li>
      <li><code>${immunizationId}</code> = Immunization.id of immunization-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Immunization by id (${immunizationId})</span>
        <code class="testscript-technical">READ Immunization/${immunizationId}</code>
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
        <span class="testscript-narrative">Search Immunization where patient = ${patientId}</span>
        <code class="testscript-technical">SEARCH Immunization?patient=${patientId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Immunization).note.text.where($this.contains('Frog')).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Immunization).note.text.where($this.contains('Frog')).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByPatientAndStatus</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Immunization where patient = ${patientId} and status = completed</span>
        <code class="testscript-technical">SEARCH Immunization?patient=${patientId}&amp;status=completed</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Immunization).status.where($this = 'completed').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Immunization).status.where($this = 'completed').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByDate</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Immunization where date = ge2020-01-01</span>
        <code class="testscript-technical">SEARCH Immunization?date=ge2020-01-01</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Immunization).note.text.exists($this.contains('Frog'))</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Immunization).note.text.exists($this.contains('Frog'))</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByVaccineCode</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Immunization where vaccine-code = https://www.humanservices.gov.au/organisations/health-professionals/enablers/air-vaccine-code-formats|COMIRN</span>
        <code class="testscript-technical">SEARCH Immunization?vaccine-code=https://www.humanservices.gov.au/organisations/health-professionals/enablers/air-vaccine-code-formats|COMIRN</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Immunization).vaccineCode.coding.where(code = 'COMIRN').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Immunization).vaccineCode.coding.where(code = 'COMIRN').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupport</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Immunization by id (${immunizationId})</span>
        <code class="testscript-technical">READ Immunization/${immunizationId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Immunization.status.exists()</span>
        <code class="testscript-technical">expression = Immunization.status.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Immunization.vaccineCode.exists()</span>
        <code class="testscript-technical">expression = Immunization.vaccineCode.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Immunization.vaccineCode.coding.where(system = 'http://snomed.info/sct').exists()</span>
        <code class="testscript-technical">expression = Immunization.vaccineCode.coding.where(system = 'http://snomed.info/sct').exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Immunization.vaccineCode.coding.where(system = 'https://www.humanservices.gov.au/organisations/health-professionals/enablers/air-vaccine-code-formats').exists()</span>
        <code class="testscript-technical">expression = Immunization.vaccineCode.coding.where(system = 'https://www.humanservices.gov.au/organisations/health-professionals/enablers/air-vaccine-code-formats').exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Immunization.patient.exists()</span>
        <code class="testscript-technical">expression = Immunization.patient.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Immunization.occurrence.ofType(dateTime).exists()</span>
        <code class="testscript-technical">expression = Immunization.occurrence.ofType(dateTime).exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Immunization.primarySource.exists()</span>
        <code class="testscript-technical">expression = Immunization.primarySource.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Immunization.lotNumber.exists()</span>
        <code class="testscript-technical">expression = Immunization.lotNumber.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Immunization.note.exists()</span>
        <code class="testscript-technical">expression = Immunization.note.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Immunization by id (${immunizationId})</span>
        <code class="testscript-technical">READ Immunization/${immunizationId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-immunization</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-immunization</code>
      </li>
    </ol>
  </section>
</section>
