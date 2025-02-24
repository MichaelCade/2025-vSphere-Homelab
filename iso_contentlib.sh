#!/bin/bash

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

    echo "Importing $FILENAME into $CONTENT_LIBRARY..."

    govc library.import -n "$FILENAME" "$CONTENT_LIBRARY" "$URL"

    if [ $? -eq 0 ]; then
        echo "Successfully imported: $FILENAME"
    else
        echo "Failed to import: $FILENAME"
    fi
done

echo "All ISOs have been processed!"
