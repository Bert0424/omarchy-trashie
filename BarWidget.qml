import QtQuick
import Quickshell
import qs.Commons
import qs.Ui

// Trashie is a self-contained HTML5 game. The bar widget is just a launcher:
// clicking the trash can runs scripts/launch.sh, which opens game/index.html
// as a chromeless web-app window (via Omarchy's own omarchy-launch-webapp).
// Clicking again focuses that window instead of opening a second one.
BarWidget {
  id: root
  moduleName: "bert.trashie"

  // scripts/launch.sh wants a filesystem path, not a file:// URL.
  function localPath(rel) {
    var url = Qt.resolvedUrl(rel).toString()
    if (url.indexOf("file://") === 0) url = url.substring(7)
    return decodeURIComponent(url)
  }

  function launch() {
    Quickshell.execDetached(["bash", localPath("scripts/launch.sh")])
  }

  // The host may call these on a bound hotkey / IPC summon — all just play.
  function open() { launch() }
  function togglePanel() { launch() }
  function close() {}

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "🗑️"
    horizontalMargin: 8.5
    tooltipText: "Trashie — click to play"

    onPressed: function(b) {
      if (!root.bar) return
      root.launch()
    }
  }
}
