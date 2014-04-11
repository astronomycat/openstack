ip li add vxlan0 type vxlan id 88 group 239.1.1.1 local 192.168.105.162 dev eth1
ifconfig vxlan0 10.0.100.162/24 up
