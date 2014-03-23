iptables -nL FORWARD| awk '{if($1~ /REJECT/) system("iptables -D FORWARD " NR-2) }'
iptables -nL INPUT| awk '{if($1~ /REJECT/) system("iptables -D INPUT " NR-2) }'

