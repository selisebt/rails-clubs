import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["userManagement", "userManagementIcon"]

  connect() {
    // Add styles when controller connects
    const style = document.createElement('style')
    style.textContent = `
      .nav-item, .nav-sub-item {
        transition: all 300ms ease-in-out;
      }
      .nav-item:hover, .nav-sub-item:hover, .nav-item.active, .nav-sub-item.active {
        background-color: rgb(243 244 246);
      }
      .nav-item:hover div, .nav-item.active div,
      .nav-sub-item:hover div, .nav-sub-item.active div {
        background: linear-gradient(to right, rgb(96 165 250), rgb(59 130 246));
      }
      .nav-item:hover i, .nav-item.active i,
      .nav-sub-item:hover i, .nav-sub-item.active i {
        color: white;
      }
      .nav-item:hover span, .nav-item.active span,
      .nav-sub-item:hover span, .nav-sub-item.active span {
        background: linear-gradient(to right, rgb(96 165 250), rgb(59 130 246));
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
      }
    `
    document.head.appendChild(style)
  }

  toggleAccordion(event) {
    const button = event.currentTarget
    this.userManagementTarget.classList.toggle('hidden')
    this.userManagementIconTarget.classList.toggle('rotate-180')
    this.setActiveNav(button)
  }

  setActiveNav(event) {
    const element = event.currentTarget
    // Remove active class from all items
    document.querySelectorAll('.nav-item, .nav-sub-item').forEach(item => {
      item.classList.remove('active')
    })

    // Add active class to clicked item
    element.classList.add('active')
  }

  setActiveSubNav(event) {
    event.preventDefault()
    const element = event.currentTarget
    // Remove active class from all items
    document.querySelectorAll('.nav-item, .nav-sub-item').forEach(item => {
      item.classList.remove('active')
    })

    // Add active class to clicked sub item
    element.classList.add('active')
    
    // Keep parent active
    const parentButton = element.closest('.relative').querySelector('button')
    parentButton.classList.add('active')
  }
} 