#!/bin/sh

vtysh

configure terminal

no ipv6 forwarding
!
interface eth0
    ip address 10.1.1.1/30
!

interface eth1
    ip address 10.1.1.5/30
!

interface eth2
    ip address 10.1.1.9/30
!


interface lo
    ip address 1.1.1.1/32
!

router bgp 65000
    bgp router-id 1.1.1.1
    # no bgp default ipv4-unicast
    neighbor VTEP-PEERS peer-group
    neighbor VTEP-PEERS remote-as 65000
    neighbor VTEP-PEERS update-source lo
    bgp listen range 1.1.1.0/29 peer-group VTEP-PEERS

    !
    address-family l2vpn evpn
        neighbor VTEP-PEERS activate
        neighbor VTEP-PEERS route-reflector-client
    exit-address-family
!

router ospf
    network 0.0.0.0/0 area 0
!

line vty
!
