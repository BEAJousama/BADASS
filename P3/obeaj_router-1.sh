# Enter FRR VTYSH shell
vtysh
# Enter configuration mode
configure terminal

# Disable IPv6 forwarding to focus on IPv4 only
no ipv6 forwarding

# Configure physical interfaces with point-to-point IPv4 addresses
# Each interface is in a different /30 subnet which allows for 2 usable addresses
!
interface eth0
    ip address 10.1.1.1/30    # First P2P link (usable range: 10.1.1.1-10.1.1.2)

! 
interface eth1
    ip address 10.1.1.5/30    # Second P2P link (usable range: 10.1.1.5-10.1.1.6)

!
interface eth2
    ip address 10.1.1.9/30    # Third P2P link (usable range: 10.1.1.9-10.1.1.10)

# Configure loopback interface - used for BGP peering and as router-id
!
interface lo
    ip address 1.1.1.1/32    # Loopback address with /32 mask (single host)

# BGP Configuration - AS 65000 (private ASN for internal use)
! 
router bgp 65000
    # Set the BGP router ID to match loopback
    bgp router-id 1.1.1.1
    
    # This line is commented out but would disable automatic IPv4 unicast activation
    # no bgp default ipv4-unicast
    
    # Create a peer group called VTEP-PEERS for EVPN/VXLAN tunnel endpoints
    neighbor VTEP-PEERS peer-group
    
    # All peers in this group are in the same AS (internal BGP/iBGP)
    neighbor VTEP-PEERS remote-as 65000
    
    # Use loopback as the source interface for BGP sessions
    # This ensures stable BGP sessions even if a physical interface fails
    neighbor VTEP-PEERS update-source lo
    
    # Dynamic peer discovery - automatically accept BGP connections from this range
    # Any router with a loopback in 1.1.1.0/29 can peer with this router
    bgp listen range 1.1.1.0/29 peer-group VTEP-PEERS
    
    # EVPN address family configuration - used for VXLAN control plane
    ! 
    address-family l2vpn evpn
        # Enable EVPN for the peer group
        neighbor VTEP-PEERS activate
        
        # This router acts as a route reflector for the EVPN network
        # Allows for a scalable EVPN topology without full-mesh peering
        neighbor VTEP-PEERS route-reflector-client
    exit-address-family

# OSPF Configuration - used for underlay routing protocol
! 
router ospf
    # Advertise all interfaces into OSPF area 0 (backbone area)
    # This ensures reachability of loopback addresses for BGP peering
    network 0.0.0.0/0 area 0

# Enable remote terminal access
! 
line vty