// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"
import '@fortawesome/fontawesome-free/js/fontawesome';
import '@fortawesome/fontawesome-free/js/solid';
import '@fortawesome/fontawesome-free/js/regular';
import '@fortawesome/fontawesome-free/js/brands';
// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
// assets/js/app.js
import { Socket } from "phoenix"
import LiveSocket from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
// Import LiveView Hooks
import Hooks from './liveview/hooks';

let liveSocket = new LiveSocket("/live", Socket, { hooks: Hooks, params: { _csrf_token: csrfToken } });

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket