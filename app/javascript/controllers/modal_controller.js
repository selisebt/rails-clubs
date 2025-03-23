import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "overlay"]

  connect() {
    this.clubForm = document.getElementById("delete-club-form")
    this.announcementForm = document.getElementById("delete-announcement-form")
    this.eventForm = document.getElementById("delete-event-form")
    this.closeOnEscape = this.closeOnEscape.bind(this)
    document.addEventListener("keydown", this.closeOnEscape)
  }

  disconnect() {
    document.removeEventListener("keydown", this.closeOnEscape)
  }

  open(event) {
    const clubId = event.currentTarget.dataset.clubId
    const announcementId = event.currentTarget.dataset.announcementId
    const eventId = event.currentTarget.dataset.eventId

    if (clubId && this.clubForm) {
      this.clubForm.action = `/clubs/${clubId}`
    } else if (announcementId && this.announcementForm) {
      this.announcementForm.action = `/announcements/${announcementId}`
    } else if (eventId && this.eventForm) {
      const clubId = window.location.pathname.split('/')[2] // Get club_id from URL
      this.eventForm.action = `/clubs/${clubId}/events/${eventId}`
    }

    this.modalTarget.classList.remove("hidden")
    this.overlayTarget.classList.remove("hidden")
    document.body.style.overflow = "hidden"
  }

  close() {
    this.modalTarget.classList.add("hidden")
    this.overlayTarget.classList.add("hidden")
    document.body.style.overflow = ""
  }

  closeOnEscape(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  // Close modal when clicking outside
  closeBackground(event) {
    if (event.target === this.overlayTarget) {
      this.close()
    }
  }
} 