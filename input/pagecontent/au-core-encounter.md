<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core Encounter — SHALL-level conformance</h1>
    <p class="testscript-description">Covers the SHALL-level AU Core Encounter (2.0.0) requirements: read, search by patient, the SHALL search-combo patient+date, must-support element presence, and profile conformance validation. Mirrors the SHALL subset of au-fhir-core-inferno's EncounterGroup (encounter_read_test, encounter_patient_search_test, encounter_date_patient_search_test, encounter_must_support_test, encounter_validation_test). Per fhirfrog/au-core-compiler#9, two SHOULD/MAY-level combinatorial search tests are additionally included — SearchByDateMultipleAnd (date=ge...&amp;date=le..., encounter_date_multiple_and_search_test) and SearchByStatusMultipleOr (status=a,b, encounter_status_multiple_or_search_test) — because Inferno's generated group configures multi-and/multi-or combos specifically for Encounter's clinical-date and status search parameters and issue #9 calls these out by name; this is a deliberate, narrow exception to the SHALL-only scope rationale used for Patient (#6) and Condition (#8). The remaining SHOULD/MAY-level searches (status, date, class, class+patient, patient+status, patient+location, location) and the reference-resolution test are not replicated here.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCoreEncounter</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-encounter</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>patient-fixture</code>: au-core-patient-conformant (created before, and removed after, the run)</li>
      <li><code>frog-participant</code>: au-core-encounter-participant (created before, and removed after, the run)</li>
      <li><code>frog-location</code>: au-core-encounter-location (created before, and removed after, the run)</li>
      <li><code>frog-service-provider</code>: au-core-encounter-service-provider (created before, and removed after, the run)</li>
      <li><code>frog-reason-condition</code>: au-core-encounter-reason-condition (created before, and removed after, the run)</li>
      <li><code>encounter-fixture</code>: au-core-encounter-conformant (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${patientId}</code> = Patient.id of patient-fixture</li>
      <li><code>${encounterId}</code> = Encounter.id of encounter-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Encounter by id (${encounterId})</span>
        <code class="testscript-technical">READ Encounter/${encounterId}</code>
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
        <span class="testscript-narrative">Search Encounter where patient = ${patientId}</span>
        <code class="testscript-technical">SEARCH Encounter?patient=${patientId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Encounter).class.code.where($this = 'AMB').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Encounter).class.code.where($this = 'AMB').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByPatientAndDate</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Encounter where patient = ${patientId} and date = 2024-03-01</span>
        <code class="testscript-technical">SEARCH Encounter?patient=${patientId}&amp;date=2024-03-01</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Encounter).status.where($this = 'finished').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Encounter).status.where($this = 'finished').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByDateMultipleAnd</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Encounter where date = ge2020-01-01 and date = le2030-01-01</span>
        <code class="testscript-technical">SEARCH Encounter?date=ge2020-01-01&amp;date=le2030-01-01</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Encounter).status.where($this = 'finished').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Encounter).status.where($this = 'finished').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByStatusMultipleOr</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Encounter where status = in-progress,finished</span>
        <code class="testscript-technical">SEARCH Encounter?status=in-progress,finished</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Encounter).status.where($this = 'finished').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Encounter).status.where($this = 'finished').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupport</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Encounter by id (${encounterId})</span>
        <code class="testscript-technical">READ Encounter/${encounterId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Encounter.status.exists()</span>
        <code class="testscript-technical">expression = Encounter.status.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Encounter.class.exists()</span>
        <code class="testscript-technical">expression = Encounter.class.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Encounter.subject.exists()</span>
        <code class="testscript-technical">expression = Encounter.subject.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Encounter.participant.exists()</span>
        <code class="testscript-technical">expression = Encounter.participant.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Encounter.participant.individual.exists()</span>
        <code class="testscript-technical">expression = Encounter.participant.individual.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Encounter.participant.type.exists()</span>
        <code class="testscript-technical">expression = Encounter.participant.type.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Encounter.period.exists()</span>
        <code class="testscript-technical">expression = Encounter.period.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Encounter.reasonCode.exists()</span>
        <code class="testscript-technical">expression = Encounter.reasonCode.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Encounter.reasonReference.exists()</span>
        <code class="testscript-technical">expression = Encounter.reasonReference.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Encounter.location.exists()</span>
        <code class="testscript-technical">expression = Encounter.location.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Encounter.location.location.exists()</span>
        <code class="testscript-technical">expression = Encounter.location.location.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Encounter.serviceProvider.exists()</span>
        <code class="testscript-technical">expression = Encounter.serviceProvider.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Encounter.serviceType.exists()</span>
        <code class="testscript-technical">expression = Encounter.serviceType.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Encounter by id (${encounterId})</span>
        <code class="testscript-technical">READ Encounter/${encounterId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-encounter</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-encounter</code>
      </li>
    </ol>
  </section>
</section>
