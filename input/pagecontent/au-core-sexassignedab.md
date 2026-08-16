<section class="testscript">
  <header class="testscript-header">
    <h1>AU Core Sex Assigned at Birth extension — presence &amp; profile conformance</h1>
    <p class="testscript-description">Covers the AU Core Sex Assigned at Birth extension (au-core-rsg-sexassignedab, 2.0.0) requirements identified in fhirfrog/au-core-compiler#25 (AUC-026). Correction to the issue's own framing, discovered while authoring this TestScript: au-core-rsg-sexassignedab is a *content-level* refinement of the generic individual-recordedSexOrGender extension, not a separately-URL'd one - its own snapshot fixes Extension.url to the base extension's canonical URL (http://hl7.org/fhir/StructureDefinition/individual-recordedSexOrGender), not its own. au-core-patient DOES inherit a Patient.extension:recordedSexOrGender slot from its au-patient (AU Base) baseDefinition (visible only in the snapshot, not the differential - which is why the original gap-analysis missed it), typed generically against individual-recordedSexOrGender rather than specifically against au-core-rsg-sexassignedab. So the real, narrower gap is: nothing distinguishes/tests the 'sex assigned at birth' flavour specifically (identified only by the fixed SNOMED 1515311000168102 'Sex assigned at birth' value on its extension:type sub-extension) from other uses of that same generic slot. Covers presence of both must-support sub-extensions (extension:value - biological sex, extensible-bound to the AU THS biological-sex-1 ValueSet; extension:type - fixed to the SNOMED code identifying this specific flavour) via a generic FHIRPath probe against a fetched Patient, exactly as the issue itself suggested was possible without any new engine capability. ProfileValidation runs validateProfileId against au-core-patient to confirm the whole resource - extension included, now correctly url'd to match the inherited slot - remains profile-conformant.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUCoreSexAssignedAtBirth</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-core-sexassignedab</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>sexassignedab-patient-fixture</code>: au-core-patient-sexassignedab (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${patientId}</code> = Patient.id of sexassignedab-patient-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Patient by id (${patientId})</span>
        <code class="testscript-technical">READ Patient/${patientId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ExtensionPresence</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Patient by id (${patientId})</span>
        <code class="testscript-technical">READ Patient/${patientId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/individual-recordedSexOrGender').exists()</span>
        <code class="testscript-technical">expression = Patient.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/individual-recordedSexOrGender').exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/individual-recordedSexOrGender').extension.where(url = 'value').value.exists()</span>
        <code class="testscript-technical">expression = Patient.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/individual-recordedSexOrGender').extension.where(url = 'value').value.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Patient.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/individual-recordedSexOrGender').extension.where(url = 'type').value.coding.code.where($this = '1515311000168102').exists()</span>
        <code class="testscript-technical">expression = Patient.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/individual-recordedSexOrGender').extension.where(url = 'type').value.coding.code.where($this = '1515311000168102').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Patient by id (${patientId})</span>
        <code class="testscript-technical">READ Patient/${patientId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/core/StructureDefinition/au-core-patient</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/core/StructureDefinition/au-core-patient</code>
      </li>
    </ol>
  </section>
</section>
