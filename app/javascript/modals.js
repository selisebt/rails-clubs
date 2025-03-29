// Modal functions
const modalFunctions = {
  // Invite Modal
  openModal: () => {
    document.getElementById("inviteModal").classList.remove("hidden");
    document.getElementById("inviteDropdown").classList.remove("show");
  },

  closeModal: () => {
    document.getElementById("inviteModal").classList.add("hidden");
  },

  // CSV Modal
  openCsvModal: () => {
    document.getElementById("csvModal").classList.remove("hidden");
    document.getElementById("inviteDropdown").classList.remove("show");
  },

  closeCsvModal: () => {
    document.getElementById("csvModal").classList.add("hidden");
    removeFile();
  },

  // Edit Modal
  openEditModal: (button) => {
    const name = button.dataset.name;
    const email = button.dataset.email;
    const role = button.dataset.role;
    const avatarUrl = button.dataset.avatar;

    document.getElementById("editName").value = name;
    document.getElementById("editEmail").value = email;
    document.getElementById("editRole").value = role;

    handleProfilePicturePreview(avatarUrl);
    document.getElementById("editModal").classList.remove("hidden");
  },

  closeEditModal: () => {
    document.getElementById("editModal").classList.add("hidden");
  },

  // Delete Modal
  openDeleteModal: (button) => {
    const name = button.dataset.name;
    document.getElementById("deleteUserName").textContent = name;
    document.getElementById("deleteModal").classList.remove("hidden");
  },

  closeDeleteModal: () => {
    document.getElementById("deleteModal").classList.add("hidden");
  },

  // Helper functions
  handleProfilePicture: (event) => {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = function (e) {
        handleProfilePicturePreview(e.target.result);
      };
      reader.readAsDataURL(file);
    }
  },

  handleProfilePicturePreview: (imageUrl) => {
    const preview = document.getElementById("profilePreview");
    const placeholder = document.getElementById("uploadPlaceholder");
    const removeBtn = document.getElementById("removePhotoBtn");

    if (imageUrl) {
      preview.style.backgroundImage = `url(${imageUrl})`;
      preview.classList.remove("hidden");
      placeholder.classList.add("hidden");
      removeBtn.classList.remove("hidden");
    } else {
      removeProfilePicture();
    }
  },

  removeProfilePicture: () => {
    const input = document.getElementById("profilePicture");
    const preview = document.getElementById("profilePreview");
    const placeholder = document.getElementById("uploadPlaceholder");
    const removeBtn = document.getElementById("removePhotoBtn");

    input.value = "";
    preview.style.backgroundImage = "";
    preview.classList.add("hidden");
    placeholder.classList.remove("hidden");
    removeBtn.classList.add("hidden");
  },
};

export default modalFunctions;
