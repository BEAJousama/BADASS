#!/bin/sh

ip link add br0 type bridge
ip link set dev br0 up
ip link add vxlan10 type vxlan id 10 dstport 4789 local 1.1.1.4 nolearning
ip link set dev vxlan10 up
brctl addif br0 vxlan10
brctl addif br0 eth0
# bridge fdb append 00:00:00:00:00:00 dev vxlan10 dst 1.1.1.2

vtysh
configure terminal

no ipv6 forwarding
!
interface eth2
    ip address 10.1.1.10/30
    ip ospf area 0
!

interface lo
    ip address 1.1.1.4/32
    ip ospf area 0
!

router bgp 1
    bgp router-id 1.1.1.4
    neighbor 1.1.1.1 remote-as 1
    neighbor 1.1.1.1 update-source lo
    !
    address-family l2vpn evpn
        neighbor 1.1.1.1 activate
        advertise-all-vni
    exit-address-family
!

router ospf
#  network 0.0.0.0/0 area 0
!

exit
exit
exit

# ip link set dev vxlan10 type vxlan local 1.1.1.4 dstport 4789 id 10 nolearning



 