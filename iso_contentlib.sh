#!/bin/bash

#A script to pull down ISOs to your content library, change to your Content Library name below, chmod it and run the script. You will need govc and you will need to export connection details for your vSphere environment
# Set your vSphere Content Library name
CONTENT_LIBRARY="vZilla-Content-Library"

# List of ISO URLs
ISO_URLS=(
    "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.9.0-amd64-netinst.iso"
    "https://cdimage.debian.org/cdimage/archive/11.11.0/arm64/iso-cd/debian-11.11.0-arm64-netinst.iso"
    "https://releases.ubuntu.com/releases/24.04.1/ubuntu-24.04.2-live-server-amd64.iso"
    "https://releases.ubuntu.com/releases/22.04/ubuntu-22.04.5-live-server-amd64.iso"
    "https://releases.ubuntu.com/releases/20.04.6/ubuntu-20.04.6-live-server-amd64.iso"
    "https://download.rockylinux.org/pub/rocky/9.5/isos/x86_64/Rocky-9.5-x86_64-dvd.iso"
    "https://download.rockylinux.org/pub/rocky/8.10/isos/x86_64/Rocky-8.10-x86_64-dvd1.iso"
    "https://repo.almalinux.org/almalinux/9.5/isos/x86_64/AlmaLinux-9.5-x86_64-dvd.iso"
    "https://repo.almalinux.org/almalinux/8.10/isos/x86_64/AlmaLinux-8.10-x86_64-dvd.iso"
    "https://yum.oracle.com/ISOS/OracleLinux/OL9/u5/x86_64/OracleLinux-R9-U5-x86_64-dvd.iso"
    "https://yum.oracle.com/ISOS/OracleLinux/OL8/u10/x86_64/OracleLinux-R8-U10-x86_64-dvd.iso"
    "https://mirror.stream.centos.org/10-stream/BaseOS/x86_64/iso/CentOS-Stream-10-latest-x86_64-dvd1.iso"
    "https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-dvd1.iso"
    "https://download.fedoraproject.org/pub/fedora/linux/releases/41/Server/x86_64/iso/Fedora-Server-dvd-x86_64-41-1.4.iso"
    "https://packages.vmware.com/photon/5.0/GA/iso/photon-5.0-dde71ec57.x86_64.iso"
    "https://packages.vmware.com/photon/4.0/Rev2/iso/photon-4.0-c001795b8.iso"
    "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.1.240331-1435.ge_release_SERVER_EVAL_x64FRE_en-us.iso"
    "https://software-static.download.prss.microsoft.com/sg/download/888969d5-f34g-4e03-ac9d-1f9786c66749/SERVER_EVAL_x64FRE_en-us.iso"
    "https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66749/17763.3650.221105-1748.rs5_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
    "https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/22631.2428.231001-0608.23H2_NI_RELEASE_SVC_REFRESH_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
    "https://software-static.download.prss.microsoft.com/dbazure/988969d5-f34g-4e03-ac9d-1f9786c66750/19045.2006.220908-0225.22h2_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
    "https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-12.9.0-amd64-kde.iso"
    "https://archlinux.uk.mirror.allworldit.com/archlinux/iso/2025.03.01/archlinux-2025.03.01-x86_64.iso"
    "https://channels.nixos.org/nixos-24.11/latest-nixos-plasma6-x86_64-linux.iso"
    "https://channels.nixos.org/nixos-24.11/latest-nixos-gnome-x86_64-linux.iso"
    "https://repo.almalinux.org/almalinux/9.5/isos/x86_64/AlmaLinux-9.5-x86_64-dvd.iso"
    "https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/x86_64/alpine-virt-3.21.3-x86_64.iso"
    "https://iso.artixlinux.org/iso/artix-plasma-dinit-20240823-x86_64.iso"
    "https://cdimage.kali.org/kali-2024.4/kali-linux-2024.4-installer-amd64.iso"
    "https://deb.parrot.sh/parrot/iso/6.3.2/Parrot-security-6.3.2_amd64.iso"
    "https://cdimage.ubuntu.com/kubuntu/releases/24.10/release/kubuntu-24.10-desktop-amd64.iso"
    "https://mirrors.cicku.me/linuxmint/iso/stable/22.1/linuxmint-22.1-cinnamon-64bit.iso"
    "https://cdimage.ubuntu.com/lubuntu/releases/noble/release/lubuntu-24.04.2-desktop-amd64.iso"
    "https://downloads.getsol.us/isos/2025-01-26/Solus-Budgie-Release-2025-01-26.iso"
    "https://distro.ibiblio.org/tinycorelinux/15.x/x86/release/CorePlus-current.iso"
)

# Maximum length for filenames
MAX_LENGTH=80

# Loop through each ISO URL and import it into the vSphere content library
for URL in "${ISO_URLS[@]}"; do
    FILENAME=$(basename "$URL")  # Extract filename from URL

    # Truncate filename if it exceeds the maximum length
    if [ ${#FILENAME} -gt $MAX_LENGTH ]; then
        FILENAME="${FILENAME:0:$MAX_LENGTH}"
    fi

    CHECK_EXISTS=$(govc library.ls $CONTENT_LIBRARY/$FILENAME)
    if [ -z $CHECK_EXISTS ]; then
        echo "Importing $FILENAME into $CONTENT_LIBRARY..."
        govc library.import -n "$FILENAME" "$CONTENT_LIBRARY" "$URL" 
        echo "Done! $FILENAME has been imported into $CONTENT_LIBRARY"
    else
        echo "$FILENAME already exists in $CONTENT_LIBRARY Content Library - skipping"
    fi
done
echo "All ISOs have been processed!"
