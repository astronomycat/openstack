
echo 0 >/selinux/enforce
yum install -y nfs-*

yum install -y http://rdo.fedorapeople.org/rdo-release.rpm
yum upgrade -y
yum remove rdo-release -y

mkdir /home/nfs/
mkdir /media/CentOS/
mount -o nolock -t nfs 9.186.105.78:/home/nfs/ /home/nfs/
mount -o loop /home/nfs/isos/CentOS-6.5-x86_64-bin-DVD1.iso /media/CentOS
sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/CentOS-Media.repo

mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.back
yum install -y git
mv /etc/yum.repos.d/CentOS-Base.back /etc/yum.repos.d/CentOS-Base.repo
sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/CentOS-Media.repo

ifconfig eth1 0.0.0.0 #(eth1 is the NETWORK_DEVICE in build.include)
touch /etc/rsyslog.d/60-stack-cluster.conf
touch /etc/logrotate.d/openstack_logs

git clone http://gerrit.rtp.raleigh.ibm.com/osee-tools.git -b osee-havana

cd osee-tools/install

sed -i 's/NEUTRON_DHCP_AGENT_INI_FILE DEFAULT use_namespaces False/NEUTRON_DHCP_AGENT_INI_FILE DEFAULT use_namespaces True/g' /root/osee-tools/install/step090.neutron.sh
sed -i 's/NEUTRON_L3_AGENT_INI_FILE DEFAULT use_namespaces False/NEUTRON_L3_AGENT_INI_FILE DEFAULT use_namespaces True/g' /root/osee-tools/install/step090.neutron.sh



sed -i 's/CONFIGURE_VLAN=n/CONFIGURE_VLAN=y/g' ./build.include
sed -i 's/NETWORK_DEVICE=/NETWORK_DEVICE=eth1/g' ./build.include
sed -i 's/NEUTRON_L3_AGENT=n/NEUTRON_L3_AGENT=y/g' ./build.include

./runall.sh

ln -s /root/creds/openrc /root/keystone_rc
