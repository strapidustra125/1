# https://docs.fedoraproject.org/en-US/fedora/f30/install-guide/appendixes/Kickstart_Syntax_Reference/

# Configure installation method
install
url --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-30&arch=x86_64"
repo --name=fedora-updates --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f30&arch=x86_64" --cost=0
repo --name=rpmfusion-free --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-30&arch=x86_64" --includepkgs=rpmfusion-free-release
repo --name=rpmfusion-free-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-30&arch=x86_64" --cost=0
repo --name=rpmfusion-nonfree --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-30&arch=x86_64" --includepkgs=rpmfusion-nonfree-release
repo --name=rpmfusion-nonfree-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-30&arch=x86_64" --cost=0

# zerombr
zerombr

# Configure Boot Loader
bootloader --location=mbr --driveorder=sda

# Create Physical Partition
part /boot --size=512 --asprimary --ondrive=sda --fstype=xfs
part swap --size=2048 --ondrive=sda 
part / --size=8192 --grow --asprimary --ondrive=sda --fstype=xfs 

# Remove all existing partitions
clearpart --all --drives=sda

# Configure Firewall
firewall --enabled --ssh

# Configure Network Interfaces
network --onboot=yes --bootproto=dhcp --hostname=sina-laptop

# Configure Keyboard Layouts
keyboard us

# Configure Language During Installation
lang en_AU

# Configure X Window System
xconfig --startxonboot

# Configure Time Zone
timezone Australia/Sydney

# Create User Account
user --name=nik --password=144166 --groups=wheel

# Set Root Password
rootpw --lock

# Perform Installation in Text Mode
text

# Package Selection
%packages
@core
@standard
@hardware-support
@base-x
@fonts
@networkmanager-submodules
@xfce-desktop
vim
NetworkManager-openvpn-gnome
# keepassx
redshift-gtk
nmap
tcpdump
ansible
# vlc
redhat-rpm-config
rpmconf
strace
# wireshark
# ffmpeg
# system-config-printer
git-review
gcc-c++
readline-devel
python3-virtualenvwrapper
usbmuxd
ifuse
# exfat-utils
# fuse-exfat
jq
icedtea-web
docker
%end

# Post-installation Script
%post
# Install Google Chrome
# cat << EOF > /etc/yum.repos.d/google-chrome.repo
# [google-chrome]
# name=google-chrome
# baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
# enabled=1
# gpgcheck=1
# gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
# EOF
# rpm --import https://dl-ssl.google.com/linux/linux_signing_key.pub
# dnf install -y google-chrome-stable

# Harden sshd options
echo "" > /etc/ssh/sshd_config

#vimrc configuration
echo "filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
set nohlsearch" > /home/sina/.vimrc

cat <<EOF > /home/sina/.bashrc
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi
source /usr/bin/virtualenvwrapper.sh
export GOPATH=/home/sina/Development/go
export PATH=$PATH:/home/sina/Development/go/bin
alias irssi='firejail irssi'
EOF

# Disable IPv6
cat <<EOF >> /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF

# Enable services
systemctl enable usbmuxd

# Disable services
systemctl disable sssd
systemctl disable bluetooth.target
systemctl disable avahi-daemon
systemctl disable abrtd
systemctl disable abrt-ccpp
systemctl disable mlocate-updatedb
systemctl disable mlocate-updatedb.timer
systemctl disable gssproxy
systemctl disable bluetooth
systemctl disable geoclue
systemctl disable ModemManager
sed -i 's/Disabled=false/Disabled=true/g' /etc/xdg/tumbler/tumbler.rc

#docker
sudo systemctl start docker
sudo systemctl enable docker
sudo curl -o /usr/bin/containers.sh https://raw.githubusercontent.com/strapidustra125/1/master/containers.sh
sudo chmod +x /usr/bin/containers.sh
sudo curl -o /etc/systemd/system/containers.service https://raw.githubusercontent.com/strapidustra125/1/master/containers.service
sudo chmod 644 /etc/systemd/system/containers.service
sudo systemctl enable containers.service
%end

# Reboot After Installation
reboot --eject

