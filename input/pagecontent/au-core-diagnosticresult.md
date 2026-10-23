<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core Diagnostic Result Observation — search &amp; obligation-pair conformance</h1>
    <p class="testscript-description">Covers the AU Core Diagnostic Result Observation (2.0.0) requirements identified in fhirfrog/au-core-compiler#21 (AUC-016): read, search by patient+code/patient+category/patient+category+date (mirroring au-fhir-core-inferno's DiagnosticresultGroup patient_code/patient_category/patient_category_date search tests), must-support element presence across all 14 MS elements (status, category, code, subject, effective[x], performer, value[x], dataAbsentReason, bodySite, hasMember, component, component.code, component.value[x], component.dataAbsentReason), and profile conformance validation. The 14 MS elements are split across two fixtures reflecting how AU Core's paired obligation extensions (SHALL:populate-if-known on the responder, SHALL:no-error on the requester) actually manifest: 'diagnosticresult-fixture' is the ordinary case (value[x] known and populated, plus a component sub-observation), and 'diagnosticresult-absent-fixture' is the case where the underlying result genuinely isn't known - dataAbsentReason/component.dataAbsentReason populated instead of value[x]/component.value[x] (satisfying the profile's au-core-obs-01 invariant), with hasMember linking back to the ordinary fixture as a panel would. The ObligationNoError test exercises the requester side directly: searching for the absent-value observation must still return a clean 200 (not an error) - this only became testable once fhirfrog/fhir-frog's AssertionEvaluator gained assert.responseCode support and OperationExecutor's executeSearch started catching BaseServerResponseException instead of letting it abort the run (see that engine commit for details). ProfileValidationObligationPair runs validateProfileId against the absent-value fixture specifically, which is what actually machine-checks the au-core-obs-01 invariant now that ProfileValidator's profileUrl handling is fixed (fhirfrog/au-core-compiler#6). Reference-resolution and the remaining SHOULD/MAY search variants (code/status/date multiple-OR, chained patient search, IHI/Medicare/DVA identifier chains) are not replicated - see fhirfrog/au-core-compiler#6 for the general scope rationale.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCoreDiagnosticResult</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-diagnosticresult</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>patient-fixture</code>: au-core-patient-conformant (created before, and removed after, the run)</li>
      <li><code>diagnosticresult-fixture</code>: au-core-diagnosticresult-conformant (created before, and removed after, the run)</li>
      <li><code>diagnosticresult-absent-fixture</code>: au-core-diagnosticresult-absent (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${patientId}</code> = Patient.id of patient-fixture</li>
      <li><code>${diagnosticResultId}</code> = Observation.id of diagnosticresult-fixture</li>
      <li><code>${diagnosticResultAbsentId}</code> = Observation.id of diagnosticresult-absent-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Observation by id (${diagnosticResultId})</span>
        <code class="testscript-technical">READ Observation/${diagnosticResultId}</code>
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
        <span class="testscript-narrative">Search Observation where patient = Patient/${patientId} and code = http://loinc.org|89024-4</span>
        <code class="testscript-technical">SEARCH Observation?patient=Patient/${patientId}&amp;code=http://loinc.org|89024-4</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Observation).code.coding.code.where($this = '89024-4').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Observation).code.coding.code.where($this = '89024-4').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByPatientCategory</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Observation where patient = Patient/${patientId} and category = http://terminology.hl7.org/CodeSystem/v2-0074|AU</span>
        <code class="testscript-technical">SEARCH Observation?patient=Patient/${patientId}&amp;category=http://terminology.hl7.org/CodeSystem/v2-0074|AU</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Observation).category.coding.code.where($this = 'AU').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Observation).category.coding.code.where($this = 'AU').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByPatientCategoryDate</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Observation where patient = Patient/${patientId} and category = http://terminology.hl7.org/CodeSystem/v2-0074|AU and date = 2026-01-15</span>
        <code class="testscript-technical">SEARCH Observation?patient=Patient/${patientId}&amp;category=http://terminology.hl7.org/CodeSystem/v2-0074|AU&amp;date=2026-01-15</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Observation).code.coding.code.where($this = '89024-4').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Observation).code.coding.code.where($this = '89024-4').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupport</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Observation by id (${diagnosticResultId})</span>
        <code class="testscript-technical">READ Observation/${diagnosticResultId}</code>
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
        <span class="testscript-narrative">Check: Observation.bodySite.exists()</span>
        <code class="testscript-technical">expression = Observation.bodySite.exists()</code>
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
        <span class="testscript-narrative">Read Observation by id (${diagnosticResultAbsentId})</span>
        <code class="testscript-technical">READ Observation/${diagnosticResultAbsentId}</code>
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
        <span class="testscript-narrative">Search Observation where patient = Patient/${patientId} and code = http://loinc.org|89016-0</span>
        <code class="testscript-technical">SEARCH Observation?patient=Patient/${patientId}&amp;code=http://loinc.org|89016-0</code>
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
        <span class="testscript-narrative">Read Observation by id (${diagnosticResultId})</span>
        <code class="testscript-technical">READ Observation/${diagnosticResultId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-diagnosticresult</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-diagnosticresult</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidationObligationPair</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Observation by id (${diagnosticResultAbsentId})</span>
        <code class="testscript-technical">READ Observation/${diagnosticResultAbsentId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-diagnosticresult</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-diagnosticresult</code>
      </li>
    </ol>
  </section>
</section>
