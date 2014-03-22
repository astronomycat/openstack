mkdir /home/nfs/
mkdir /media/CentOS/
mount -t nfs -o nolock 9.186.105.78:/home/nfs/ /home/nfs/
mount -o loop /home/nfs/isos/CentOS-6.5-x86_64-bin-DVD1.iso /media/CentOS
sed -i 's/enabled=0/enabled=1/g' /etc/yum.repos.d/CentOS-Media.repo

