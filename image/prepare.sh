#!/bin/bash
set -e
source /bd_build/buildconfig
set -x

## Prevent initramfs updates from trying to run grub and lilo.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189
export INITRD=no
mkdir -p /etc/container_environment
echo -n no > /etc/container_environment/INITRD

## Enable Ubuntu Universe and Multiverse.
sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list
sed -i 's/^#\s*\(deb.*multiverse\)$/\1/g' /etc/apt/sources.list
apt-get update

## Fix some issues with APT packages.
## See https://github.com/dotcloud/docker/issues/1024
dpkg-divert --local --rename --add /sbin/initctl
ln -sf /bin/true /sbin/initctl

## Replace the 'ischroot' tool to make it always return true.
## Prevent initscripts updates from breaking /dev/shm.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## https://bugs.launchpad.net/launchpad/+bug/974584
dpkg-divert --local --rename --add /usr/bin/ischroot
ln -sf /bin/true /usr/bin/ischroot

# apt-utils fix for Ubuntu 16.04
$minimal_apt_get_install apt-utils

$minimal_apt_get_install syslog-ng

## Install HTTPS support for APT.
$minimal_apt_get_install apt-transport-https ca-certificates

## Install add-apt-repository
$minimal_apt_get_install software-properties-common gpg-agent openssl net-tools 

## Install extended packages
apt-get install -y sudo wget build-essential automake autoconf nano python3-pip

## Updates information about available repository packages
apt-get update -y

## Upgrade all packages.
apt-get dist-upgrade -y --no-install-recommends

# prepare SGE dependencies
#apt-get install -y pkgconf git cmake # libgrpc-dev libdb5.3-dev libhwloc-dev libmotif-dev libncurses-dev libpam0g-dev libssl-dev libsystemd-dev libtirpc-dev libxext-dev

## Update libssl1.1
wget -P /tmp http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb
dpkg -i /tmp/libssl1.1_1.1.0g-2ubuntu4_amd64.deb

## Fix locale.
$minimal_apt_get_install language-pack-en
locale-gen en_US
update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8
echo -n en_US.UTF-8 > /etc/container_environment/LANG
echo -n en_US.UTF-8 > /etc/container_environment/LC_CTYPE
