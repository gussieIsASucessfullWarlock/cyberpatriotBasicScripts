#!/bin/bash

### Description: Configure firewall

read -p "Which firewall would you like to configure? (iptables/ufw): " firewall

if [[ $firewall == "iptables" ]]; then
    echo "Configuring iptables..."

    iptables -P INPUT DROP
    iptables -P OUTPUT ACCEPT

    read -p "Enter the ports you want to open (comma-separated list): " ports

    IFS=',' read -ra port_array <<< "$ports"

    for port in "${port_array[@]}"; do
        iptables -A INPUT -p tcp --dport "$port" -j ACCEPT
    done

    echo "iptables configuration completed."
elif [[ $firewall == "ufw" ]]; then
    echo "Configuring ufw..."
    sudo ufw --force reset
    
    sudo ufw default deny incoming
    sudo ufw default allow outgoing

    read -p "Enter the ports you want to open (comma-separated list): " ports

    IFS=',' read -ra port_array <<< "$ports"

    for port in "${port_array[@]}"; do
        sudo ufw allow "$port"
    done

    sudo ufw enable

    echo "ufw configuration completed."
else
    echo "Invalid choice. Please choose either iptables or ufw."
fi


netstat -tuln | awk '/^tcp/ {split($4, a, ":"); print a[2]}' | while read -r port; do
    if [[ -z ${open_ports["$port"]} ]]; then
        echo "Warning: Port $port is open but not in the firewall list."
        pid=$(lsof -i :$port -t)
        exe=$(readlink -f /proc/$pid/exe)
        echo "Executable path: $exe"
    fi
done