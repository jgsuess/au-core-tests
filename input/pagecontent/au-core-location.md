<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core Location — SHALL-level conformance</h1>
    <p class="testscript-description">Covers the SHALL-level AU Core Location (2.0.0) requirements: read, search by each of the five documented search parameters (address, name, address-city, address-state, address-postalcode), must-support element presence, and profile conformance validation. Location is self-contained — no Patient reference is required for these search paths. Per fhirfrog/au-core-compiler#12, au-fhir-core-inferno's own LocationGroup only marks the name search as SHALL and treats address/address-city/address-state/address-postalcode as optional (SHOULD) single-param searches, with no dedicated first-class search test beyond that; the AU Core IG demands support for all five as part of the Location search capability, so this TestScript exercises all five explicitly rather than only mirroring Inferno's narrower baseline. As with au-core-patient (fhirfrog/au-core-compiler#6), this does not attempt Inferno's SHOULD/MAY-level combinatorial multi-param search coverage or MustSupport reference resolution (location_reference_resolution_test) — each search parameter gets one standalone test against the single fixture resource.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCoreLocation</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-location</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>location-organization-fixture</code>: au-core-location-organization (created before, and removed after, the run)</li>
      <li><code>location-fixture</code>: au-core-location-conformant (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${locationId}</code> = Location.id of location-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Location by id (${locationId})</span>
        <code class="testscript-technical">READ Location/${locationId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByAddress</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Location where address = Frogville</span>
        <code class="testscript-technical">SEARCH Location?address=Frogville</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Location).name.where($this.contains('Frog')).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Location).name.where($this.contains('Frog')).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByName</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Location where name = Frog</span>
        <code class="testscript-technical">SEARCH Location?name=Frog</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Location).name.where($this.contains('Frog')).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Location).name.where($this.contains('Frog')).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByAddressCity</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Location where address-city = Frogville</span>
        <code class="testscript-technical">SEARCH Location?address-city=Frogville</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Location).name.where($this.contains('Frog')).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Location).name.where($this.contains('Frog')).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByAddressState</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Location where address-state = NSW</span>
        <code class="testscript-technical">SEARCH Location?address-state=NSW</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Location).name.where($this.contains('Frog')).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Location).name.where($this.contains('Frog')).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByAddressPostalcode</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Location where address-postalcode = 2000</span>
        <code class="testscript-technical">SEARCH Location?address-postalcode=2000</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Location).name.where($this.contains('Frog')).exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Location).name.where($this.contains('Frog')).exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>MustSupport</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Location by id (${locationId})</span>
        <code class="testscript-technical">READ Location/${locationId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Location.address.exists()</span>
        <code class="testscript-technical">expression = Location.address.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Location.managingOrganization.exists()</span>
        <code class="testscript-technical">expression = Location.managingOrganization.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Location.name.exists()</span>
        <code class="testscript-technical">expression = Location.name.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Location.physicalType.exists()</span>
        <code class="testscript-technical">expression = Location.physicalType.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Location.type.exists()</span>
        <code class="testscript-technical">expression = Location.type.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Location by id (${locationId})</span>
        <code class="testscript-technical">READ Location/${locationId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-location</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-location</code>
      </li>
    </ol>
  </section>
</section>
