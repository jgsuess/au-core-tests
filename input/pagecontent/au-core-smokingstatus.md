<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core Smoking Status — SHALL-level conformance</h1>
    <p class="testscript-description">Covers the AU Core Smoking Status Observation (au-core-smokingstatus, 2.0.0) requirements identified in fhirfrog/au-core-compiler#24 (AUC-026): read, search by patient+code/patient+category/patient+category+date (mirroring au-fhir-core-inferno's smokingstatus group), must-support element presence across all 8 MS elements (status, category, category:socialHistory, code, subject, effective[x], value[x], dataAbsentReason), and profile conformance validation. Both category (fixed social-history) and code (fixed SNOMED 1747861000168109 'Tobacco smoking status') are pattern-constrained to a single value by the profile itself, so both fixtures share identical category/code - only value[x] vs dataAbsentReason differs between them, mirroring the profile's au-core-obs-01 condition on value[x] (value or dataAbsentReason must be present). Per issue #24's own scoping call, this profile has no obligation-extension or negative-testing complexity beyond that presence pairing - unlike fhirfrog/au-core-compiler#21/#22, no dedicated ObligationNoError/responseCode test is included here, matching the simpler pattern already established for fhirfrog/au-core-compiler#6-#20.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCoreSmokingStatus</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-smokingstatus</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>patient-fixture</code>: au-core-patient-conformant (created before, and removed after, the run)</li>
      <li><code>smokingstatus-fixture</code>: au-core-smokingstatus-conformant (created before, and removed after, the run)</li>
      <li><code>smokingstatus-absent-fixture</code>: au-core-smokingstatus-absent (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${patientId}</code> = Patient.id of patient-fixture</li>
      <li><code>${smokingStatusId}</code> = Observation.id of smokingstatus-fixture</li>
      <li><code>${smokingStatusAbsentId}</code> = Observation.id of smokingstatus-absent-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Observation by id (${smokingStatusId})</span>
        <code class="testscript-technical">READ Observation/${smokingStatusId}</code>
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
        <span class="testscript-narrative">Search Observation where patient = Patient/${patientId} and code = http://snomed.info/sct|1747861000168109</span>
        <code class="testscript-technical">SEARCH Observation?patient=Patient/${patientId}&amp;code=http://snomed.info/sct|1747861000168109</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Observation).code.coding.code.where($this = '1747861000168109').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Observation).code.coding.code.where($this = '1747861000168109').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByPatientCategory</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Observation where patient = Patient/${patientId} and category = http://terminology.hl7.org/CodeSystem/observation-category|social-history</span>
        <code class="testscript-technical">SEARCH Observation?patient=Patient/${patientId}&amp;category=http://terminology.hl7.org/CodeSystem/observation-category|social-history</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Observation).category.coding.code.where($this = 'social-history').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Observation).category.coding.code.where($this = 'social-history').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByPatientCategoryDate</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Observation where patient = Patient/${patientId} and category = http://terminology.hl7.org/CodeSystem/observation-category|social-history and date = 2026-01-10</span>
        <code class="testscript-technical">SEARCH Observation?patient=Patient/${patientId}&amp;category=http://terminology.hl7.org/CodeSystem/observation-category|social-history&amp;date=2026-01-10</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Observation).code.coding.code.where($this = '1747861000168109').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Observation).code.coding.code.where($this = '1747861000168109').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupport</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Observation by id (${smokingStatusId})</span>
        <code class="testscript-technical">READ Observation/${smokingStatusId}</code>
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
        <span class="testscript-narrative">Check: Observation.category.coding.code.where($this = 'social-history').exists()</span>
        <code class="testscript-technical">expression = Observation.category.coding.code.where($this = 'social-history').exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.code.coding.code.where($this = '1747861000168109').exists()</span>
        <code class="testscript-technical">expression = Observation.code.coding.code.where($this = '1747861000168109').exists()</code>
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
        <span class="testscript-narrative">Check: Observation.value.exists()</span>
        <code class="testscript-technical">expression = Observation.value.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupportAbsent</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Observation by id (${smokingStatusAbsentId})</span>
        <code class="testscript-technical">READ Observation/${smokingStatusAbsentId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.dataAbsentReason.exists()</span>
        <code class="testscript-technical">expression = Observation.dataAbsentReason.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Observation by id (${smokingStatusId})</span>
        <code class="testscript-technical">READ Observation/${smokingStatusId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-smokingstatus</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-smokingstatus</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidationAbsent</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Observation by id (${smokingStatusAbsentId})</span>
        <code class="testscript-technical">READ Observation/${smokingStatusAbsentId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-smokingstatus</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-smokingstatus</code>
      </li>
    </ol>
  </section>
</section>
