#!/bin/bash

# Function to check if BBR is enabled
check_bbr_enabled() {
    sysctl net.ipv4.tcp_congestion_control | grep -q "bbr"
    return $?
}

# Function to disable BBR and enable CUBIC
disable_bbr_enable_cubic() {
    echo "Disabling BBR and enabling CUBIC..."
    
    # Remove BBR settings from sysctl.conf
    sudo sed -i '/net.core.default_qdisc=fq/d' /etc/sysctl.conf
    sudo sed -i '/net.ipv4.tcp_congestion_control=bbr/d' /etc/sysctl.conf
    
    # Set CUBIC as the default congestion control algorithm
    echo "net.ipv4.tcp_congestion_control=cubic" | sudo tee -a /etc/sysctl.conf
    
    # Apply the changes
    sudo sysctl -p
    
    echo "BBR has been disabled and CUBIC has been enabled."
}

# Main script
if check_bbr_enabled; then
    disable_bbr_enable_cubic
else
    echo "BBR is not enabled. No changes needed."
fi
