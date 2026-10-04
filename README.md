# Tempo Clock

A clean desktop clock for Linux Mint (XFCE) and other GTK desktops: world clock,
alarms, stopwatch, timer and time converter in one lightweight window.

## Features

- **World Clock**: large analog and digital clock, plus cards for your favorite
  cities showing the time, the day (today, tomorrow, yesterday) and the hour
  difference from your main clock.
- **Alarms**: labels, repeat days (every day, weekdays, weekends or custom) and
  an on/off switch for each alarm.
- **Stopwatch**: hundredth-of-a-second precision with lap splits and totals.
- **Timer**: countdown ring, one-click presets (1 to 60 minutes) and custom times.
- **Time Converter**: turn a time in one city into the time in another.
- **Appearance**: light, dark or system theme, eight accent colors, 12-hour or
  24-hour time, optional seconds.

Your data is stored locally. The app never connects to the internet.

## Requirements

- Linux Mint 20 or newer (XFCE, Cinnamon or MATE), or any Debian/Ubuntu-based system
- `python3`, `python3-gi`, `gir1.2-gtk-3.0` and `gir1.2-webkit2-4.1`
  (or `gir1.2-webkit2-4.0` on older releases)

The `.deb` installs these automatically.

## Installation

```bash
sudo apt install ./tempo-clock_1.0.0_all.deb
```

Then start **Tempo Clock** from the menu (Utilities) or run `tempo-clock` in a terminal.

To remove it:

```bash
sudo apt remove tempo-clock
```

## Running from source

```bash
sudo apt install python3-gi gir1.2-gtk-3.0 gir1.2-webkit2-4.1
python3 src/tempo-clock.py
```

## Building the .deb

You only need `dpkg-deb`, which is included in every Debian-based system:

```bash
./build-deb.sh
```

The package is created at `dist/tempo-clock_1.0.0_all.deb`.

## Project layout

```
src/tempo-clock.py        GTK window that hosts the interface (WebKitGTK)
src/www/index.html        The whole interface: HTML, CSS and JavaScript
src/tempo-clock.desktop   Menu entry
src/tempo-clock.svg       Application icon
build-deb.sh              Builds the Debian package
LICENSE                   MIT license
```

## Keyboard shortcuts

| Shortcut | Action |
|----------|--------|
| Ctrl+1 | World Clock |
| Ctrl+2 | Alarms |
| Ctrl+3 | Stopwatch |
| Ctrl+4 | Timer |
| Ctrl+5 | Converter |
| Ctrl+6 | Settings |
| Esc | Close a dialog |

## Data and privacy

Cities, alarms and settings are saved in `~/.local/share/tempo-clock`.
To erase everything, use **Settings > Reset app**, or delete that folder.

## Troubleshooting

- **No sound for alarms or timers**: install the audio plugins with
  `sudo apt install gstreamer1.0-plugins-good gstreamer1.0-pulseaudio`.
- **Alarms don't ring**: alarms only ring while the app is open. Keep it running
  (it can be minimized).
- **Window stays dark or light**: choose a theme under Settings > Theme.

## License

Released under the [MIT License](LICENSE).