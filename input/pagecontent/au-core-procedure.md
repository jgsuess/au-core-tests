<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core Procedure — SHALL-level conformance</h1>
    <p class="testscript-description">Covers the AU Core Procedure (2.0.0) requirements: read, search by patient (SHALL), search by code/date/status (individually MAY-level in AU Core, but included here because issue #19 explicitly calls for code/date/status/patient search coverage on the generic search mechanism, following the same precedent as fhirfrog/au-core-compiler#17's Practitioner TestScript), must-support element presence, and profile conformance validation. Mirrors the relevant subset of au-fhir-core-inferno's ProcedureGroup (procedure_read_test, procedure_patient_search_test, procedure_code_search_test, procedure_date_search_test, procedure_status_search_test, procedure_must_support_test, procedure_validation_test). The combinatorial SHOULD/MAY search tests (patient+date, patient+status, patient+code+date, multiple-or on code/status, multiple-and on date, the DVA/IHI/Medicare identifier chain searches on patient, and the reference-resolution test) are not replicated here, per the same scope rationale used for Patient/Condition/Organization/Practitioner; see fhirfrog/au-core-compiler#6 and #19.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCoreProcedure</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-procedure</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>patient-fixture</code>: au-core-patient-conformant (created before, and removed after, the run)</li>
      <li><code>procedure-fixture</code>: au-core-procedure-conformant (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${patientId}</code> = Patient.id of patient-fixture</li>
      <li><code>${procedureId}</code> = Procedure.id of procedure-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Procedure by id (${procedureId})</span>
        <code class="testscript-technical">READ Procedure/${procedureId}</code>
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
        <span class="testscript-narrative">Search Procedure where patient = ${patientId}</span>
        <code class="testscript-technical">SEARCH Procedure?patient=${patientId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Procedure).code.coding.code.where($this = '80146002').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Procedure).code.coding.code.where($this = '80146002').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByCode</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Procedure where code = http://snomed.info/sct|80146002</span>
        <code class="testscript-technical">SEARCH Procedure?code=http://snomed.info/sct|80146002</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Procedure).code.coding.code.where($this = '80146002').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Procedure).code.coding.code.where($this = '80146002').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByDate</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Procedure where date = 2020-06-15</span>
        <code class="testscript-technical">SEARCH Procedure?date=2020-06-15</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Procedure).performed.ofType(dateTime).toString().where($this.contains('2020-06-15')).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Procedure).performed.ofType(dateTime).toString().where($this.contains('2020-06-15')).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByStatus</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Procedure where status = completed</span>
        <code class="testscript-technical">SEARCH Procedure?status=completed</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Procedure).status.where($this = 'completed').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Procedure).status.where($this = 'completed').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupport</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Procedure by id (${procedureId})</span>
        <code class="testscript-technical">READ Procedure/${procedureId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Procedure.code.exists()</span>
        <code class="testscript-technical">expression = Procedure.code.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Procedure.encounter.exists()</span>
        <code class="testscript-technical">expression = Procedure.encounter.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Procedure.performed.exists()</span>
        <code class="testscript-technical">expression = Procedure.performed.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Procedure.reasonCode.exists()</span>
        <code class="testscript-technical">expression = Procedure.reasonCode.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Procedure.reasonReference.exists()</span>
        <code class="testscript-technical">expression = Procedure.reasonReference.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Procedure.status.exists()</span>
        <code class="testscript-technical">expression = Procedure.status.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Procedure.subject.exists()</span>
        <code class="testscript-technical">expression = Procedure.subject.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Procedure by id (${procedureId})</span>
        <code class="testscript-technical">READ Procedure/${procedureId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-procedure</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-procedure</code>
      </li>
    </ol>
  </section>
</section>
