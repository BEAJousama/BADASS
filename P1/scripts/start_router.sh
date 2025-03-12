#!/bin/sh

echo "starting..."
/usr/lib/frr/frr start
echo "shell..."
busybox sh
