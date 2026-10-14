# Maintainer: Apostolos Chalis <achalis@csd.auth.gr>
pkgname=unios-desktop-settings
pkgver=1.0.0
pkgrel=10
pkgdesc="UniOS desktop configuration, artwork, branding and welcome autostart for KDE Plasma"
arch=('any')
url="https://github.com/open-source-uom/unios-desktop-settings"
license=('GPL-3.0-or-later')
depends=('breeze' 'breeze-gtk' 'breeze-icons' 'plasma-workspace' 'kde-cli-tools')

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
    find "$RES_DIR/wallpapers" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) -exec cp {} "$pkgdir/usr/share/wallpapers/UniOS/contents/images/" \;

    ICON="$RES_DIR/logos/unios-icon.png"
    install -Dm644 "$ICON" "$pkgdir/usr/share/pixmaps/unios.png"
    install -Dm644 "$ICON" "$pkgdir/usr/share/icons/hicolor/256x256/apps/unios.png"

    # UniOS icon theme: Breeze Dark + UniOS launcher/distro logo
    THEME="$pkgdir/usr/share/icons/unios-breeze-dark"
    for n in start-here-kde start-here-kde-symbolic start-here-kde-plasma start-here-kde-plasma-symbolic \
             distributor-logo distributor-logo-symbolic unios; do
      install -Dm644 "$ICON" "$THEME/apps/256/$n.png"
    done

    cat << 'EOF' > "$THEME/index.theme"
[Icon Theme]
Name=UniOS Breeze Dark
Comment=Breeze Dark with UniOS branding
Inherits=breeze-dark,breeze,hicolor
Directories=apps/256

[apps/256]
Size=256
MinSize=16
MaxSize=512
Context=Applications
Type=Scalable
EOF
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
Theme=unios-breeze-dark
EOF

  # Splash screen shown after login (replaces the Plasma logo)
  SPLASH="$pkgdir/usr/share/plasma/look-and-feel/org.unios.splash"
  install -Dm644 "$RES_DIR/splash/metadata.json" "$SPLASH/metadata.json"
  install -Dm644 "$RES_DIR/splash/Splash.qml" "$SPLASH/contents/splash/Splash.qml"
  install -Dm644 "$RES_DIR/logos/unios-icon.png" "$SPLASH/contents/splash/images/unios.png"

  cat << 'EOF' > "$pkgdir/etc/xdg/ksplashrc"
[KSplash]
Engine=KSplashQML
Theme=org.unios.splash
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
