#!/bin/bash

important_files=(
    "/etc/passwd-"
    "/etc/shadow-"
    "/etc/group-"
    "/etc/gshadow-"
    "/etc/hosts.allow"
    "/etc/hosts.deny"
    "/etc/hosts"
    "/etc/hostname"
    "/etc/resolv.conf"
    "/etc/network/interfaces"
    "/etc/networks"
    "/etc/sysctl.conf"
    "/etc/sysctl.d"
    "/etc/shadow"
    "/etc/gshadow"
    "/etc/passwd"
    "/etc/group"
    "/etc/sudoers"
    "/etc/sudoers.d"
    "/etc/ssh/sshd_config"
    "/etc/ssh/ssh_config"
)
for user in $(cut -d: -f1 /etc/passwd); do
    important_files+=("/var/spool/cron/crontabs/$user")
done
for user in $(cut -d: -f1 /etc/passwd); do
    important_files+=("/home/$user/.ssh/authorized_keys")
done
for user in $(cut -d: -f1 /etc/passwd); do
    important_files+=("/home/$user/.ssh/known_hosts")
done
for user in $(cut -d: -f1 /etc/passwd); do
    important_files+=("/home/$user/.ssh/id_rsa")
done
for user in $(cut -d: -f1 /etc/passwd); do
    important_files+=("/home/$user/.ssh/id_ecdsa")
done
for user in $(cut -d: -f1 /etc/passwd); do
    important_files+=("/home/$user/.ssh/id_ed25519")
done
for user in $(cut -d: -f1 /etc/passwd); do
    important_files+=("/home/$user/.gnupg/secring.gpg")
done


# Check file permissions
for file in "${important_files[@]}"; do
    permissions=$(stat -c "%a" "$file")
    if [[ $permissions != "600" ]]; then
        echo "Bad file permissions detected for $file"
        echo "Fixing file permissions..."
        chmod 600 "$file"
        echo "File permissions fixed for $file"
    fi
done
