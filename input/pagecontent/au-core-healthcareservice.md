<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core HealthcareService — SHALL-level conformance</h1>
    <p class="testscript-description">Covers the AU Core HealthcareService (2.0.0) requirements: read, search by name/identifier/_id/service-type, must-support element presence, and profile conformance validation. Mirrors au-fhir-core-inferno's HealthcareServiceGroup (healthcare_service_read_test, healthcare_service_name_search_test, healthcare_service_identifier_search_test, healthcare_service_id_search_test, healthcare_service_service_type_search_test, healthcare_service_must_support_test, healthcare_service_validation_test). Per fhirfrog/au-core-compiler#10, all four search parameters named in that issue (name/identifier/_id/service-type) are exercised as individual single-parameter search tests even though Inferno labels only the name search as SHALL for this resource (identifier, _id and service-type are SHOULD) — HealthcareService is a small, mostly generic-CRUD profile, so this TestScript still keeps to the SHALL-level scope rationale from #6 by testing each search parameter once in isolation rather than replicating Inferno's SHOULD/MAY combinatorial and chained-search coverage. HealthcareService has no mandatory reference to Patient or any other resource, so the fixture below is fully self-contained.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCoreHealthcareService</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-healthcareservice</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>healthcareservice-fixture</code>: au-core-healthcareservice-conformant (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${healthcareServiceId}</code> = HealthcareService.id of healthcareservice-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read HealthcareService by id (${healthcareServiceId})</span>
        <code class="testscript-technical">READ HealthcareService/${healthcareServiceId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByName</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search HealthcareService where name = Frog</span>
        <code class="testscript-technical">SEARCH HealthcareService?name=Frog</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(HealthcareService).name.where($this.contains('Frog')).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(HealthcareService).name.where($this.contains('Frog')).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByIdentifier</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search HealthcareService where identifier = http://pca.digitalhealth.gov.au/id/pca-healthcare-service|4d00ad2659cb4b54bd8028798af62631</span>
        <code class="testscript-technical">SEARCH HealthcareService?identifier=http://pca.digitalhealth.gov.au/id/pca-healthcare-service|4d00ad2659cb4b54bd8028798af62631</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(HealthcareService).name.where($this.contains('Frog')).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(HealthcareService).name.where($this.contains('Frog')).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchById</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search HealthcareService where _id = ${healthcareServiceId}</span>
        <code class="testscript-technical">SEARCH HealthcareService?_id=${healthcareServiceId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(HealthcareService).name.where($this.contains('Frog')).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(HealthcareService).name.where($this.contains('Frog')).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByServiceType</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search HealthcareService where service-type = http://snomed.info/sct|722140001</span>
        <code class="testscript-technical">SEARCH HealthcareService?service-type=http://snomed.info/sct|722140001</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(HealthcareService).name.where($this.contains('Frog')).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(HealthcareService).name.where($this.contains('Frog')).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupport</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read HealthcareService by id (${healthcareServiceId})</span>
        <code class="testscript-technical">READ HealthcareService/${healthcareServiceId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: HealthcareService.identifier.exists()</span>
        <code class="testscript-technical">expression = HealthcareService.identifier.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: HealthcareService.type.exists()</span>
        <code class="testscript-technical">expression = HealthcareService.type.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: HealthcareService.name.exists()</span>
        <code class="testscript-technical">expression = HealthcareService.name.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: HealthcareService.telecom.exists()</span>
        <code class="testscript-technical">expression = HealthcareService.telecom.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read HealthcareService by id (${healthcareServiceId})</span>
        <code class="testscript-technical">READ HealthcareService/${healthcareServiceId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-healthcareservice</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-healthcareservice</code>
      </li>
    </ol>
  </section>
</section>
