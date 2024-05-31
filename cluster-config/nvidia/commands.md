# GDRCopy


# Check GDRCopy 2.3 is installed
rpm -q gdrcopy-kmod-2.3-1dkms
rpm -q gdrcopy-devel-2.3-1.noarch
rpm -q gdrcopy-2.3-1.x86_64

OR 

dpkg -l gdrcopy-kmod-2.3-1dkms
dpkg -l gdrcopy-devel-2.3-1.noarch
dpkg -l gdrcopy-2.3-1.x86_64

# Uninstall GDRCopy 2.3
sudo rpm -e gdrcopy-kmod
sudo rpm -e gdrcopy-devel-2.3-1
sudo rpm -e gdrcopy-2.3-1

# Check GDRCopy 2.3 is uninstalledcd
rpm -q gdrcopy-kmod-2.3-1dkms
rpm -q gdrcopy-devel-2.3-1.noarch
rpm -q gdrcopy-2.3-1.x86_64

VERSION="2.3.1"
VERSION="2.4"
wget https://github.com/NVIDIA/gdrcopy/archive/refs/tags/v$VERSION.tar.gz
tar -xzf v$VERSION.tar.gz
cd gdrcopy-$VERSION/packages
CUDA=/usr/local/cuda ./build-rpm-packages.sh
CUDA="/usr/local/cuda" CXXFLAGS="-g -std=c++11 -Wall -pedantic" ./build-rpm-packages.sh

rpm -q gdrcopy-kmod-$VERSION-1dkms || rpm -Uvh gdrcopy-kmod-$VERSION-1dkms.amzn-2.noarch.rpm
rpm -q gdrcopy-$VERSION-1.amzn-2.x86_64 || rpm -Uvh gdrcopy-$VERSION-1.amzn-2.x86_64.rpm
rpm -q gdrcopy-devel-$VERSION-1.amzn-2.noarch || rpm -Uvh gdrcopy-devel-$VERSION-1.amzn-2.noarch.rpm


CUDA=/usr/local/cuda ./build-deb-packages.sh
dpkg -i gdrdrv-dkms_$VERSION-1_amd64.Ubuntu22_04.deb
dpkg -i libgdrapi_$VERSION-1_amd64.Ubuntu22_04.deb
dpkg -i gdrcopy-tests_$VERSION-1_amd64.Ubuntu22_04+cuda12.2.deb
dpkg -i gdrcopy_$VERSION-1_amd64.Ubuntu22_04.deb

### Final Checks
modinfo -F version gdrdrv
systemctl is-enabled gdrcopy
systemctl is-enabled gdrdrv
sanity
copybw
copylat
apiperf -s 8
