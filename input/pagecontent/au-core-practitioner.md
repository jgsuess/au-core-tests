<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core Practitioner — SHALL-level conformance</h1>
    <p class="testscript-description">Covers the AU Core Practitioner (2.0.0) requirements: read, search by _id, search by identifier (the fixture's identifier carries the HPI-I system http://ns.electronichealth.net.au/id/hi/hpii/1.0, so this same identifier search exercises the HPI-I slice — per fhirfrog/au-core-compiler#17, Inferno's separate HPI-I search test is functionally just a parameterised identifier search that fhir-frog's generic byUrl pass-through already handles, so no distinct test action is needed for it), search by name, must-support element presence, and profile conformance validation. Mirrors au-fhir-core-inferno's PractitionerGroup (practitioner_read_test, practitioner_id_search_test, practitioner_identifier_search_test, practitioner_identifier_hpii_search_test, practitioner_name_search_test, practitioner_must_support_test, practitioner_validation_test). The _id/name/identifier(HPI-I) searches are SHOULD-level in AU Core but are included here because issue #17 explicitly calls for _id/identifier/name coverage; their combinatorial SHOULD/MAY variants (chained params, GET/POST result-count comparisons, etc.) are not replicated — see fhirfrog/au-core-compiler#6 for the general scope rationale.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCorePractitioner</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-practitioner</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>practitioner-fixture</code>: au-core-practitioner-conformant (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${practitionerId}</code> = Practitioner.id of practitioner-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Practitioner by id (${practitionerId})</span>
        <code class="testscript-technical">READ Practitioner/${practitionerId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchById</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Practitioner where _id = ${practitionerId}</span>
        <code class="testscript-technical">SEARCH Practitioner?_id=${practitionerId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Practitioner).name.family.where($this = 'Frog').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Practitioner).name.family.where($this = 'Frog').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByIdentifier</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Practitioner where identifier = http://ns.electronichealth.net.au/id/hi/hpii/1.0|8003621234567890</span>
        <code class="testscript-technical">SEARCH Practitioner?identifier=http://ns.electronichealth.net.au/id/hi/hpii/1.0|8003621234567890</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Practitioner).name.family.where($this = 'Frog').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Practitioner).name.family.where($this = 'Frog').exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Practitioner).identifier.where(system = 'http://ns.electronichealth.net.au/id/hi/hpii/1.0').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Practitioner).identifier.where(system = 'http://ns.electronichealth.net.au/id/hi/hpii/1.0').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByName</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Practitioner where name = Frog</span>
        <code class="testscript-technical">SEARCH Practitioner?name=Frog</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Practitioner).name.family.where($this = 'Frog').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Practitioner).name.family.where($this = 'Frog').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupport</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Practitioner by id (${practitionerId})</span>
        <code class="testscript-technical">READ Practitioner/${practitionerId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Practitioner.identifier.exists()</span>
        <code class="testscript-technical">expression = Practitioner.identifier.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Practitioner.name.exists()</span>
        <code class="testscript-technical">expression = Practitioner.name.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Practitioner.name.family.exists()</span>
        <code class="testscript-technical">expression = Practitioner.name.family.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Practitioner.name.given.exists()</span>
        <code class="testscript-technical">expression = Practitioner.name.given.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Practitioner by id (${practitionerId})</span>
        <code class="testscript-technical">READ Practitioner/${practitionerId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-practitioner</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-practitioner</code>
      </li>
    </ol>
  </section>
</section>
