import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["priorityDropdown", "selectedPriority", "priorityInput"]

  connect() {
    debugger
    // Close dropdowns when clicking outside
    document.addEventListener('click', this.closeDropdowns.bind(this))
  }

  disconnect() {
    document.removeEventListener('click', this.closeDropdowns.bind(this))
  }

  togglePriorityDropdown() {
    this.priorityDropdownTarget.classList.toggle("show")
  }

  selectPriority(event) {
    debugger
    const priority = event.currentTarget.dataset.priority
    this.selectedPriorityTarget.textContent = priority.charAt(0).toUpperCase() + priority.slice(1)
    this.priorityInputTarget.value = priority
    this.priorityDropdownTarget.classList.remove("show")
  }

  closeDropdowns(event) {
    if (!event.target.closest('.dropdown')) {
      const dropdowns = document.getElementsByClassName("dropdown-content")
      Array.from(dropdowns).forEach(dropdown => {
        if (dropdown.classList.contains('show')) {
          dropdown.classList.remove('show')
        }
      })
    }
  }
} 