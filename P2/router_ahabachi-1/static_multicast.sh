#!/bin/sh

# Create a Linux bridge interface
# This will connect regular interfaces with the VXLAN overlay
ip link add br0 type bridge

# Activate the bridge interface
ip link set dev br0 up

# Assign IP address to physical interface eth0
# This IP will be used for underlay network communication
ip addr add 10.1.1.1/24 dev eth0

# Create VXLAN interface using static unicast configuration
# - id 10: VXLAN Network Identifier (VNI) is 10
# - dev eth0: Physical interface used for VXLAN traffic
# - remote 10.1.1.2: Static remote VTEP endpoint
# - local 10.1.1.1: Local IP address for VXLAN tunnel
# - dstport 4789: Standard VXLAN UDP port
ip link add name vxlan10 type vxlan id 10 dev eth0 remote 10.1.1.2 local 10.1.1.1 dstport 4789

# Assign IP address to VXLAN interface
# This creates a routed VXLAN interface (L3VXLAN)
# Hosts in the 20.1.1.0/24 subnet can use this as a gateway
ip addr add 20.1.1.1/24 dev vxlan10

# Add physical interface eth1 to the bridge
# Local devices connected to eth1 will be part of the bridged domain
brctl addif br0 eth1

# Add VXLAN interface to the bridge
# This bridges the VXLAN tunnel with the local interface
# NOTE: This creates a mixed L2/L3 configuration that may cause unpredictable behavior
# Typically, you either assign an IP to vxlan10 OR bridge it, not both
brctl addif br0 vxlan10

# Activate the VXLAN interface
ip link set dev vxlan10 up