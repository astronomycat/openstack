source /root/keystonerc_admin
neutron port-list |grep $1 |cut -d \| -f 2
