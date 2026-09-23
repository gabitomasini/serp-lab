import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  get modal() {
    return this.hasDialogTarget ? this.dialogTarget : this.element
  }

  open(event) {
    if (event) event.preventDefault()
    if (typeof this.modal.showModal === "function") {
      this.modal.showModal()
    } else {
      this.modal.setAttribute("open", "")
    }
  }

  close(event) {
    if (event) event.preventDefault()
    if (typeof this.modal.close === "function") {
      this.modal.close()
    } else {
      this.modal.removeAttribute("open")
    }
  }

  clickOutside(event) {
    // If the click happened on the backdrop (which is the dialog element itself in native HTML5)
    if (event.target === this.modal) {
      this.close()
    }
  }
}
