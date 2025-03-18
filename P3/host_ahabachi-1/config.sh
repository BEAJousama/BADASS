#!/bin/sh

# Assign IP address to interface eth0
ip addr add 20.1.1.1/24 dev eth0

# Command breakdown:
# ip addr add - Command to add an IP address
# 20.1.1.1 - The specific IP address being assigned
# /24 - Subnet mask (equivalent to 255.255.255.0, allowing 254 hosts)
# dev eth0 - The network interface receiving this IP address
