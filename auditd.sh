#!/bin/bash

### Description: Install and configure auditd

sudo apt-get update
sudo apt-get install auditd -y

sudo tee /etc/audit/rules.d/cyberpatriots.rules > /dev/null <<EOT

# Rule 1: Monitor changes to system files
-w /etc/passwd -p wa -k system_files_changes
-w /etc/shadow -p wa -k system_files_changes
-w /etc/group -p wa -k system_files_changes
-w /etc/gshadow -p wa -k system_files_changes
-w /etc/sudoers -p wa -k system_files_changes

# Rule 2: Monitor user logins and logouts
-w /var/log/auth.log -p wa -k user_logins

# Rule 3: Monitor system startup and shutdown
-w /var/log/syslog -p wa -k system_startup_shutdown

# Rule 4: Monitor privilege escalation attempts
-a always,exit -F arch=b64 -S execve -C uid!=euid -F euid=0 -k privilege_escalation_attempts
-a always,exit -F arch=b32 -S execve -C uid!=euid -F euid=0 -k privilege_escalation_attempts

# Rule 5: Monitor failed login attempts
-w /var/log/auth.log -p wa -k failed_login_attempts
EOT

sudo systemctl restart auditd