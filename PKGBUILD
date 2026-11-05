# Maintainer: Apostolos Chalis <achalis@csd.auth.gr>
# Builds from the local checkout: run makepkg from the repository root.
pkgname=unios-desktop-settings
pkgver=1.0.0
pkgrel=10
pkgdesc="UniOS desktop configuration, artwork, branding and welcome autostart for KDE Plasma"
arch=('any')
url="https://github.com/open-source-uom/unios-desktop-settings"
license=('GPL-3.0-or-later')
depends=('breeze' 'breeze-gtk' 'plasma-workspace' 'kde-cli-tools' 'qt6-tools')
optdepends=('firefox: the default web browser')

package() {
  cd "$startdir"

  local f
  for f in kdeglobals plasmarc mimeapps.list kded5rc plasma-welcomerc; do
    install -Dm644 "files/etc/xdg/$f" "$pkgdir/etc/xdg/$f"
  done
  install -Dm644 files/etc/xdg/autostart/unios-plasma-setup.desktop \
    "$pkgdir/etc/xdg/autostart/unios-plasma-setup.desktop"
  install -Dm755 files/usr/lib/unios/unios-plasma-setup.sh \
    "$pkgdir/usr/lib/unios/unios-plasma-setup.sh"

  install -Dm644 resources/logos/unios.png "$pkgdir/usr/share/pixmaps/unios.png"
  install -Dm644 resources/logos/unios.png "$pkgdir/usr/share/icons/hicolor/256x256/apps/unios.png"
  install -Dm644 resources/logos/unios.png "$pkgdir/usr/share/icons/hicolor/256x256/apps/distributor-logo.png"

  # One KDE wallpaper package per directory, images named after their resolution
  local wp
  for wp in resources/wallpapers/*/; do
    wp=$(basename "$wp")
    install -Dm644 "resources/wallpapers/$wp/metadata.json" "$pkgdir/usr/share/wallpapers/$wp/metadata.json"
    install -Dm644 -t "$pkgdir/usr/share/wallpapers/$wp/contents/images" "resources/wallpapers/$wp/contents/images/"*
  done
}
