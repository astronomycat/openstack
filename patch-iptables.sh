iptables -nL FORWARD | awk '{if($1~ /REJECT/) print NR-2 }'| sort -r | while read i; do iptables -D FORWARD $i; done;
iptables -nL INPUT | awk '{if($1~ /REJECT/) print NR-2 }'| sort -r | while read i; do iptables -D INPUT $i; done;


#iptables -nL FORWARD| awk '{if($1~ /REJECT/) system("iptables -D FORWARD " NR-2) }'
#iptables -nL INPUT| awk '{if($1~ /REJECT/) system("iptables -D INPUT " NR-2) }'

