# Maintainer: Apostolos Chalis <achalis@csd.auth.gr>
pkgname=unios-desktop-settings
pkgver=1.0.0
pkgrel=5
pkgdesc="UniOS desktop configuration, artwork, and welcome autostart for KDE Plasma"
arch=('any')
url="https://github.com/open-source-uom/unios-desktop-settings"
license=('GPL3')
depends=('breeze' 'breeze-gtk' 'plasma-workspace' 'kde-cli-tools')

package() {
  install -d "$pkgdir/usr/share/wallpapers/UniOS/contents/images"
  
  for img in "$startdir"/resources/*.jpg "$startdir"/resources/*.png; do
    [ -f "$img" ] && install -Dm644 "$img" "$pkgdir/usr/share/wallpapers/UniOS/contents/images/"
  done

  install -d "$pkgdir/usr/share/wallpapers/UniOS"
  cat << 'EOF' > "$pkgdir/usr/share/wallpapers/UniOS/metadata.json"
{
    "KPlugin": {
        "Id": "UniOS",
        "Name": "UniOS Wallpapers"
    }
}
EOF

  install -d "$pkgdir/etc/xdg"
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

  install -d "$pkgdir/etc/skel/.config"
  cat << 'EOF' > "$pkgdir/etc/skel/.config/plasma-welcome-appletsrc"
[General]
ShouldShow=false
EOF

  cat << 'EOF' > "$pkgdir/etc/skel/.config/kded_plasma_welcomerc"
[Module]
autoload=false
EOF

  install -d "$pkgdir/usr/lib/unios"
  cat << 'EOF' > "$pkgdir/usr/lib/unios/unios-plasma-setup.sh"
#!/bin/bash
DEFAULT_WP="/usr/share/wallpapers/UniOS/contents/images/unios.jpg"
if [ -f "$DEFAULT_WP" ]; then
    plasma-apply-wallpaperimage "$DEFAULT_WP" >/dev/null 2>&1
fi
EOF
  chmod 755 "$pkgdir/usr/lib/unios/unios-plasma-setup.sh"

  install -d "$pkgdir/etc/xdg/autostart"
  cat << 'EOF' > "$pkgdir/etc/xdg/autostart/unios-plasma-setup.desktop"
[Desktop Entry]
Type=Application
Name=UniOS Plasma Setup
Exec=/usr/lib/unios/unios-plasma-setup.sh
Terminal=false
NoDisplay=true
X-KDE-autostart-phase=2
EOF

  cat << 'EOF' > "$pkgdir/etc/xdg/autostart/unidesk-welcome.desktop"
[Desktop Entry]
Type=Application
Name=UniDesk Welcome
Comment=Welcome to UniOS
Exec=unidesk
Icon=unidesk
Terminal=false
StartupNotify=true
Categories=Education;System;
EOF
}