import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "overlay", "title", "message"]

  connect() {
    this.currentAction = null
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
    const button = event.currentTarget
    const clubId = button.dataset.clubId
    const userId = button.dataset.userId
    const announcementId = button.dataset.announcementId
    const userName = button.dataset.userName
    const eventId = button.dataset.eventId

    if (clubId) {
      // Club deletion
      this.currentAction = 'club'
      this.titleTarget.textContent = 'Delete Club'
      this.messageTarget.textContent = 'Are you sure you want to delete this club? This action cannot be undone.'
      document.getElementById('delete-club-form').action = `/clubs/${clubId}`
      // document.getElementById('delete-club-form').classList.remove('hidden')
      // document.getElementById('delete-member-form').classList.add('hidden')
    } else if (userId) {
      // Member deletion
      this.currentAction = 'member'
      this.titleTarget.textContent = 'Remove Member'
      this.messageTarget.textContent = `Are you sure you want to remove ${userName} from this club?`
      document.getElementById('delete-member-form').action = `/clubs/${this.element.dataset.clubId}/delete_member?user_id=${userId}`
      document.getElementById('delete-member-form').classList.remove('hidden')
      document.getElementById('delete-club-form').classList.add('hidden')
    } else if (announcementId) {
      // Announcement deletion
      this.currentAction = 'announcement'
      document.getElementById('delete-announcement-form').action = `/announcements/${announcementId}`
      document.getElementById('delete-announcement-form').classList.remove('hidden')
    }
    else if (eventId) {
      this.currentAction = 'event'
      this.titleTarget.textContent = 'Remove an Event'
      this.messageTarget.textContent = 'Are you sure you want to delete this event? This action cannot be undone.'
      document.getElementById('delete-event-form').action = `/clubs/${event.currentTarget.dataset.eventClubId}/events/${eventId}`
    }

    this.modalTarget.classList.remove('hidden')
    this.overlayTarget.classList.remove('hidden')
    document.body.style.overflow = "hidden"
  }

  close() {
    this.modalTarget.classList.add('hidden')
    this.overlayTarget.classList.add('hidden')
    this.currentAction = null
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