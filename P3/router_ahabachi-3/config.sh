#!/bin/sh

# ---------- LINUX VXLAN CONFIGURATION (Data Plane) - COMMENTED OUT ----------

# All VXLAN interface setup commands are commented out - not currently active

# Create a bridge interface to connect VXLAN tunnel with local interfaces
        # ip link add br0 type bridge
        # ip link set dev br0 up

# Create VXLAN tunnel interface with the following parameters:
# - VNI (VXLAN Network Identifier): 10
# - Destination UDP port: 4789 (standard VXLAN port)
# - Local IP: 1.1.1.3 (this router's loopback address)
# - nolearning: Disable MAC learning on the VXLAN interface (controlled by BGP EVPN instead)
        # ip link add vxlan10 type vxlan id 10 dstport 4789 local 1.1.1.3 nolearning
        # ip link set dev vxlan10 up

# Add the VXLAN interface to the bridge
        # brctl addif br0 vxlan10

# Add the local physical interface to the bridge
# eth0 will be used to connect local hosts to the VXLAN network
        # brctl addif br0 eth0

# ---------- FRR ROUTING CONFIGURATION (Control Plane) ----------

# Enter FRR VTYSH shell
vtysh
# Enter configuration mode
configure terminal

# Disable IPv6 forwarding to focus on IPv4 only
no ipv6 forwarding

# Configure physical interface with point-to-point IPv4 address
! 
interface eth1
    ip address 10.1.1.6/30    # P2P link matching the first router's eth1 subnet
    ip ospf area 0            # Enable OSPF on this interface in backbone area

# Configure loopback interface - used for BGP peering
! 
interface lo
    ip address 1.1.1.3/32     # Loopback address with /32 mask (single host)
    ip ospf area 0            # Advertise loopback in OSPF for reachability

# BGP Configuration - AS 65000 (matching the Route Reflector's AS)
! 
router bgp 65000
    # Set the BGP router ID to match loopback
    bgp router-id 1.1.1.3
    
    # Configure BGP peering with the Route Reflector (1.1.1.1)
    neighbor 1.1.1.1 remote-as 65000
    
    # Use loopback as the source interface for BGP session
    # This ensures stable BGP session even if a physical interface fails
    neighbor 1.1.1.1 update-source lo
    
    # EVPN address family configuration - used for VXLAN control plane
    ! 
    address-family l2vpn evpn
        # Enable EVPN for the BGP session with Route Reflector
        neighbor 1.1.1.1 activate
        
        # The advertise-all-vni command is commented out
        # This means this node is NOT advertising any VNIs via BGP EVPN
        # It will only receive EVPN routes from other VTEPs but not advertise any
        # advertise-all-vni
    exit-address-family

# OSPF Configuration (minimal since interface-specific config is above)
! 
router ospf
!