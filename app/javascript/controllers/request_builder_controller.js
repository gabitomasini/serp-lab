import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["engineRadio", "queryInput", "countrySelect", "curlCode", "nodeCode", "pythonCode"]

  connect() {
    this.updateSnippets()
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
