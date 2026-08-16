<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core RelatedPerson — SHALL-level conformance</h1>
    <p class="testscript-description">Covers the AU Core RelatedPerson (2.0.0) requirements identified in fhirfrog/au-core-compiler#20: read, search by patient (SHALL), search by _id/name/relationship (SHOULD/MAY, included per the issue's explicit call-out of all four params — see fhirfrog/au-core-compiler#17 for the equivalent Practitioner-level precedent of including SHOULD/MAY searches when an issue names them), must-support element presence (patient, relationship, name+use/text/family/given, telecom, address), and profile conformance validation. Mirrors au-fhir-core-inferno's RelatedPersonGroup (related_person_patient_search_test, related_person__id_search_test, related_person_name_search_test, related_person_relationship_search_test, related_person_read_test, related_person_validation_test, related_person_must_support_test); the patient+name and patient+relationship combinator variants and reference-resolution test are not replicated — see fhirfrog/au-core-compiler#6 for the general scope rationale. No obligation-extension or negative-testing complexity is exercised here (unlike fhirfrog/au-core-compiler#21/#22): plain must-support presence checks are sufficient per issue #20's own scoping.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCoreRelatedPerson</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-relatedperson</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>relatedperson-patient-fixture</code>: au-core-relatedperson-patient (created before, and removed after, the run)</li>
      <li><code>relatedperson-fixture</code>: au-core-relatedperson-conformant (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${relatedPersonId}</code> = RelatedPerson.id of relatedperson-fixture</li>
      <li><code>${patientId}</code> = Patient.id of relatedperson-patient-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read RelatedPerson by id (${relatedPersonId})</span>
        <code class="testscript-technical">READ RelatedPerson/${relatedPersonId}</code>
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
        <span class="testscript-narrative">Search RelatedPerson where patient = Patient/${patientId}</span>
        <code class="testscript-technical">SEARCH RelatedPerson?patient=Patient/${patientId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(RelatedPerson).name.family.where($this = 'Banks').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(RelatedPerson).name.family.where($this = 'Banks').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchById</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search RelatedPerson where _id = ${relatedPersonId}</span>
        <code class="testscript-technical">SEARCH RelatedPerson?_id=${relatedPersonId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(RelatedPerson).name.family.where($this = 'Banks').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(RelatedPerson).name.family.where($this = 'Banks').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByName</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search RelatedPerson where name = Banks</span>
        <code class="testscript-technical">SEARCH RelatedPerson?name=Banks</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(RelatedPerson).name.family.where($this = 'Banks').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(RelatedPerson).name.family.where($this = 'Banks').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByRelationship</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search RelatedPerson where relationship = http://terminology.hl7.org/CodeSystem/v3-RoleCode|FTH</span>
        <code class="testscript-technical">SEARCH RelatedPerson?relationship=http://terminology.hl7.org/CodeSystem/v3-RoleCode|FTH</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(RelatedPerson).relationship.coding.code.where($this = 'FTH').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(RelatedPerson).relationship.coding.code.where($this = 'FTH').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupport</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read RelatedPerson by id (${relatedPersonId})</span>
        <code class="testscript-technical">READ RelatedPerson/${relatedPersonId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: RelatedPerson.patient.exists()</span>
        <code class="testscript-technical">expression = RelatedPerson.patient.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: RelatedPerson.relationship.exists()</span>
        <code class="testscript-technical">expression = RelatedPerson.relationship.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: RelatedPerson.name.exists()</span>
        <code class="testscript-technical">expression = RelatedPerson.name.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: RelatedPerson.name.use.exists()</span>
        <code class="testscript-technical">expression = RelatedPerson.name.use.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: RelatedPerson.name.text.exists()</span>
        <code class="testscript-technical">expression = RelatedPerson.name.text.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: RelatedPerson.name.family.exists()</span>
        <code class="testscript-technical">expression = RelatedPerson.name.family.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: RelatedPerson.name.given.exists()</span>
        <code class="testscript-technical">expression = RelatedPerson.name.given.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: RelatedPerson.telecom.exists()</span>
        <code class="testscript-technical">expression = RelatedPerson.telecom.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: RelatedPerson.address.exists()</span>
        <code class="testscript-technical">expression = RelatedPerson.address.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read RelatedPerson by id (${relatedPersonId})</span>
        <code class="testscript-technical">READ RelatedPerson/${relatedPersonId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-relatedperson</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-relatedperson</code>
      </li>
    </ol>
  </section>
</section>
