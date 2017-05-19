#!/bin/sh -eux

HOME_DIR="/home/vagrant"
pubkey_url="https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub";

case "$PACKER_BUILDER_TYPE" in
virtualbox-iso|virtualbox-ovf)
    #Install VBOX tools
    VER="`cat /home/vagrant/.vbox_version`"
    ISO="VBoxGuestAdditions_$VER.iso"
    mkdir -p /tmp/vbox
    mount -o loop $HOME_DIR/$ISO /tmp/vbox
    sh /tmp/vbox/VBoxLinuxAdditions.run \
        || echo "VBoxLinuxAdditions.run exited $? and is suppressed." \
            "For more read https://www.virtualbox.org/ticket/12479"
    umount /tmp/vbox
    rm -rf /tmp/vbox


    mkdir -p $HOME_DIR/.ssh
    if command -v wget >/dev/null 2>&1; then
        wget --no-check-certificate "$pubkey_url" -O $HOME_DIR/.ssh/authorized_keys
    elif command -v curl >/dev/null 2>&1; then
        curl --insecure --location "$pubkey_url" > $HOME_DIR/.ssh/authorized_keys
    else
        echo "Cannot download vagrant public key"
        exit 1
    fi
    chown -R vagrant $HOME_DIR/.ssh
    chmod -R go-rwsx $HOME_DIR/.ssh

    ;;
esac
