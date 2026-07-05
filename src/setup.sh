#!/usr/bin/env bash

# 0. Ensure script is run from the correct directory and as root
cd "$(dirname "$0")" || exit 1
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root (sudo)." >&2
  exit 1
fi

# 1. Copy wallpaper
mkdir -p /usr/share/wallpapers/MyWallpaper/contents/images
if [ -f ../resources/unios.jpg ]; then
  cp ../resources/unios.jpg /usr/share/wallpapers/MyWallpaper/contents/images/unios.jpg
fi

# 2. Copy unios.png and unibackpack.png icons
mkdir -p /usr/share/icons/hicolor/256x256/apps
if [ -f ../resources/unios.png ]; then
  cp ../resources/unios.png /usr/share/icons/hicolor/256x256/apps/unios.png
fi

# Fallback handler for the unibackpack resource icon file
if [ -f ../resources/unibackpack.png ]; then
  cp ../resources/unibackpack.png /usr/share/icons/hicolor/256x256/apps/unibackpack.png
fi
gtk-update-icon-cache /usr/share/icons/hicolor/ 2>/dev/null

# 3. Set default wallpaper in main.xml
if [ -f /usr/share/plasma/wallpapers/org.kde.image/contents/config/main.xml ]; then
  sed -i 's|<default></default>|<default>/usr/share/wallpapers/MyWallpaper/contents/images/unios.jpg</default>|' \
    /usr/share/plasma/wallpapers/org.kde.image/contents/config/main.xml
fi

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

# 10. Remove plasma-welcome package entirely
apt-get remove --purge -y plasma-welcome || true
apt-get autoremove --purge -y

# 11. Securely provision the PPA authentication keys and repositories
sed -i 's/^deb cdrom:/# deb cdrom:/g' /etc/apt/sources.list 2>/dev/null
rm -f /etc/apt/sources.list.d/*cdrom*

# Fetch the repository signing authority key natively
curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x1607DC0CE88E5632F345ECD73946FECCB0BACE79" \
  | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/unios-ppa.gpg

# Points strictly to the verified core team distribution mirror URL
cat > /etc/apt/sources.list.d/unios.list << 'EOF'
deb [signed-by=/etc/apt/trusted.gpg.d/unios-ppa.gpg] https://ppa.launchpadcontent.net/unios-team/ppa/ubuntu noble main
EOF

# 12. Run mirror synchronization pass
apt-get clean
apt-get update

# 13. Install core distribution utilities from your Launchpad PPA channels
apt-get install -y python3-unidesk unibackpack unios-desktop-settings

# 14. Add unidesk to autostart definitions
cat > /etc/skel/.config/autostart/unidesk.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=UniDesk
Exec=unidesk
Icon=unios
Terminal=false
X-KDE-autostart-condition=false
EOF
cp /etc/skel/.config/autostart/unidesk.desktop /etc/skel/.config/default/autostart/

# 15. Adjust layout configurations for Kickoff start menu icon custom boundaries
if [ -f /usr/share/plasma/layout-templates/org.kde.plasma.desktop.defaultPanel/contents/layout.js ]; then
  sed -i 's/panel.addWidget("org.kde.plasma.kickoff")/var kickoff = panel.addWidget("org.kde.plasma.kickoff")\nkickoff.currentConfigGroup = ["General"]\nkickoff.writeConfig("icon", "unios")/' \
    /usr/share/plasma/layout-templates/org.kde.plasma.desktop.defaultPanel/contents/layout.js
fi

# 16. Remove legacy distribution desktop properties
rm -f /etc/skel/Desktop/org.kfocus.web.howtos.desktop
rm -f /etc/skel/Desktop/org.kubuntu.web.home.desktop

# 17. Brand Calamares installation wizard properties to UniOS layout targets
if [ -f /usr/share/applications/kubuntu-calamares.desktop ]; then
  sed -i 's/Name=Install Kubuntu.*/Name=Install UniOS/' /usr/share/applications/kubuntu-calamares.desktop
  sed -i 's/GenericName=Install Kubuntu/GenericName=Install UniOS/' /usr/share/applications/kubuntu-calamares.desktop
  sed -i 's/Icon=system-software-install/Icon=unios/' /usr/share/applications/kubuntu-calamares.desktop
  sed -i '/^Name\[/d' /usr/share/applications/kubuntu-calamares.desktop
  sed -i '/^GenericName\[/d' /usr/share/applications/kubuntu-calamares.desktop
  
  mkdir -p /etc/skel/Desktop
  cp /usr/share/applications/kubuntu-calamares.desktop /etc/skel/Desktop/
fi

# 18. Supply structural desktop launchers for the application portfolio
mkdir -p /etc/skel/Desktop
cat > /etc/skel/Desktop/unibackpack.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=UniBackpack
Comment=University software installer
Exec=unibackpack
Icon=unibackpack
Terminal=false
Categories=Utility;
EOF
chmod +x /etc/skel/Desktop/unibackpack.desktop

# If running on a live system, copy shortcuts directly to the active user's home folder
if [ -n "$SUDO_USER" ] && [ -d "/home/$SUDO_USER/Desktop" ]; then
  cp /etc/skel/Desktop/*.desktop "/home/$SUDO_USER/Desktop/"
  chown "$SUDO_USER:$SUDO_USER" /home/$SUDO_USER/Desktop/*.desktop
fi

# 19. Run pipeline diagnostics
echo "=== Verification Audit ==="
echo "PPA Status Check:" && cat /etc/apt/sources.list.d/unios.list
echo "Installed Component Presence:" && dpkg -l | grep -E "unidesk|unibackpack|unios-desktop-settings"
echo "Desktop Shortcut Status:" && ls -l /etc/skel/Desktop/