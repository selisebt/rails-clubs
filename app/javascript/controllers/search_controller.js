import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String
  }

  perform(event) {
    const query = event.target.value
    if (query.length < 2) return

    fetch(`${this.urlValue}?query=${encodeURIComponent(query)}`, {
      headers: {
        Accept: "text/html"
      }
    })
    .then(response => response.text())
    .then(html => {
      document.getElementById("search-results").innerHTML = html
    })
  }
} 