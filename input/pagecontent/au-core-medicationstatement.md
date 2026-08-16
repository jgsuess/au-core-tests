<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core MedicationStatement — SHALL-level conformance</h1>
    <p class="testscript-description">Covers the SHALL-level AU Core MedicationStatement (2.0.0) requirements: read, search by patient (SHALL), plus the single-parameter _id/effective/status searches called for by fhirfrog/au-core-compiler#15, must-support element presence, and profile conformance validation. Mirrors the SHALL subset of au-fhir-core-inferno's MedicationStatementGroup (medication_statement_read_test, medication_statement_patient_search_test, medication_statement__id_search_test, medication_statement_effective_search_test, medication_statement_status_search_test, medication_statement_must_support_test, medication_statement_validation_test) — the patient+status/patient+effective combinatorial searches and the identifier chain searches (dva/ihi/medicare) are not replicated here, matching the SHALL-only scope rationale from #6. Uses medicationCodeableConcept only (simpler than MedicationRequest's medication[x] case); the medicationReference must-support slice is therefore not exercised by this single-fixture set. Per #15, Inferno itself does not wire an inclusion-validation (_include) test for MedicationStatement, so no _include coverage is authored here either.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCoreMedicationStatement</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-medicationstatement</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>patient-fixture</code>: au-core-patient-conformant (created before, and removed after, the run)</li>
      <li><code>medicationstatement-reason-fixture</code>: au-core-medicationstatement-reason-condition (created before, and removed after, the run)</li>
      <li><code>medicationstatement-fixture</code>: au-core-medicationstatement-conformant (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${patientId}</code> = Patient.id of patient-fixture</li>
      <li><code>${medicationStatementId}</code> = MedicationStatement.id of medicationstatement-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read MedicationStatement by id (${medicationStatementId})</span>
        <code class="testscript-technical">READ MedicationStatement/${medicationStatementId}</code>
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
        <span class="testscript-narrative">Search MedicationStatement where patient = ${patientId}</span>
        <code class="testscript-technical">SEARCH MedicationStatement?patient=${patientId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(MedicationStatement).medication.ofType(CodeableConcept).text.where($this.contains('Bactrim')).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(MedicationStatement).medication.ofType(CodeableConcept).text.where($this.contains('Bactrim')).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchById</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search MedicationStatement where _id = ${medicationStatementId}</span>
        <code class="testscript-technical">SEARCH MedicationStatement?_id=${medicationStatementId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(MedicationStatement).status = 'active'</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(MedicationStatement).status = 'active'</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByEffective</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search MedicationStatement where effective = 2024-06-01</span>
        <code class="testscript-technical">SEARCH MedicationStatement?effective=2024-06-01</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(MedicationStatement).effective = '2024-06-01'</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(MedicationStatement).effective = '2024-06-01'</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByStatus</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search MedicationStatement where status = active</span>
        <code class="testscript-technical">SEARCH MedicationStatement?status=active</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(MedicationStatement).status = 'active'</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(MedicationStatement).status = 'active'</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupport</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read MedicationStatement by id (${medicationStatementId})</span>
        <code class="testscript-technical">READ MedicationStatement/${medicationStatementId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationStatement.status.exists()</span>
        <code class="testscript-technical">expression = MedicationStatement.status.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationStatement.medication.exists()</span>
        <code class="testscript-technical">expression = MedicationStatement.medication.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationStatement.medication.ofType(CodeableConcept).exists()</span>
        <code class="testscript-technical">expression = MedicationStatement.medication.ofType(CodeableConcept).exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationStatement.subject.exists()</span>
        <code class="testscript-technical">expression = MedicationStatement.subject.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationStatement.effective.exists()</span>
        <code class="testscript-technical">expression = MedicationStatement.effective.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationStatement.dateAsserted.exists()</span>
        <code class="testscript-technical">expression = MedicationStatement.dateAsserted.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationStatement.dosage.exists()</span>
        <code class="testscript-technical">expression = MedicationStatement.dosage.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationStatement.dosage.text.exists()</span>
        <code class="testscript-technical">expression = MedicationStatement.dosage.text.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationStatement.reasonCode.exists()</span>
        <code class="testscript-technical">expression = MedicationStatement.reasonCode.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: MedicationStatement.reasonReference.exists()</span>
        <code class="testscript-technical">expression = MedicationStatement.reasonReference.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read MedicationStatement by id (${medicationStatementId})</span>
        <code class="testscript-technical">READ MedicationStatement/${medicationStatementId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-medicationstatement</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-medicationstatement</code>
      </li>
    </ol>
  </section>
</section>
