<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core PractitionerRole — core search &amp; profile conformance</h1>
    <p class="testscript-description">Covers the AU Core PractitionerRole (2.0.0) requirements identified in fhirfrog/au-core-compiler#18: read, search by _id/identifier/practitioner/specialty/role/organization, the AU-specific chained-practitioner search (practitioner:Practitioner.identifier) combined with _include=PractitionerRole:practitioner, must-support element presence, and profile conformance validation. Mirrors au-fhir-core-inferno's PractitionerRoleGroup (practitioner_role_read_test, practitioner_role__id_search_test, practitioner_role_identifier_search_test, practitioner_role_identifier_medicare_search_test, practitioner_role_practitioner_search_test, practitioner_role_specialty_search_test, practitioner_role_role_search_test, practitioner_role_organization_search_test, practitioner_role_practitioner_chain_search_test, practitioner_role_practitioner_include_practitioner_test, practitioner_role_must_support_test, practitioner_role_validation_test). Issue #18's premise is that the chained-practitioner SearchParameter and the Medicare identifier search are plain query-string parameters that fhir-frog's byUrl-pass-through search executor already handles generically, so this TestScript exercises each as a single representative query rather than replicating Inferno's full SHOULD/MAY combinatorial variants (GET/POST comparison, multiple AND/OR reference forms, reference-form-only variants) — see fhirfrog/au-core-compiler#6 for the equivalent Patient-level scope rationale. The identifier fixture carries a Medicare-provider-number-typed identifier so the plain identifier search doubles as the Medicare identifier search. Per the Bundle-validation-gap caveat noted on fhirfrog/au-core-compiler#14, validateProfileId is not attempted against the _include'd search Bundle; PractitionerRole profile conformance is instead checked via a separate plain read.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCorePractitionerRole</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-practitionerrole</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>practitionerrole-practitioner-fixture</code>: au-core-practitionerrole-practitioner (created before, and removed after, the run)</li>
      <li><code>practitionerrole-organization-fixture</code>: au-core-practitionerrole-organization (created before, and removed after, the run)</li>
      <li><code>practitionerrole-fixture</code>: au-core-practitionerrole-conformant (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${practitionerRoleId}</code> = PractitionerRole.id of practitionerrole-fixture</li>
      <li><code>${practitionerId}</code> = Practitioner.id of practitionerrole-practitioner-fixture</li>
      <li><code>${organizationId}</code> = Organization.id of practitionerrole-organization-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read PractitionerRole by id (${practitionerRoleId})</span>
        <code class="testscript-technical">READ PractitionerRole/${practitionerRoleId}</code>
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
        <span class="testscript-narrative">Search PractitionerRole where _id = ${practitionerRoleId}</span>
        <code class="testscript-technical">SEARCH PractitionerRole?_id=${practitionerRoleId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(PractitionerRole).code.coding.code.where($this = '62247001').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(PractitionerRole).code.coding.code.where($this = '62247001').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByIdentifier</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search PractitionerRole where identifier = http://ns.electronichealth.net.au/id/medicare-provider-number|2449001X</span>
        <code class="testscript-technical">SEARCH PractitionerRole?identifier=http://ns.electronichealth.net.au/id/medicare-provider-number|2449001X</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(PractitionerRole).identifier.value.where($this = '2449001X').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(PractitionerRole).identifier.value.where($this = '2449001X').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByPractitioner</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search PractitionerRole where practitioner = Practitioner/${practitionerId}</span>
        <code class="testscript-technical">SEARCH PractitionerRole?practitioner=Practitioner/${practitionerId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(PractitionerRole).code.coding.code.where($this = '62247001').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(PractitionerRole).code.coding.code.where($this = '62247001').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchBySpecialty</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search PractitionerRole where specialty = http://snomed.info/sct|408443003</span>
        <code class="testscript-technical">SEARCH PractitionerRole?specialty=http://snomed.info/sct|408443003</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(PractitionerRole).specialty.coding.code.where($this = '408443003').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(PractitionerRole).specialty.coding.code.where($this = '408443003').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByRole</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search PractitionerRole where role = http://snomed.info/sct|62247001</span>
        <code class="testscript-technical">SEARCH PractitionerRole?role=http://snomed.info/sct|62247001</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(PractitionerRole).code.coding.code.where($this = '62247001').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(PractitionerRole).code.coding.code.where($this = '62247001').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByOrganization</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search PractitionerRole where organization = Organization/${organizationId}</span>
        <code class="testscript-technical">SEARCH PractitionerRole?organization=Organization/${organizationId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(PractitionerRole).code.coding.code.where($this = '62247001').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(PractitionerRole).code.coding.code.where($this = '62247001').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ChainedPractitionerIncludePractitioner</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search PractitionerRole where practitioner:Practitioner.identifier = http://ns.electronichealth.net.au/id/hi/hpii/1.0|8003614900041692 and _include = PractitionerRole:practitioner</span>
        <code class="testscript-technical">SEARCH PractitionerRole?practitioner:Practitioner.identifier=http://ns.electronichealth.net.au/id/hi/hpii/1.0|8003614900041692&amp;_include=PractitionerRole:practitioner</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(PractitionerRole).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(PractitionerRole).exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Practitioner).name.family.where($this.contains('Frog')).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Practitioner).name.family.where($this.contains('Frog')).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupport</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read PractitionerRole by id (${practitionerRoleId})</span>
        <code class="testscript-technical">READ PractitionerRole/${practitionerRoleId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: PractitionerRole.identifier.exists()</span>
        <code class="testscript-technical">expression = PractitionerRole.identifier.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: PractitionerRole.practitioner.exists()</span>
        <code class="testscript-technical">expression = PractitionerRole.practitioner.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: PractitionerRole.organization.exists()</span>
        <code class="testscript-technical">expression = PractitionerRole.organization.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: PractitionerRole.code.exists()</span>
        <code class="testscript-technical">expression = PractitionerRole.code.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: PractitionerRole.specialty.exists()</span>
        <code class="testscript-technical">expression = PractitionerRole.specialty.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: PractitionerRole.telecom.exists()</span>
        <code class="testscript-technical">expression = PractitionerRole.telecom.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: PractitionerRole.telecom.system.exists()</span>
        <code class="testscript-technical">expression = PractitionerRole.telecom.system.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: PractitionerRole.telecom.value.exists()</span>
        <code class="testscript-technical">expression = PractitionerRole.telecom.value.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read PractitionerRole by id (${practitionerRoleId})</span>
        <code class="testscript-technical">READ PractitionerRole/${practitionerRoleId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-practitionerrole</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-practitionerrole</code>
      </li>
    </ol>
  </section>
</section>
