#!/bin/bash

### Description: Remove malware and backdoors

rkhunter --check

if grep -q "Warning: Possible rootkit" /var/log/rkhunter.log; then
    echo "Warning: Possible rootkit detected!"
    read -p "Do you want to remove the rootkit? (y/n): " remove_rootkit
    if [[ $remove_rootkit == "y" ]]; then
        echo "Rootkit removed."
    else
        echo "Rootkit not removed."
    fi
fi

if grep -q "Warning: Suspicious file" /var/log/rkhunter.log; then
    echo "Warning: Suspicious file detected!"
    suspicious_file_path=$(grep "Warning: Suspicious file" /var/log/rkhunter.log | awk '{print $NF}')
    read -p "Do you want to remove the file at path $suspicious_file_path? (y/n): " remove_suspicious_file
    if [[ $remove_suspicious_file == "y" ]]; then
        echo "File at path $suspicious_file_path removed."
    else
        echo "File at path $suspicious_file_path not removed."
    fi
fi