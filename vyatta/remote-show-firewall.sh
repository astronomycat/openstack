
if [ x$1 = x ]; then
echo "Please specify the ip addr of the vyatta gw"
exit
fi

vyatta_gw=$1

ssh root@$vyatta_gw "/root/openstack-scripts/show-firewall.sh -d"
sleep 2
scp root@$vyatta_gw:/root/show_firewall.txt ./
cat show_firewall.txt

