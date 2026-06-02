import { Controller } from "@hotwired/stimulus"
import * as bootstrap from "bootstrap"

// Turbo Drive 遷移時にモーダルの残骸（backdrop / body の modal-open）を掃除する
export default class extends Controller {
  connect() {
    this.cleanup = this.cleanup.bind(this)
    document.addEventListener("turbo:before-cache", this.cleanup)
  }

  disconnect() {
    document.removeEventListener("turbo:before-cache", this.cleanup)
  }

  cleanup() {
    const instance = bootstrap.Modal.getInstance(this.element)
    if (instance) {
      instance.hide()
    }

    document.querySelectorAll(".modal-backdrop").forEach((el) => el.remove())

    document.body.classList.remove("modal-open")
    document.body.style.removeProperty("overflow")
    document.body.style.removeProperty("padding-right")
  }
}
