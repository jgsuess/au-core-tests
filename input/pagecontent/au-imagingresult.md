<section class="testscript">
  <header class="testscript-header">
    <h1>AU Imaging Result Observation — optionality discovery template</h1>
    <p class="testscript-description">Covers fhirfrog/au-core-compiler#23 (AUC-018): au-imagingresult (hl7.fhir.au.base, not a local au-core-* profile) has zero must-support elements of its own, and neither au-fhir-core-inferno (deliberately or not - couldn't confirm skip_generation for it specifically, see the issue's comment thread) nor fhir-frog test it today. Rather than a conventional must-support conformance gate (there's nothing profile-mandated to gate on), this is deliberately built as a discovery template: SHALL-level read/search-type interaction checks (the one real, resource-level requirement the CapabilityStatement does impose) run with warningOnly:false, while every element this profile merely *allows* (category:anatomicRegionOfInterest, extension:bodyStructure vs plain bodySite, value[x]/dataAbsentReason, component, hasMember) is probed with warningOnly:true against two fixtures - 'au-imagingresult-conformant' (a generous implementer) and 'au-imagingresult-minimal' (a bare-bones one). Building these two fixtures surfaced that 'zero must-support elements' does not mean unconstrained: au-imagingresult carries its own hard invariants not visible from the must-support list alone - inv-obs-0 (value, dataAbsentReason, or a child observation with either must be present - the minimal fixture needed a plain dataAbsentReason to satisfy this, it cannot be genuinely empty), inv-obs-1 (the bodyStructure Reference extension and the plain bodySite CodeableConcept are mutually exclusive, inherited from base Observation's own obs-7 rule about a component sharing its parent's code while both carry a value). Run against a real server, OptionalElementsProbeMinimal's warnings (not failures) are the point: they show which of the genuinely-optional elements that server does or doesn't populate. This only works because assert.warningOnly, though already required and set on every assertion since fhirfrog/fhir-frog's 'add required encodeRequestUrl/warningOnly fields' fix, was never actually read by PhaseExecutor - a failing warningOnly assertion still failed the whole test, identical to a hard one. Fixed alongside this TestScript (see fhirfrog/fhir-frog's PhaseExecutor commit): a failing warningOnly assertion now reports as TestReport's own WARNING result code instead of FAIL, and no longer fails the enclosing test/setup phase - proven by OptionalElementsProbeMinimal genuinely failing several of its own probe assertions against the minimal fixture while the TestScript as a whole still reports PASS.</p>
    <dl class="testscript-meta">
      <dt>Name</dt><dd>AUImagingResult</dd>
      <dt>URL</dt><dd>http://fhirfrog.org/fhir/au-core-tests/TestScript/au-imagingresult</dd>
      <dt>Status</dt><dd>active</dd>
    </dl>
  </header>
  <section class="testscript-fixtures">
    <h2>Fixtures</h2>
    <ul>
      <li><code>patient-fixture</code>: au-core-patient-conformant (created before, and removed after, the run)</li>
      <li><code>imagingresult-fixture</code>: au-imagingresult-conformant (created before, and removed after, the run)</li>
      <li><code>imagingresult-minimal-fixture</code>: au-imagingresult-minimal (created before, and removed after, the run)</li>
    </ul>
  </section>
  <section class="testscript-variables">
    <h2>Variables</h2>
    <ul>
      <li><code>${patientId}</code> = Patient.id of patient-fixture</li>
      <li><code>${imagingResultId}</code> = Observation.id of imagingresult-fixture</li>
      <li><code>${imagingResultMinimalId}</code> = Observation.id of imagingresult-minimal-fixture</li>
    </ul>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>Read</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Observation by id (${imagingResultId})</span>
        <code class="testscript-technical">READ Observation/${imagingResultId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByPatientCategory</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Observation where patient = Patient/${patientId} and category = http://terminology.hl7.org/CodeSystem/observation-category|imaging</span>
        <code class="testscript-technical">SEARCH Observation?patient=Patient/${patientId}&amp;category=http://terminology.hl7.org/CodeSystem/observation-category|imaging</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Observation).category.coding.code.where($this = 'imaging').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Observation).category.coding.code.where($this = 'imaging').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>SearchByPatientCode</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Search Observation where patient = Patient/${patientId} and code = http://snomed.info/sct|399208008</span>
        <code class="testscript-technical">SEARCH Observation?patient=Patient/${patientId}&amp;code=http://snomed.info/sct|399208008</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Response status is okay</span>
        <code class="testscript-technical">response = okay</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Bundle.entry.resource.ofType(Observation).code.coding.code.where($this = '399208008').exists()</span>
        <code class="testscript-technical">expression = Bundle.entry.resource.ofType(Observation).code.coding.code.where($this = '399208008').exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>OptionalElementsProbeGenerous</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Observation by id (${imagingResultId})</span>
        <code class="testscript-technical">READ Observation/${imagingResultId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.category.coding.code.where($this = 'imaging').exists() <span class="testscript-badge testscript-badge-warning">warning only</span></span>
        <code class="testscript-technical">expression = Observation.category.coding.code.where($this = 'imaging').exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.category.where(coding.system = 'http://snomed.info/sct').exists() <span class="testscript-badge testscript-badge-warning">warning only</span></span>
        <code class="testscript-technical">expression = Observation.category.where(coding.system = 'http://snomed.info/sct').exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/bodySite').exists() <span class="testscript-badge testscript-badge-warning">warning only</span></span>
        <code class="testscript-technical">expression = Observation.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/bodySite').exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.value.exists() <span class="testscript-badge testscript-badge-warning">warning only</span></span>
        <code class="testscript-technical">expression = Observation.value.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.dataAbsentReason.exists() <span class="testscript-badge testscript-badge-warning">warning only</span></span>
        <code class="testscript-technical">expression = Observation.dataAbsentReason.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.bodySite.exists() <span class="testscript-badge testscript-badge-warning">warning only</span></span>
        <code class="testscript-technical">expression = Observation.bodySite.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.component.exists() <span class="testscript-badge testscript-badge-warning">warning only</span></span>
        <code class="testscript-technical">expression = Observation.component.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.hasMember.exists() <span class="testscript-badge testscript-badge-warning">warning only</span></span>
        <code class="testscript-technical">expression = Observation.hasMember.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>OptionalElementsProbeMinimal</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Observation by id (${imagingResultMinimalId})</span>
        <code class="testscript-technical">READ Observation/${imagingResultMinimalId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.category.where(coding.system = 'http://snomed.info/sct').exists() <span class="testscript-badge testscript-badge-warning">warning only</span></span>
        <code class="testscript-technical">expression = Observation.category.where(coding.system = 'http://snomed.info/sct').exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/bodySite').exists() <span class="testscript-badge testscript-badge-warning">warning only</span></span>
        <code class="testscript-technical">expression = Observation.extension.where(url = 'http://hl7.org/fhir/StructureDefinition/bodySite').exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.value.exists() <span class="testscript-badge testscript-badge-warning">warning only</span></span>
        <code class="testscript-technical">expression = Observation.value.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.dataAbsentReason.exists() <span class="testscript-badge testscript-badge-warning">warning only</span></span>
        <code class="testscript-technical">expression = Observation.dataAbsentReason.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.bodySite.exists() <span class="testscript-badge testscript-badge-warning">warning only</span></span>
        <code class="testscript-technical">expression = Observation.bodySite.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.component.exists() <span class="testscript-badge testscript-badge-warning">warning only</span></span>
        <code class="testscript-technical">expression = Observation.component.exists()</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Check: Observation.hasMember.exists() <span class="testscript-badge testscript-badge-warning">warning only</span></span>
        <code class="testscript-technical">expression = Observation.hasMember.exists()</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidation</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Observation by id (${imagingResultId})</span>
        <code class="testscript-technical">READ Observation/${imagingResultId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/StructureDefinition/au-imagingresult</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/StructureDefinition/au-imagingresult</code>
      </li>
    </ol>
  </section>
  <section class="testscript-phase testscript-phase-test">
    <h2>ProfileValidationMinimal</h2>
    <ol class="testscript-steps">
      <li class="testscript-step testscript-step-operation">
        <span class="testscript-narrative">Read Observation by id (${imagingResultMinimalId})</span>
        <code class="testscript-technical">READ Observation/${imagingResultMinimalId}</code>
      </li>
      <li class="testscript-step testscript-step-assert">
        <span class="testscript-narrative">Validate the response against profile http://hl7.org.au/fhir/StructureDefinition/au-imagingresult</span>
        <code class="testscript-technical">validateProfileId = http://hl7.org.au/fhir/StructureDefinition/au-imagingresult</code>
      </li>
    </ol>
  </section>
</section>
