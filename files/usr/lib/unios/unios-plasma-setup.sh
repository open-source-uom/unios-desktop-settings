#!/bin/bash
QDBUS_BIN=""
if command -v qdbus6 >/dev/null 2>&1; then
  QDBUS_BIN="qdbus6"
elif command -v qdbus >/dev/null 2>&1; then
  QDBUS_BIN="qdbus"
fi

if [ -n "$QDBUS_BIN" ]; then
  for _ in $(seq 1 30); do
    if "$QDBUS_BIN" org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "print(1)" >/dev/null 2>&1; then
      break
    fi
    sleep 0.5
  done

  "$QDBUS_BIN" org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript '
var des = desktops();
for (var i = 0; i < des.length; i++) {
    des[i].wallpaperPlugin = "org.kde.image";
    des[i].currentConfigGroup = ["Wallpaper", "org.kde.image", "General"];
    des[i].writeConfig("Image", "file:///usr/share/wallpapers/UniOS/contents/images/default.jpg");
}
var pans = panels();
for (var i = 0; i < pans.length; i++) {
    var applets = pans[i].widgets();
    for (var j = 0; j < applets.length; j++) {
        var a = applets[j];
        if (a.type === "org.kde.plasma.kickoff" || a.type === "org.kde.plasma.kicker") {
            a.currentConfigGroup = ["General"];
            a.writeConfig("icon", "/usr/share/pixmaps/unios.png");
            a.writeConfig("useCustomButtonImage", "true");
            a.writeConfig("customButtonImage", "/usr/share/pixmaps/unios.png");
        }
    }
}
' >/dev/null 2>&1
fi
