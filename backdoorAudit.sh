#!/bin/bash

### Description: Remove malware and backdoors

suspicious_processes=$(ps -ef | grep -E "nc|netcat|socat|cryptcat|shells|backdoor" | grep -v grep)
if [[ -n $suspicious_processes ]]; then
    echo "Suspicious processes found:"
    echo "$suspicious_processes"
    echo "Removing suspicious processes..."
    echo "$suspicious_processes" | awk '{print $2}' | xargs kill -9
    echo "Suspicious processes removed."
else
    echo "No suspicious processes found."
fi

# Check for suspicious files
suspicious_files=$(find / -type f -name "*.sh" -exec grep -l "backdoor" {} \;)
if [[ -n $suspicious_files ]]; then
    echo "Suspicious files found:"
    echo "$suspicious_files"
    echo "Removing suspicious files..."
    echo "$suspicious_files" | xargs rm -f
    echo "Suspicious files removed."
else
    echo "No suspicious files found."
fi


suspicious_files=$(find / -type f -name "*.pearl" -exec grep -l "backdoor" {} \;)
if [[ -n $suspicious_files ]]; then
    echo "Suspicious files found:"
    echo "$suspicious_files"
    echo "Removing suspicious files..."
    echo "$suspicious_files" | xargs rm -f
    echo "Suspicious files removed."
else
    echo "No suspicious files found."
fi


suspicious_files=$(find / -type f -name "*.py" -exec grep -l "backdoor" {} \;)
if [[ -n $suspicious_files ]]; then
    echo "Suspicious files found:"
    echo "$suspicious_files"
    echo "Removing suspicious files..."
    echo "$suspicious_files" | xargs rm -f
    echo "Suspicious files removed."
else
    echo "No suspicious files found."
fi