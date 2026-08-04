#!/bin/bash

# Author: Apostolos Chalis 2026 <achalis@csd.auth.gr> 

cd "$(dirname "$0")" || exit 1
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (sudo)." >&2
  exit 1
fi

# 1. Copy wallpaper
mkdir -p /usr/share/wallpapers/MyWallpaper/contents/images
if [ ! -f ../resources/unios.jpg ]; then
  echo "Wallpaper missing: ../resources/unios.jpg was not installed." >&2
  exit 1
fi
cp ../resources/unios.jpg /usr/share/wallpapers/MyWallpaper/contents/images/unios.jpg

# 4. Set up skel config directory
mkdir -p /etc/skel/.config/autostart
mkdir -p /etc/skel/.config/default/autostart

# 5. Set wallpaper config for new users
cat > /etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc << 'EOF'
[Containments][1][Wallpaper][org.kde.image][General]
Image=file:///usr/share/wallpapers/MyWallpaper/contents/images/unios.jpg
EOF
cp /etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc /etc/skel/.config/default/

# 6. Set Breeze Dark theme
cat > /etc/skel/.config/kdeglobals << 'EOF'
[KDE]
LookAndFeelPackage=org.kde.breezedark.desktop

[General]
ColorScheme=BreezeDark

[Icons]
Theme=breeze-dark

[KDE Action Restrictions]
action/help_about_kde=false
EOF
cp /etc/skel/.config/kdeglobals /etc/skel/.config/default/

# 7. Set Plasma style
cat > /etc/skel/.config/plasmarc << 'EOF'
[Theme]
name=breeze-dark
EOF
cp /etc/skel/.config/plasmarc /etc/skel/.config/default/

# 8. Disable KDE welcome screen
cat > /etc/skel/.config/plasma-welcome-appletsrc << 'EOF'
[General]
ShouldShow=false
EOF
cp /etc/skel/.config/plasma-welcome-appletsrc /etc/skel/.config/default/

# 9. Disable KDED welcome module
cat > /etc/skel/.config/kded_plasma_welcomerc << 'EOF'
[Module]
autoload=false
EOF
cp /etc/skel/.config/kded_plasma_welcomerc /etc/skel/.config/default/

