ip link delete vxlan0
ip li add vxlan0 type vxlan id 88 group 239.1.1.1 local 192.168.123.2 dev gre1

ifconfig vxlan0 0.0.0.0 up
ifconfig br-vxlan0 10.0.100.199/24 up

ovs-vsctl del-port br-vxlan0 vxlan0
ovs-vsctl add-port br-vxlan0 vxlan0

pkill -9 smcroute
/root/smcroute-1.99.2/src/smcroute -d -f /root/smcroute-1.99.2/src/smcroute.conf

iptables -t mangle -A OUTPUT -o gre1 -j TTL --ttl-set 32
