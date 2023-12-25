#!/bin/bash

### Description: Set password policies


username=$(whoami)
if [ "$username" != "root" ]; then
    echo "You must be root to run this script"
    exit 1
fi
echo "Enter your username: "
read username
if [ "$username" == "root" ]; then
    echo "You cannot change the root password with this script"
    exit 1
fi

if [ -f /home/$username/password.txt ]; then
    echo "Password already set check /home/$username/password.txt"
    exit 1
fi

# Set password policies:
sed -i 's/PASS_MAX_DAYS\t99999/PASS_MAX_DAYS\t90/g' /etc/login.defs
sed -i 's/PASS_MIN_DAYS\t0/PASS_MIN_DAYS\t7/g' /etc/login.defs
sed -i 's/PASS_WARN_AGE\t7/PASS_WARN_AGE\t14/g' /etc/login.defs
sed -i 's/LOGIN_RETRIES\t\t\t3/LOGIN_RETRIES\t\t\t5/g' /etc/login.defs
sed -i 's/PASSWD_HISTSIZE\t\t0/PASSWD_HISTSIZE\t\t5/g' /etc/login.defs
sed -i 's/PASS_MIN_LEN\t\t5/PASS_MIN_LEN\t\t14/g' /etc/login.defs
authconfig --passalgo=sha512 --update
sed -i 's/password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok/password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5/g' /etc/pam.d/system-auth
sed -i 's/password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5/password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5 minlen=14/g' /etc/pam.d/system-auth
sed -i 's/password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5 minlen=14/password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5 minlen=14 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1/g' /etc/pam.d/system-auth
sed -i 's/password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5 minlen=14 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1/password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5 minlen=14 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1 remember=5/g' /etc/pam.d/system-auth
sed -i 's/password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5 minlen=14 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1 remember=5/password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5 minlen=14 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1 remember=5 maxrepeat=3/g' /etc/pam.d/system-auth
sed -i 's/password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5 minlen=14 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1 remember=5 maxrepeat=3/password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5 minlen=14 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1 remember=5 maxrepeat=3 difok=3/g' /etc/pam.d/system-auth
sed -i 's/password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5 minlen=14 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1 remember=5 maxrepeat=3 difok=3/password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5 minlen=14 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1 remember=5 maxrepeat=3 difok=3 lockout=3/g' /etc/pam.d/system-auth
sed -i 's/password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5 minlen=14 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1 remember=5 maxrepeat=3 difok=3 lockout=3/password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5 minlen=14 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1 remember=5 maxrepeat=3 difok=3 lockout=3 remember=5/g' /etc/pam.d/system-auth
sed -i 's/password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5 minlen=14 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1 remember=5 maxrepeat=3 difok=3 lockout=3 remember=5/password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5 minlen=14 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1 remember=5 maxrepeat=3 difok=3 lockout=3 remember=5 warn=7/g' /etc/pam.d/system-auth

# Check for empty passwords:
users=$(cut -d: -f1 /etc/passwd)
for user in $users
do
    password_field=$(grep "^$user:" /etc/shadow | cut -d: -f2)

    if [ -z "$password_field" ]; then
        echo "User $user has an empty password."
    fi
done

# Set password for all users:
users=$(cat /etc/passwd | cut -d: -f1)
for user in $users
do
    shell=$(cat /etc/passwd | grep $user | cut -d: -f7)
    if [ "$shell" != "/bin/nologin" ] && [ "$shell" != "/bin/false" ]; then
        password=$(openssl rand -base64 12)
        echo "$user:$password" | chpasswd --encrypted
        echo "Password set for user $user: $password"
        echo "Password set for user $user: $password" >> /home/$username/password.txt
    fi
done