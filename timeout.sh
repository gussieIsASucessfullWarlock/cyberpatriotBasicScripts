#!/bin/bash

### Description: Set screen lock, blanking and power management timeouts

gsettings set org.gnome.desktop.screensaver lock-enabled true

gsettings set org.gnome.desktop.session idle-delay 300

gsettings set org.gnome.desktop.session idle-delay 300

gsettings set org.gnome.settings-daemon.plugins.power sleep-display-ac 300

gsettings set org.gnome.settings-daemon.plugins.power sleep-display-battery 300