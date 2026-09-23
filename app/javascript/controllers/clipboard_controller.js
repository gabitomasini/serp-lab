import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "button", "label"]
  static values = {
    feedbackText: { type: String, default: "Copied!" },
    duration: { type: Number, default: 2000 }
  }

  copy(event) {
    if (event) event.preventDefault()

    let textToCopy = ""
    if (this.hasSourceTarget) {
      if (this.sourceTarget.value !== undefined && this.sourceTarget.value !== "") {
        textToCopy = this.sourceTarget.value
      } else {
        textToCopy = this.sourceTarget.textContent.trim()
      }
    }

    if (!textToCopy) return

    navigator.clipboard.writeText(textToCopy).then(() => {
      this.showFeedback()
    }).catch(err => {
      console.error("Failed to copy text: ", err)
    })
  }

  showFeedback() {
    const labelEl = this.hasLabelTarget ? this.labelTarget : this.buttonTarget
    const originalText = labelEl.textContent

    labelEl.textContent = this.feedbackTextValue
    if (this.hasButtonTarget) {
      this.buttonTarget.classList.add("bg-emerald-600/30", "text-emerald-300", "border-emerald-500/40")
    }

    setTimeout(() => {
      labelEl.textContent = originalText
      if (this.hasButtonTarget) {
        this.buttonTarget.classList.remove("bg-emerald-600/30", "text-emerald-300", "border-emerald-500/40")
      }
    }, this.durationValue)
  }
}
