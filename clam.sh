#!/bin/bash

### Description: Remove malware

if ! command -v clamscan &> /dev/null; then
    echo "ClamAV is not installed. Installing ClamAV..."
    sudo apt-get update
    sudo apt-get install -y clamav
fi

scan_result=$(clamscan -r /)

if echo "$scan_result" | grep -q "Infected files: [1-9]"; then
    echo "Malware or backdoors found!"
    echo "$scan_result"
    
    read -p "Do you want to remove the threats? (y/n): " remove_threats
    
    if [[ $remove_threats == "y" ]]; then
        sudo clamscan -r --remove /
        echo "Threats removed successfully."
    else
        echo "Threats were not removed."
    fi
else
    echo "No malware or backdoors found."
fi
