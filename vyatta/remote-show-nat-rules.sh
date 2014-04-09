if [ x$1 = x ]; then
echo "Please specify the ip addr of the vyatta gw"
exit
fi


vyatta_gw=$1

ssh root@$vyatta_gw "/root/openstack-scripts/show-nat-rules.sh -d"
sleep 1
scp root@$vyatta_gw:/root/show_nat_rules_*.txt ./
cat show_nat_rules_dst.txt
cat show_nat_rules_src.txt

