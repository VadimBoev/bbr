#!/bin/bash

# ANSI escape codes for colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

# Function to check if BBR is enabled
check_bbr_enabled() {
    sysctl net.ipv4.tcp_congestion_control | grep -q "bbr"
    return $?
}

# Function to disable BBR and enable CUBIC
disable_bbr_enable_cubic() {
    echo -e "${CYAN}Disabling BBR and enabling CUBIC...${NC}"  # Заменили BLUE на CYAN
    
    # Remove BBR settings from sysctl.conf
    sudo sed -i '/net.core.default_qdisc=fq/d' /etc/sysctl.conf
    sudo sed -i '/net.ipv4.tcp_congestion_control=bbr/d' /etc/sysctl.conf
    
    # Set CUBIC as the default congestion control algorithm
    echo "net.ipv4.tcp_congestion_control=cubic" | sudo tee -a /etc/sysctl.conf
    
    # Apply the changes
    sudo sysctl -p
    
    echo -e "${GREEN}BBR has been disabled and CUBIC has been enabled.${NC}"
}

# Main script
if check_bbr_enabled; then
    disable_bbr_enable_cubic
else
    echo -e "${ORANGE}BBR is not enabled. No changes needed.${NC}"
fi
