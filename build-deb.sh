#!/usr/bin/env bash
# Builds dist/tempo-clock_<version>_all.deb  (needs only dpkg-deb)
set -euo pipefail
PKG=tempo-clock; VERSION=1.0.0
ROOT="$(cd "$(dirname "$0")" && pwd)"
STAGE="$ROOT/build/${PKG}_${VERSION}"
rm -rf "$ROOT/build"; mkdir -p "$STAGE/DEBIAN" "$STAGE/usr/bin" "$ROOT/dist"

install -Dm755 "$ROOT/src/tempo-clock.py"      "$STAGE/usr/lib/$PKG/tempo-clock.py"
install -Dm644 "$ROOT/src/www/index.html"      "$STAGE/usr/lib/$PKG/www/index.html"
install -Dm644 "$ROOT/src/tempo-clock.desktop" "$STAGE/usr/share/applications/tempo-clock.desktop"
install -Dm644 "$ROOT/src/tempo-clock.svg"     "$STAGE/usr/share/icons/hicolor/scalable/apps/tempo-clock.svg"
printf '#!/bin/sh\nexec python3 /usr/lib/%s/tempo-clock.py "$@"\n' "$PKG" > "$STAGE/usr/bin/tempo-clock"
chmod 755 "$STAGE/usr/bin/tempo-clock"

SIZE=$(du -sk "$STAGE/usr" | cut -f1)
cat > "$STAGE/DEBIAN/control" <<CTL
Package: $PKG
Version: $VERSION
Section: utils
Priority: optional
Architecture: all
Installed-Size: $SIZE
Depends: python3, python3-gi, gir1.2-gtk-3.0, gir1.2-webkit2-4.1 | gir1.2-webkit2-4.0
Recommends: gstreamer1.0-plugins-base, gstreamer1.0-plugins-good, gstreamer1.0-pulseaudio
Maintainer: Tempo Clock <tempo@localhost>
Description: World clock, alarms, stopwatch and timer
 Tempo Clock is a lightweight desktop clock with world time zones, alarms,
 a stopwatch, a countdown timer and a time converter. Light and dark themes.
CTL
for s in postinst postrm; do
cat > "$STAGE/DEBIAN/$s" <<'SH'
#!/bin/sh
set -e
command -v gtk-update-icon-cache >/dev/null && gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor || true
command -v update-desktop-database >/dev/null && update-desktop-database -q /usr/share/applications || true
exit 0
SH
chmod 755 "$STAGE/DEBIAN/$s"; done

dpkg-deb --build --root-owner-group "$STAGE" "$ROOT/dist/${PKG}_${VERSION}.deb"
echo "Built: dist/${PKG}_${VERSION}.deb"
