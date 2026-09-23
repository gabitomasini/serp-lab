import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "engineRadio",
    "queryInput",
    "countrySelect",
    "curlCode",
    "nodeCode",
    "pythonCode",
    "submitButton",
    "spinner",
    "buttonText",
    "loadingBar"
  ]

  connect() {
    this.updateSnippets()
  }

  submitStart() {
    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = true
      this.submitButtonTarget.classList.add("bg-[#064e3b]", "cursor-not-allowed", "opacity-80")
      this.submitButtonTarget.classList.remove("bg-[#10b981]", "hover:bg-[#059669]", "cursor-pointer")
    }
    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.remove("hidden")
    }
    if (this.hasButtonTextTarget) {
      this.buttonTextTarget.textContent = "Sending…"
    }
    if (this.hasLoadingBarTarget) {
      this.loadingBarTarget.classList.remove("hidden")
    }
    const frame = document.getElementById("playground_results")
    if (frame) {
      frame.classList.add("opacity-50", "pointer-events-none", "transition-opacity", "duration-200")
    }
  }

  submitEnd() {
    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = false
      this.submitButtonTarget.classList.remove("bg-[#064e3b]", "cursor-not-allowed", "opacity-80")
      this.submitButtonTarget.classList.add("bg-[#10b981]", "hover:bg-[#059669]", "cursor-pointer")
    }
    if (this.hasSpinnerTarget) {
      this.spinnerTarget.classList.add("hidden")
    }
    if (this.hasButtonTextTarget) {
      this.buttonTextTarget.textContent = "Send Request"
    }
    if (this.hasLoadingBarTarget) {
      this.loadingBarTarget.classList.add("hidden")
    }
    const frame = document.getElementById("playground_results")
    if (frame) {
      frame.classList.remove("opacity-50", "pointer-events-none")
    }
  }

  engineChanged() {
    this.updateSnippets()
  }

  inputChanged() {
    this.updateSnippets()
  }

  normalizedEngine() {
    const selectedRadio = this.engineRadioTargets.find(r => r.checked)
    const val = selectedRadio ? selectedRadio.value : "google"
    if (val === "shopping" || val === "google_shopping") {
      return "google_shopping"
    } else if (val === "youtube") {
      return "youtube"
    }
    return "google"
  }

  currentQuery() {
    return (this.hasQueryInputTarget && this.queryInputTarget.value.trim()) || "site:github.com/trending"
  }

  currentCountry() {
    return (this.hasCountrySelectTarget && this.countrySelectTarget.value) || "us"
  }

  updateSnippets() {
    const engine = this.normalizedEngine()
    const query = this.currentQuery()
    const gl = this.currentCountry()

    // 1. Update cURL snippet
    if (this.hasCurlCodeTarget) {
      this.curlCodeTarget.textContent = `curl -G "https://api.serplab.io/api/v1/search" \\
  -d "engine=${engine}" \\
  -d "q=${query}" \\
  -d "gl=${gl}" \\
  -H "Authorization: Bearer $SERPLAB_KEY"`
    }

    // 2. Update Node.js snippet
    if (this.hasNodeCodeTarget) {
      this.nodeCodeTarget.textContent = `import SerpLab from 'serplab-js';

const client = new SerpLab(process.env.SERPLAB_KEY);

const results = await client.search({
  engine: '${engine}',
  q: '${query}',
  gl: '${gl}',
});

console.log(results);`
    }

    // 3. Update Python snippet
    if (this.hasPythonCodeTarget) {
      this.pythonCodeTarget.textContent = `import serplab

client = serplab.Client(api_key=os.environ['SERPLAB_KEY'])

results = client.search(
    engine='${engine}',
    q='${query}',
    gl='${gl}',
)

print(results)`
    }
  }
}
