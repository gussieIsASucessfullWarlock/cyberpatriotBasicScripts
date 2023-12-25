#!/bin/bash

### Description: Disable cron jobs

users=$(cut -d: -f1 /etc/passwd)

for user in $users; do
    cronjobs=$(crontab -l -u $user 2>/dev/null)
    
    if [[ -n $cronjobs ]]; then
        echo "User: $user"
        echo "Cron jobs:"
        echo "$cronjobs"
        
        read -p "Disable cron jobs for user $user? (y/n): " choice
        
        # Disable the cron jobs if the user confirms
        if [[ $choice == "y" ]]; then
            crontab -r -u $user
            echo "Cron jobs disabled for user $user"
        else
            echo "Cron jobs not disabled for user $user"
        fi
        
        echo
    fi
done
