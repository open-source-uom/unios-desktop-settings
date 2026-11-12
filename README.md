# unios-desktop-settings

The package that gives UniOS its look on KDE Plasma: Breeze Dark by default, Firefox as the browser, the UniOS wallpapers and logo, no Plasma Welcome Center, and a first login script that puts the UniOS wallpaper and logo in place.

More in the [docs](https://docs.unios-project.eu/unios-desktop-settings/).

## What it installs

| Path | What it is |
| --- | --- |
| `/etc/xdg/kdeglobals`, `/etc/xdg/plasmarc` | Breeze Dark look and feel, colors, icons and Plasma theme with the UniOS purple (`#ae73a6`) accent, Firefox as the browser |
| `/etc/xdg/mimeapps.list` | Firefox as the default for web links |
| `/etc/xdg/kded5rc`, `/etc/xdg/plasma-welcomerc` | keep the Plasma Welcome Center from starting |
| `/etc/xdg/autostart/unios-plasma-setup.desktop` | runs the setup script when a user logs in to Plasma |
| `/usr/lib/unios/unios-plasma-setup.sh` | sets the UniOS wallpaper and launcher icon, on the first login only |
| `/usr/share/wallpapers/UniOS*/` | the UniOS, UniOS Patterns and UniOS Dense Patterns wallpapers |
| `/usr/share/pixmaps/unios.png`, `/usr/share/icons/hicolor/256x256/apps/` | the UniOS logo, also as `distributor-logo` |

The files in `/etc/xdg` are only defaults, anything a user sets in their own `~/.config` wins. They're in the `backup` array, so if you edit them on a machine, upgrades leave your copy alone and put the new one next to it as `.pacnew`.

The setup script leaves `~/.local/state/unios/plasma-setup.done` behind once Plasma has run it. Delete that file to run it again on the next login.

## Layout

```
files/                  installed at the same path on the system, listed in package()
resources/logos/        the UniOS logo
resources/wallpapers/   one KDE wallpaper package per directory
PKGBUILD
```

## Building

The `PKGBUILD` builds from the checkout, so run `makepkg` from the repository root:

```bash
makepkg -si
```

Then log out and back in so the setup script runs.

## Adding a wallpaper

Make a directory under `resources/wallpapers/` with a `metadata.json` (copy one of the others and change `Id` and `Name`) and put the image in `contents/images/`, named after its resolution, e.g. `3840x2160.jpg`. Plasma picks the image by that name and skips files named anything else.

## Releasing

Bump `pkgrel` (or `pkgver`, and reset `pkgrel` to `1`) so users get the update, then build it for `unios-repo` with the `pkgbuilder` process on [our build server](https://docs.unios-project.eu/build.unios-project.eu/).
