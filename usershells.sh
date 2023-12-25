#!/bin/bash

### Description: Change all users shell to /bin/bash

users=$(cat /etc/passwd | cut -d: -f1)

for user in $users
do
    shell=$(cat /etc/passwd | grep $user | cut -d: -f7)
    if [ "$shell" != "/bin/nologin" ] && [ "$shell" != "/bin/false" ]; then
        chsh -s /bin/bash $user
    fi
done