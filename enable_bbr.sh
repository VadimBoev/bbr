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

# Function to enable BBR
enable_bbr() {
    echo -e "${CYAN}Enabling BBR...${NC}"
    echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    echo -e "${GREEN}BBR has been enabled.${NC}"
}

# Main script
if check_bbr_enabled; then
    echo -e "${ORANGE}BBR is already enabled.${NC}"
else
    enable_bbr
fi
