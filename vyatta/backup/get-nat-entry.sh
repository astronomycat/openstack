floating_ip=$1

/opt/vyatta/sbin/vyatta-show-nat-rules.pl --type=destination | grep $floating_ip | awk '{print $1}'
