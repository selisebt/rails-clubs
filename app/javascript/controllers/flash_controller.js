import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect(){
    setTimeout(() => {
      this.remove();
    }, 1500);
  }

  remove() {
    this.element.remove();
  }
}