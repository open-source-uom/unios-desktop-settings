# Maintainer: Apostolos Chalis <achalis@csd.auth.gr>
pkgname=unios-desktop-settings
pkgver=1.0.0
pkgrel=8
pkgdesc="UniOS desktop configuration, artwork, branding and welcome autostart for KDE Plasma"
arch=('any')
url="https://github.com/open-source-uom/unios-desktop-settings"
license=('GPL-3.0-or-later')
depends=('breeze' 'breeze-gtk' 'plasma-workspace' 'kde-cli-tools')

package() {
  install -d "$pkgdir/usr/share/wallpapers/UniOS/contents/images"
  install -d "$pkgdir/usr/share/wallpapers/UniOS"
  install -d "$pkgdir/usr/share/pixmaps"
  install -d "$pkgdir/usr/share/icons/hicolor/256x256/apps"
  install -d "$pkgdir/usr/share/icons/hicolor/scalable/apps"
  install -d "$pkgdir/etc/xdg/autostart"
  install -d "$pkgdir/etc/skel/.config"
  install -d "$pkgdir/usr/lib/unios"

  RES_DIR=""
  if [ -d "$startdir/resources" ]; then
    RES_DIR="$startdir/resources"
  elif [ -d "$srcdir/unios-desktop-settings/resources" ]; then
    RES_DIR="$srcdir/unios-desktop-settings/resources"
  elif [ -d "$srcdir/resources" ]; then
    RES_DIR="$srcdir/resources"
  fi

  if [ -n "$RES_DIR" ]; then
    find "$RES_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) ! -iname "*logo*" -exec cp {} "$pkgdir/usr/share/wallpapers/UniOS/contents/images/" \;
    
    LOGO_FILE=$(find "$RES_DIR" -type f \( -iname "unios.png" -o -iname "*logo*.png" \) | head -n 1)
    if [ -n "$LOGO_FILE" ]; then
      install -Dm644 "$LOGO_FILE" "$pkgdir/usr/share/pixmaps/unios.png"
      install -Dm644 "$LOGO_FILE" "$pkgdir/usr/share/icons/hicolor/256x256/apps/unios.png"
      install -Dm644 "$LOGO_FILE" "$pkgdir/usr/share/icons/hicolor/256x256/apps/start-here-kde.png"
      install -Dm644 "$LOGO_FILE" "$pkgdir/usr/share/icons/hicolor/256x256/apps/distributor-logo.png"
      install -Dm644 "$LOGO_FILE" "$pkgdir/usr/share/icons/hicolor/scalable/apps/start-here-kde.png"
    fi
  fi

  FIRST_WP=$(find "$pkgdir/usr/share/wallpapers/UniOS/contents/images" -type f | head -n 1)
  if [ -n "$FIRST_WP" ] && [ ! -f "$pkgdir/usr/share/wallpapers/UniOS/contents/images/unios.jpg" ]; then
    cp "$FIRST_WP" "$pkgdir/usr/share/wallpapers/UniOS/contents/images/unios.jpg"
  fi

  cat << 'EOF' > "$pkgdir/usr/share/wallpapers/UniOS/metadata.json"
{
    "KPlugin": {
        "Id": "UniOS",
        "Name": "UniOS Wallpapers"
    }
}
EOF

  cat << 'EOF' > "$pkgdir/etc/xdg/kdeglobals"
[KDE]
LookAndFeelPackage=org.kde.breezedark.desktop

[General]
ColorScheme=BreezeDark

[Icons]
Theme=breeze-dark
EOF

  cat << 'EOF' > "$pkgdir/etc/xdg/plasmarc"
[Theme]
name=breeze-dark
EOF

  cat << 'EOF' > "$pkgdir/etc/skel/.config/plasma-welcome-appletsrc"
[General]
ShouldShow=false
EOF

  cat << 'EOF' > "$pkgdir/etc/skel/.config/kded_plasma_welcomerc"
[Module]
autoload=false
EOF

  cat << 'EOF' > "$pkgdir/usr/lib/unios/unios-plasma-setup.sh"
#!/bin/bash
WP="/usr/share/wallpapers/UniOS/contents/images/default.jpg"

QDBUS_BIN=""
if command -v qdbus6 >/dev/null 2>&1; then
  QDBUS_BIN="qdbus6"
elif command -v qdbus >/dev/null 2>&1; then
  QDBUS_BIN="qdbus"
fi

if [ -n "$QDBUS_BIN" ]; then
  for i in $(seq 1 30); do
    if $QDBUS_BIN org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "print(1)" >/dev/null 2>&1; then
      break
    fi
    sleep 0.5
  done

  $QDBUS_BIN org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript '
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
        if (a.type === "org.kde.plasma.kickoff" || a.type === "org.kde.plasma.kicker" || a.type === "org.kde.plasma.appmenu") {
            a.currentConfigGroup = ["General"];
            a.writeConfig("icon", "/usr/share/pixmaps/unios.png");
            a.writeConfig("useCustomButtonImage", "true");
            a.writeConfig("customButtonImage", "/usr/share/pixmaps/unios.png");
        }
    }
}
' >/dev/null 2>&1
fi

if [ -f "$WP" ] && command -v plasma-apply-wallpaperimage >/dev/null 2>&1; then
  plasma-apply-wallpaperimage "$WP" >/dev/null 2>&1
fi
EOF
  chmod 755 "$pkgdir/usr/lib/unios/unios-plasma-setup.sh"

  mkdir -p "$pkgdir/etc/xdg/autostart"

  cat << 'EOF' > "$pkgdir/etc/xdg/autostart/unios-plasma-setup.desktop"
[Desktop Entry]
Type=Application
Name=UniOS Plasma Setup
Exec=/usr/lib/unios/unios-plasma-setup.sh
Terminal=false
NoDisplay=true
X-KDE-autostart-phase=2
EOF

  cat << 'EOF' > "$pkgdir/etc/xdg/autostart/org.kde.plasma-welcome.desktop"
[Desktop Entry]
Type=Application
Name=Welcome Center
Exec=plasma-welcome
Hidden=true
X-KDE-autostart-condition=plasmawelcomerc:General:ShowOnStartup:false
EOF 
}
