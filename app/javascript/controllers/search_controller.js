import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "input", "results"]

  connect() {
    this.debounceTimer = null
  }

  perform() {
    clearTimeout(this.debounceTimer)
    
    this.debounceTimer = setTimeout(() => {
      const query = this.inputTarget.value
      if (query.length >= 2) {
        fetch(`${this.formTarget.action}?query=${encodeURIComponent(query)}`, {
          headers: {
            Accept: "text/html"
          }
        })
        .then(response => response.text())
        .then(html => {
          this.resultsTarget.innerHTML = html
        })
      } else {
        this.resultsTarget.innerHTML = ""
      }
    }, 300)
  }
} 