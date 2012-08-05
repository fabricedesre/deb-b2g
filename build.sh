#!/bin/bash
GECKO_VERSION=17
VERSION=${GECKO_VERSION}.0a1-`date +%d%m%y%H%M`

rm -rf tmp

mkdir -p tmp/opt/b2g
mkdir -p tmp/usr/share/xsessions
mkdir -p tmp/usr/share/unity-greeter
mkdir -p tmp/DEBIAN

# Clone gaia if needed, or just update.
# Using --depth 1 to get as few git history as possible.
if [ ! -d gaia ]; then
echo "Cloning gaia repository"
git clone --depth 1 https://github.com/mozilla-b2g/gaia.git
fi
cd gaia; git pull; make profile; cd ..

# Create an archive of the profile.
tar --directory gaia/profile -cjf tmp/opt/b2g/profile.tar.bz2 `ls gaia/profile`

# Download the latest b2g desktop build and unpack it.
wget https://ftp.mozilla.org/pub/mozilla.org/b2g/nightly/latest-mozilla-central/b2g-${GECKO_VERSION}.0a1.en-US.linux-i686.tar.bz2
tar --directory tmp/opt/b2g -xjf b2g-${GECKO_VERSION}.0a1.en-US.linux-i686.tar.bz2
rm b2g-${GECKO_VERSION}.0a1.en-US.linux-i686.tar.bz2

cp custom_b2g_badge.png tmp/usr/share/unity-greeter/custom_b2g_badge.png
cp launch.sh tmp/opt/b2g/launch.sh
cp session.sh tmp/opt/b2g/session.sh
cp b2g.desktop tmp/usr/share/xsessions/b2g.desktop

touch tmp/DEBIAN/control

cat > tmp/DEBIAN/control << EOF
Package: b2g
Version: ${VERSION}
Maintainer: Fabrice Desré <fabrice@desre.org>
Architecture: amd64
Description: Boot 2 Gecko (http://www.mozill.org/b2g) is a web based operating system.
  The project’s proposed architecture eliminates the need for apps to be 
  built on platform-specific native APIs. Using HTML5, developers everywhere
  can write directly to the Web; they can create amazing user experiences and
  apps unencumbered by the rules and restrictions of closely controlled
  platforms.
  As with all Mozilla projects, the Boot to Gecko project is based entirely on
  open standards and the source code is open and accessible to all. Where open
  standards are missing (including telephony, SMS, camera, bluetooth, USB and
  NFC), we're working with standards bodies and other vendors to create them.
  .
EOF

fakeroot dpkg-deb -b tmp b2g_${VERSION}_i386.deb
echo "You can install your b2g package with |sudo dpkg -i b2g_${VERSION}_i386.deb| and launch it with |/opt/b2g/launch.sh|"
