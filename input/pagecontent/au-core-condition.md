<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core Condition — SHALL-level conformance</h1>
    <p class="testscript-description">Covers the SHALL-level AU Core Condition (2.0.0) requirements: read, search by patient, the SHALL search-combos patient+category and patient+clinical-status, must-support element presence, and profile conformance validation, plus one SHOULD search-combo (patient+code) included to demonstrate the multi-param querystring pattern. Mirrors the SHALL subset of au-fhir-core-inferno's ConditionGroup (condition_read_test, condition_patient_search_test, condition_patient_category_search_test, condition_patient_clinical_status_search_test, condition_must_support_test, condition_validation_test). The remaining SHOULD/MAY-level combinatorial search tests (patient+category+clinical-status, patient+onset-date, code with multiple-or, onset-date with multiple-and, the DVA/IHI/Medicare identifier chain searches on patient, and the reference-resolution test) are not replicated here, per the same SHALL-only scope rationale used for Patient; see fhirfrog/au-core-compiler#6 and #8.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCoreCondition</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-condition</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>patient-fixture</code>: au-core-patient-conformant (created before, and removed after, the run)</li>
      <li><code>condition-fixture</code>: au-core-condition-conformant (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${patientId}</code> = Patient.id of patient-fixture</li>
      <li><code>${conditionId}</code> = Condition.id of condition-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Condition by id (${conditionId})</span>
        <code class="testscript-technical">READ Condition/${conditionId}</code>
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
        <span class="testscript-narrative">Search Condition where patient = ${patientId}</span>
        <code class="testscript-technical">SEARCH Condition?patient=${patientId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Condition).where(code.coding.code = '68566005').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Condition).where(code.coding.code = '68566005').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByPatientAndCategory</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Condition where patient = ${patientId} and category = http://terminology.hl7.org/CodeSystem/condition-category|problem-list-item</span>
        <code class="testscript-technical">SEARCH Condition?patient=${patientId}&amp;category=http://terminology.hl7.org/CodeSystem/condition-category|problem-list-item</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Condition).where(category.coding.code = 'problem-list-item').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Condition).where(category.coding.code = 'problem-list-item').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByPatientAndClinicalStatus</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Condition where patient = ${patientId} and clinical-status = http://terminology.hl7.org/CodeSystem/condition-clinical|resolved</span>
        <code class="testscript-technical">SEARCH Condition?patient=${patientId}&amp;clinical-status=http://terminology.hl7.org/CodeSystem/condition-clinical|resolved</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Condition).where(clinicalStatus.coding.code = 'resolved').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Condition).where(clinicalStatus.coding.code = 'resolved').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByPatientAndCode</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Condition where patient = ${patientId} and code = http://snomed.info/sct|68566005</span>
        <code class="testscript-technical">SEARCH Condition?patient=${patientId}&amp;code=http://snomed.info/sct|68566005</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Condition).where(code.coding.code = '68566005').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Condition).where(code.coding.code = '68566005').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupport</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Condition by id (${conditionId})</span>
        <code class="testscript-technical">READ Condition/${conditionId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Condition.clinicalStatus.exists()</span>
        <code class="testscript-technical">expression = Condition.clinicalStatus.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Condition.verificationStatus.exists()</span>
        <code class="testscript-technical">expression = Condition.verificationStatus.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Condition.category.exists()</span>
        <code class="testscript-technical">expression = Condition.category.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Condition.severity.exists()</span>
        <code class="testscript-technical">expression = Condition.severity.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Condition.code.exists()</span>
        <code class="testscript-technical">expression = Condition.code.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Condition.subject.exists()</span>
        <code class="testscript-technical">expression = Condition.subject.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Condition.onset.exists()</span>
        <code class="testscript-technical">expression = Condition.onset.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Condition.abatement.exists()</span>
        <code class="testscript-technical">expression = Condition.abatement.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Condition.note.exists()</span>
        <code class="testscript-technical">expression = Condition.note.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Condition by id (${conditionId})</span>
        <code class="testscript-technical">READ Condition/${conditionId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-condition</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-condition</code>
      </li>
    </ol>
  </section>
</section>
