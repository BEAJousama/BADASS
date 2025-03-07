#!/bin/sh

echo "starting..."

/usr/lib/frr/frr start

# /usr/lib/frr/frr start bgpd
# /usr/lib/frr/frr start ospfd
# /usr/lib/frr/frr start isisd

echo "shell..."

/bin/sh

