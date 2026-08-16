<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core Pathology Result Observation — search &amp; obligation-pair conformance</h1>
    <p class="testscript-description">Covers the AU Core Pathology Result Observation (au-core-diagnosticresult-path, 2.0.0) requirements identified in fhirfrog/au-core-compiler#22 (AUC-017): read, search by patient+code/patient+category/patient+category+date (mirroring au-fhir-core-inferno's diagnosticresult_path group), must-support presence across all 22 MS elements - including the category:lab (fixed http://terminology.hl7.org/CodeSystem/observation-category|laboratory) and category:specificDiscipline (extensible-bound to the AU THS pathology-diagnostic-service-category ValueSet, e.g. v2-0074|CH for Chemistry) slices - and profile conformance validation. Same obligation-pair split as fhirfrog/au-core-compiler#21's Diagnostic Result Observation TestScript: 'diagnosticresultpath-fixture' is the ordinary case (value[x], interpretation, specimen, referenceRange, and a component all known and populated), and 'diagnosticresultpath-absent-fixture' is the genuinely-not-known case (dataAbsentReason/component.dataAbsentReason instead of value[x]/component.value[x], satisfying the profile's au-core-obs-01 invariant, with hasMember linking back to the ordinary fixture as a panel would). ObligationNoError and ProfileValidationObligationPair exercise the same requester-side SHALL:no-error / au-core-obs-01 machine-checking this profile shares with #21 - see that TestScript's description for why this only became testable once fhirfrog/fhir-frog's AssertionEvaluator gained assert.responseCode support and OperationExecutor's executeSearch started catching BaseServerResponseException. Reference-resolution and the remaining SHOULD/MAY search variants are not replicated - see fhirfrog/au-core-compiler#6 for the general scope rationale.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCoreDiagnosticResultPath</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-diagnosticresult-path</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>patient-fixture</code>: au-core-patient-conformant (created before, and removed after, the run)</li>
      <li><code>diagnosticresultpath-fixture</code>: au-core-diagnosticresult-path-conformant (created before, and removed after, the run)</li>
      <li><code>diagnosticresultpath-absent-fixture</code>: au-core-diagnosticresult-path-absent (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${patientId}</code> = Patient.id of patient-fixture</li>
      <li><code>${pathResultId}</code> = Observation.id of diagnosticresultpath-fixture</li>
      <li><code>${pathResultAbsentId}</code> = Observation.id of diagnosticresultpath-absent-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Observation by id (${pathResultId})</span>
        <code class="testscript-technical">READ Observation/${pathResultId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByPatientCode</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Observation where patient = Patient/${patientId} and code = http://loinc.org|2951-2</span>
        <code class="testscript-technical">SEARCH Observation?patient=Patient/${patientId}&amp;code=http://loinc.org|2951-2</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Observation).code.coding.code.where($this = '2951-2').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Observation).code.coding.code.where($this = '2951-2').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByPatientCategory</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Observation where patient = Patient/${patientId} and category = http://terminology.hl7.org/CodeSystem/observation-category|laboratory</span>
        <code class="testscript-technical">SEARCH Observation?patient=Patient/${patientId}&amp;category=http://terminology.hl7.org/CodeSystem/observation-category|laboratory</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Observation).category.coding.code.where($this = 'laboratory').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Observation).category.coding.code.where($this = 'laboratory').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByPatientCategoryDate</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Observation where patient = Patient/${patientId} and category = http://terminology.hl7.org/CodeSystem/observation-category|laboratory and date = 2026-01-20</span>
        <code class="testscript-technical">SEARCH Observation?patient=Patient/${patientId}&amp;category=http://terminology.hl7.org/CodeSystem/observation-category|laboratory&amp;date=2026-01-20</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Observation).code.coding.code.where($this = '2951-2').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Observation).code.coding.code.where($this = '2951-2').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupport</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Observation by id (${pathResultId})</span>
        <code class="testscript-technical">READ Observation/${pathResultId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.status.exists()</span>
        <code class="testscript-technical">expression = Observation.status.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.category.exists()</span>
        <code class="testscript-technical">expression = Observation.category.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.category.coding.code.where($this = 'laboratory').exists()</span>
        <code class="testscript-technical">expression = Observation.category.coding.code.where($this = 'laboratory').exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.category.coding.system.where($this = 'http://terminology.hl7.org/CodeSystem/v2-0074').exists()</span>
        <code class="testscript-technical">expression = Observation.category.coding.system.where($this = 'http://terminology.hl7.org/CodeSystem/v2-0074').exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.code.exists()</span>
        <code class="testscript-technical">expression = Observation.code.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.subject.exists()</span>
        <code class="testscript-technical">expression = Observation.subject.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.effective.exists()</span>
        <code class="testscript-technical">expression = Observation.effective.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.performer.exists()</span>
        <code class="testscript-technical">expression = Observation.performer.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.value.exists()</span>
        <code class="testscript-technical">expression = Observation.value.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.interpretation.exists()</span>
        <code class="testscript-technical">expression = Observation.interpretation.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.specimen.exists()</span>
        <code class="testscript-technical">expression = Observation.specimen.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.referenceRange.exists()</span>
        <code class="testscript-technical">expression = Observation.referenceRange.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.referenceRange.low.exists()</span>
        <code class="testscript-technical">expression = Observation.referenceRange.low.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.referenceRange.high.exists()</span>
        <code class="testscript-technical">expression = Observation.referenceRange.high.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.referenceRange.type.exists()</span>
        <code class="testscript-technical">expression = Observation.referenceRange.type.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.referenceRange.text.exists()</span>
        <code class="testscript-technical">expression = Observation.referenceRange.text.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.component.exists()</span>
        <code class="testscript-technical">expression = Observation.component.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.component.code.exists()</span>
        <code class="testscript-technical">expression = Observation.component.code.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.component.value.exists()</span>
        <code class="testscript-technical">expression = Observation.component.value.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupportObligationPair</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Observation by id (${pathResultAbsentId})</span>
        <code class="testscript-technical">READ Observation/${pathResultAbsentId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.dataAbsentReason.exists()</span>
        <code class="testscript-technical">expression = Observation.dataAbsentReason.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.component.dataAbsentReason.exists()</span>
        <code class="testscript-technical">expression = Observation.component.dataAbsentReason.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.hasMember.exists()</span>
        <code class="testscript-technical">expression = Observation.hasMember.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ObligationNoError</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Observation where patient = Patient/${patientId} and code = http://loinc.org|718-7</span>
        <code class="testscript-technical">SEARCH Observation?patient=Patient/${patientId}&amp;code=http://loinc.org|718-7</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response HTTP status code is 200</span>
        <code class="testscript-technical">responseCode = 200</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Observation).dataAbsentReason.coding.code.where($this = 'not-performed').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Observation).dataAbsentReason.coding.code.where($this = 'not-performed').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Observation by id (${pathResultId})</span>
        <code class="testscript-technical">READ Observation/${pathResultId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-diagnosticresult-path</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-diagnosticresult-path</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidationObligationPair</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Observation by id (${pathResultAbsentId})</span>
        <code class="testscript-technical">READ Observation/${pathResultAbsentId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-diagnosticresult-path</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-diagnosticresult-path</code>
      </li>
    </ol>
  </section>
</section>
