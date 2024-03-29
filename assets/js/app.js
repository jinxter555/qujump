// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
import "bootstrap"

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "./vendor/some-package.js"
//
// Alternatively, you can `npm install some-package` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

import {Modal} from "bootstrap"


let Hooks = {}
Hooks.BsModal = {
  mounted() {
    const modal = new Modal(this.el)
    modal.show()

    this.el.addEventListener('hidden.bs.modal', event => {
      this.pushEventTo(`#${this.el.getAttribute('id')}`,'close', {})
      modal.dispose()
      this.unlockScroll() // added scroll unlock jing
    })

    this.el.querySelector('form').addEventListener('submit', event => {
      const backdrop = document.querySelector('.modal-backdrop')
      if (backdrop) backdrop.parentElement.removeChild(backdrop)
      this.unlockScroll() // added scroll unlock jing
    })
  },
  unlockScroll() {
    // From https://github.com/excid3/tailwindcss-stimulus-components/blob/master/src/modal.js
    // Remove tweaks for scrollbar
    document.body.style.paddingRight = null
    // Remove classes from body to unfix position
    document.body.classList.remove('fix-position')
    // Restore the scroll position of the body before it got locked
    document.documentElement.scrollTop = this.scrollPosition
    // Remove the negative top inline style from body
    document.body.style.position = '';
    document.body.style.overflow =''
    document.body.style.top = null
  }

}

Hooks.BsFieldValidation = {
  mounted() {
    const message = this.el
    if (message.classList.contains('phx-no-feedback')) return // Not the field in focus

    const field = document.getElementById(message.getAttribute('phx-feedback-for'))
    field.classList.add('is-invalid')
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

