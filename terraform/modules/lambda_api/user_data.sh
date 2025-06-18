#!/bin/bash

# initialize script of nat instance

# enable ip forwarding
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# masquerade setting
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
