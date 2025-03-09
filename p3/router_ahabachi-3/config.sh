#!/bin/sh

vtysh
configure terminal

no ipv6 forwarding
!
interface eth0
    ip address 10.1.1.6/30
    ip ospf area 0
!

interface lo
    ip address 10.1.1.3/32
    ip ospf area 0
!

router bgp 1
    neighbor 1.1.1.1 remote-as 1
    neighbor 1.1.1.1 update-source lo
    !
    address-family l2vpn evpn
        neighbor 1.1.1.1 activate
        # advertise-all-vni
    exit-address-family
!
router ospf
!

