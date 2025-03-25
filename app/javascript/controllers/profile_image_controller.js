import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "preview", "iconContainer"];

  connect() {
    // Optional: You can add initialization logic here if needed
  }

  triggerFileInput() {
    this.inputTarget.click();
  }

  preview() {
    const file = this.inputTarget.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (e) => {
      const previewTarget = this.hasPreviewTarget ? this.previewTarget : null;
      const iconContainer = this.hasIconContainerTarget
        ? this.iconContainerTarget
        : null;

      if (previewTarget) {
        previewTarget.src = e.target.result;
      } else if (iconContainer) {
        const newImage = document.createElement("img");
        newImage.src = e.target.result;
        newImage.setAttribute("data-profile-image-target", "preview");
        newImage.className = "w-32 h-32 rounded-full object-cover";
        iconContainer.parentNode.replaceChild(newImage, iconContainer);
      }
    };

    reader.readAsDataURL(file);
  }
}
