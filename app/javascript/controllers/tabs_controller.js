import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]
  static values = {
    defaultTab: { type: String, default: "parsed" },
    activeClasses: { type: Array, default: ["text-[#f1f5f9]", "border-[#10b981]", "font-medium"] },
    inactiveClasses: { type: Array, default: ["text-[#71717a]", "border-transparent"] }
  }

  connect() {
    this.selectTab(this.defaultTabValue)
  }

  change(event) {
    event.preventDefault()
    const selectedTab = event.currentTarget.dataset.tabTargetName || event.currentTarget.dataset.tab
    if (selectedTab) {
      this.selectTab(selectedTab)
    }
  }

  selectTab(tabName) {
    // Update panels visibility
    this.panelTargets.forEach(panel => {
      const isTarget = panel.dataset.tabPanelName === tabName
      if (isTarget) {
        panel.classList.remove("hidden")
      } else {
        panel.classList.add("hidden")
      }
    })

    // Update tab button styles
    this.tabTargets.forEach(tab => {
      const isTarget = (tab.dataset.tabTargetName || tab.dataset.tab) === tabName
      if (isTarget) {
        if (this.inactiveClassesValue.length) tab.classList.remove(...this.inactiveClassesValue)
        if (this.activeClassesValue.length) tab.classList.add(...this.activeClassesValue)
        tab.setAttribute("aria-selected", "true")
      } else {
        if (this.activeClassesValue.length) tab.classList.remove(...this.activeClassesValue)
        if (this.inactiveClassesValue.length) tab.classList.add(...this.inactiveClassesValue)
        tab.setAttribute("aria-selected", "false")
      }
    })
  }
}
