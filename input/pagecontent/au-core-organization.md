<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core Organization — SHALL-level conformance</h1>
    <p class="testscript-description">Covers the SHALL-level AU Core Organization (2.0.0) requirements: read, search by identifier, search by name, must-support element presence (including identifier slice-presence checks for HPI-O and ABN), and profile conformance validation. Mirrors the SHALL subset of au-fhir-core-inferno's OrganizationGroup (organization_read_test, organization_identifier_search_test, organization_name_search_test, organization_must_support_test, organization_validation_test) — the SHOULD-level searches (_id, address) and the SHOULD-level identifier-slice-specific searches (organization_identifier_hpio_search_test, organization_identifier_abn_search_test) are not replicated as separate search tests here, consistent with fhirfrog/au-core-compiler#6 scope rationale. The HPI-O/ABN identifier slice presence that those SHOULD-level search tests would otherwise exercise is instead covered directly via FHIRPath assertions in the MustSupport test against a fixture carrying both slices; see fhirfrog/au-core-compiler#16.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCoreOrganization</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-organization</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>organization-fixture</code>: au-core-organization-conformant (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${organizationId}</code> = Organization.id of organization-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Organization by id (${organizationId})</span>
        <code class="testscript-technical">READ Organization/${organizationId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByIdentifier</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Organization where identifier = http://ns.electronichealth.net.au/id/hi/hpio/1.0|8003620000000013</span>
        <code class="testscript-technical">SEARCH Organization?identifier=http://ns.electronichealth.net.au/id/hi/hpio/1.0|8003620000000013</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Organization).name.where($this.contains('Frog')).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Organization).name.where($this.contains('Frog')).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByName</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Organization where name = Frog</span>
        <code class="testscript-technical">SEARCH Organization?name=Frog</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Organization).name.where($this.contains('Frog')).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Organization).name.where($this.contains('Frog')).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupport</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Organization by id (${organizationId})</span>
        <code class="testscript-technical">READ Organization/${organizationId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Organization.identifier.exists()</span>
        <code class="testscript-technical">expression = Organization.identifier.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Organization.identifier.where(system = 'http://ns.electronichealth.net.au/id/hi/hpio/1.0').exists()</span>
        <code class="testscript-technical">expression = Organization.identifier.where(system = 'http://ns.electronichealth.net.au/id/hi/hpio/1.0').exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Organization.identifier.where(system = 'http://hl7.org.au/id/abn').exists()</span>
        <code class="testscript-technical">expression = Organization.identifier.where(system = 'http://hl7.org.au/id/abn').exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Organization.type.exists()</span>
        <code class="testscript-technical">expression = Organization.type.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Organization.name.exists()</span>
        <code class="testscript-technical">expression = Organization.name.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Organization.telecom.exists()</span>
        <code class="testscript-technical">expression = Organization.telecom.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Organization.telecom.system.exists()</span>
        <code class="testscript-technical">expression = Organization.telecom.system.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Organization.telecom.value.exists()</span>
        <code class="testscript-technical">expression = Organization.telecom.value.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Organization.address.exists()</span>
        <code class="testscript-technical">expression = Organization.address.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Organization by id (${organizationId})</span>
        <code class="testscript-technical">READ Organization/${organizationId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-organization</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-organization</code>
      </li>
    </ol>
  </section>
</section>
