import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "inviteDropdown",
    "inviteModal",
    "csvModal",
    "fileInput",
    "dropContent",
    "fileInfo",
    "fileName",
    "dropZone",
    "editModal",
    "deleteModal",
    "profilePreview",
    "uploadPlaceholder",
    "removePhotoBtn",
    "profilePicture",
    "editName",
    "editEmail",
    "editRole",
    "editUserId",
    "deleteUserName",
    "addUserModal",
    "addUserEmail",
    "addUserName",
    "addUserRole",
    "inviteEmail"
  ]

  connect() {
    // Initialize event listeners
    this.setupEventListeners()
  }

  setupEventListeners() {
    // Close modals when clicking outside
    document.addEventListener('click', (event) => {
      if (event.target.classList.contains('fixed')) {
        if (event.target.id === 'inviteModal') this.closeModal()
        if (event.target.id === 'csvModal') this.closeCsvModal()
        if (event.target.id === 'editModal') this.closeEditModal()
        if (event.target.id === 'deleteModal') this.closeDeleteModal()
        if (event.target.id === 'addUserModal') this.closeAddUserModal()
      }
    })

    // Close dropdown when clicking outside
    document.addEventListener('click', (event) => {
      if (!event.target.closest('.dropdown')) {
        const dropdowns = document.getElementsByClassName("dropdown-content")
        Array.from(dropdowns).forEach(dropdown => {
          if (dropdown.classList.contains('show')) {
            dropdown.classList.remove('show')
          }
        })
      }
    })

    // CSV drag and drop functionality
    if (this.hasDropZoneTarget) {
      this.dropZoneTarget.addEventListener('dragover', (e) => {
        e.preventDefault()
        this.dropZoneTarget.classList.add('border-blue-500')
      })

      this.dropZoneTarget.addEventListener('dragleave', (e) => {
        e.preventDefault()
        this.dropZoneTarget.classList.remove('border-blue-500')
      })

      this.dropZoneTarget.addEventListener('drop', (e) => {
        e.preventDefault()
        this.dropZoneTarget.classList.remove('border-blue-500')
        const file = e.dataTransfer.files[0]
        if (file && file.name.endsWith('.csv')) {
          this.fileInputTarget.files = e.dataTransfer.files
          this.showFileInfo(file)
        } else {
          alert('Please upload a CSV file')
        }
      })
    }

    if (this.hasFileInputTarget) {
      this.fileInputTarget.addEventListener('change', (e) => {
        const file = e.target.files[0]
        if (file) {
          this.showFileInfo(file)
        }
      })
    }
  }

  // Modal functions
  openModal() {
    this.inviteModalTarget.classList.remove('hidden')
    this.inviteDropdownTarget.classList.remove('show')
  }

  closeModal() {
    this.inviteModalTarget.classList.add('hidden')
    if (this.hasInviteEmailTarget) {
      this.inviteEmailTarget.value = ''
    }
  }

  openCsvModal() {
    this.csvModalTarget.classList.remove('hidden')
    this.inviteDropdownTarget.classList.remove('show')
  }

  closeCsvModal() {
    this.csvModalTarget.classList.add('hidden')
    this.removeFile()
  }

  removeFile() {
    if (this.hasFileInputTarget) this.fileInputTarget.value = ''
    if (this.hasDropContentTarget) this.dropContentTarget.classList.remove('hidden')
    if (this.hasFileInfoTarget) this.fileInfoTarget.classList.add('hidden')
  }

  submitCsvUpload() {
    if (!this.fileInputTarget.files[0]) {
      alert('Please select a CSV file first')
      return
    }
    // Add your CSV upload logic here
    alert('CSV uploaded successfully!')
    this.closeCsvModal()
  }

  showFileInfo(file) {
    if (this.hasDropContentTarget) this.dropContentTarget.classList.add('hidden')
    if (this.hasFileInfoTarget) this.fileInfoTarget.classList.remove('hidden')
    if (this.hasFileNameTarget) this.fileNameTarget.textContent = file.name
  }

  // Dropdown toggle
  toggleDropdown() {
    this.inviteDropdownTarget.classList.toggle("show")
  }

  // Edit modal functions
  // openEditModal(event) {
  //   this.editModalTarget.classList.remove('hidden')
  // }

  closeEditModal() {
    this.editModalTarget.classList.add('hidden')
    if (this.hasEditNameTarget) this.editNameTarget.value = ''
    if (this.hasEditEmailTarget) this.editEmailTarget.value = ''
    if (this.hasEditRoleTarget) this.editRoleTarget.value = ''
    if (this.hasEditUserIdTarget) this.editUserIdTarget.value = ''
    this.removeProfilePicture()
  }

  submitEdit(event) {
    event.preventDefault()
    
    const form = this.element.querySelector('#editUserForm')
    const formData = new FormData(form)
    
    fetch(`/users/${formData.get('user[id]')}`, {
      method: 'PATCH',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Accept': 'application/json'
      },
      body: formData
    })
    .then(response => response.json())
    .then(data => {
      if (data.done) {
        // Refresh the page to show updated data
        window.location.reload()
      }
    })
    .catch(error => {
      console.error('Error:', error)
      alert('An error occurred while updating the user.')
    })
  }

  // Delete modal functions
  openDeleteModal(event) {
    const button = event.currentTarget
    const name = button.dataset.name
    this.deleteUserNameTarget.textContent = name
    this.deleteModalTarget.classList.remove('hidden')
  }

  closeDeleteModal() {
    this.deleteModalTarget.classList.add('hidden')
    if (this.hasDeleteUserNameTarget) this.deleteUserNameTarget.textContent = ''
  }

  // Profile picture functions
  handleProfilePicture(event) {
    const file = event.target.files[0]
    if (file) {
      const reader = new FileReader()
      reader.onload = (e) => {
        this.handleProfilePicturePreview(e.target.result)
      }
      reader.readAsDataURL(file)
    }
  }

  handleProfilePicturePreview(imageUrl) {
    if (imageUrl) {
      this.profilePreviewTarget.style.backgroundImage = `url(${imageUrl})`
      this.profilePreviewTarget.classList.remove('hidden')
      this.uploadPlaceholderTarget.classList.add('hidden')
      this.removePhotoBtnTarget.classList.remove('hidden')
    } else {
      this.removeProfilePicture()
    }
  }

  removeProfilePicture() {
    this.profilePictureTarget.value = ''
    this.profilePreviewTarget.style.backgroundImage = ''
    this.profilePreviewTarget.classList.add('hidden')
    this.uploadPlaceholderTarget.classList.remove('hidden')
    this.removePhotoBtnTarget.classList.add('hidden')
  }

  // Add user modal functions
  openAddUserModal() {
    this.addUserModalTarget.classList.remove('hidden')
    this.inviteDropdownTarget.classList.remove('show')
  }

  closeAddUserModal() {
    this.addUserModalTarget.classList.add('hidden')
    if (this.hasAddUserEmailTarget) this.addUserEmailTarget.value = ''
    if (this.hasAddUserNameTarget) this.addUserNameTarget.value = ''
    if (this.hasAddUserRoleTarget) this.addUserRoleTarget.value = ''
  }

  submitAddUser() {
    // Add your add user logic here
    alert('User added successfully!')
    this.closeAddUserModal()
  }

  // Invite user functions
  submitInvite() {
    // Add your invite user logic here
    alert('Invitation sent successfully!')
    this.closeModal()
  }

  // Utility functions
  stopPropagation(event) {
    event.stopPropagation()
  }

  triggerFileInput() {
    this.fileInputTarget.click()
  }
} 