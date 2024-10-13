#!/bin/bash

# Function to check if BBR is enabled
check_bbr_enabled() {
    sysctl net.ipv4.tcp_congestion_control | grep -q "bbr"
    return $?
}

# Function to enable BBR
enable_bbr() {
    echo "Enabling BBR..."
    echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    echo "BBR has been enabled."
}

# Main script
if check_bbr_enabled; then
    echo "BBR is already enabled."
else
    enable_bbr
fi
