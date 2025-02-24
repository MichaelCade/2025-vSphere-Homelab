#Modify config files to match the ISOs downloaded to the content library
#!/bin/bash

# Path to the config directory
config_dir="config"

# List of files to modify (inside config/)
files=(
  "linux-almalinux-8.pkrvars.hcl"
  "linux-almalinux-9.pkrvars.hcl"
  "linux-centos-10.pkrvars.hcl"
  "linux-centos-9.pkrvars.hcl"
  "linux-debian-11.pkrvars.hcl"
  "linux-debian-12.pkrvars.hcl"
  "linux-fedora-41.pkrvars.hcl"
  "linux-oracle-8.pkrvars.hcl"
  "linux-oracle-9.pkrvars.hcl"
  "linux-photon-4.pkrvars.hcl"
  "linux-photon-5.pkrvars.hcl"
  "linux-rhel-8.pkrvars.hcl"
  "linux-rhel-9.pkrvars.hcl"
  "linux-rocky-8.pkrvars.hcl"
  "linux-rocky-9.pkrvars.hcl"
  "linux-sles-15.pkrvars.hcl"
  "linux-storage.pkrvars.hcl"
  "linux-ubuntu-20-04-lts.pkrvars.hcl"
  "linux-ubuntu-22-04-lts.pkrvars.hcl"
  "linux-ubuntu-24-04-lts.pkrvars.hcl"
  "windows-desktop-10.pkrvars.hcl"
  "windows-desktop-11.pkrvars.hcl"
  "windows-server-2019.pkrvars.hcl"
  "windows-server-2022.pkrvars.hcl"
  "windows-server-2025.pkrvars.hcl"
)

# Loop through each file in the config directory
for file in "${files[@]}"; do
  filepath="$config_dir/$file"
  
  if [[ -f "$filepath" ]]; then
    # Modify the file in-place
    sed -i -E '
      s#^(iso_datastore_path\s*=\s*).*#\1""#;
      s#^(iso_file\s*=\s*).*#\1""#;
      s#^(iso_content_library_item\s*=\s*"(.*)")#iso_content_library_item = "\2.iso"#;
    ' "$filepath"

    echo "✅ Updated: $filepath"
  else
    echo "⚠️  Skipping: $filepath (not found)"
  fi
done

echo "🚀 All applicable files updated!"
