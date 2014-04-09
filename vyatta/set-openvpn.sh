#!/bin/vbash

# Set/configure openvpn server

# Kai Zheng: zhengkai@cn.ibm.com

source /root/openstack-scripts/header.sh

tls_key_path=/config/auth/keys
echo "warning: the default tls_key_path is set to "$tls_key_path

vtun_name=vtun0
echo "warning: the default vtun name is set to "$vtun_name

mode=server
echo "warning: the default mode of vtun0 is set to "$mode

server_subnet=
server_push_route=


openvpn_option=--comp-lzo
echo "warning: the default openvpn-option name is set to "$openvpn-option

protocol=tcp-passive
echo "warning: the default protocol is set to "$protocol



while getopts "n:ms:r:o:p:k:" arg 
do
        case $arg in
             n)
                echo "vtun_name="$OPTARG
                vtun_name=$OPTARG
                ;;
             m)
                echo "mode="$OPTARG
                mode=$OPTARG
                ;;
             s)
                echo "server_subnet="$OPTARG
                server_subnet=$OPTARG
                ;;
             r)
                echo "server_push_route="$OPTARG
                server_push_route=$OPTARG
                ;;
             o)
                echo "openvpn-option="$OPTARG
                openvpn_option=$OPTARG
                ;;
             p)
               	echo "protocol="$OPTARG
		protocol=$OPTARG
                ;;
	     k)
		echo "tls_key_path="$OPTARG
                tls_key_path=$OPTARG
		;;
	
             ?)  
            	echo "unknow argument"
		echo "usage set-openvpn <-s server_subnet> <-r push_route>"
		echo "                  [-n vtun_name][-m mode]"
		echo "                  [-p protocols][-o option]"
		echo "                  [-k tls_key_path]"
        	exit 1
        	;;
        esac
done

if [ x${server_subnet} = x ] ; then
                echo "usage set-openvpn <-s server_subnet> <-r push_route>"
                echo "                  [-n vtun_name][-m mode]"
                echo "                  [-p protocols][-o option]"
                echo "                  [-k tls_key_path]"

exit;
fi

if [ x${server_push_route} = x ] ; then
                echo "usage set-openvpn <-s server_subnet> <-r push_route>"
                echo "                  [-n vtun_name][-m mode]"
                echo "                  [-p protocols][-o option]"
                echo "                  [-k tls_key_path]"
exit;
fi

$DELETE interfaces openvpn $vtun_name

#echo "set interfaces openvpn "$vtun_name
$SET interfaces openvpn $vtun_name

#echo "set interfaces openvpn "$vtun_name" mode "$mode
$SET interfaces openvpn $vtun_name mode $mode

#echo "set interfaces openvpn "$vtun_name" openvpn-option "$openvpn_option
$SET interfaces openvpn $vtun_name openvpn-option $openvpn_option

#echo "set interfaces openvpn "$vtun_name" server subnet "$server_subnet
$SET interfaces openvpn $vtun_name server subnet $server_subnet

#echo "set interfaces openvpn "$vtun_name" server push-route "$server_push_route
$SET interfaces openvpn $vtun_name server push-route $server_push_route

$SET interfaces openvpn $vtun_name protocol $protocol

#echo "set interfaces openvpn "$vtun_name" tls ca-cert-file " $tls_key_path"/ca.crt"
$SET interfaces openvpn $vtun_name tls ca-cert-file $tls_key_path/ca.crt
$SET interfaces openvpn $vtun_name tls cert-file $tls_key_path/vyatta.crt
$SET interfaces openvpn $vtun_name tls dh-file $tls_key_path/dh1024.pem
$SET interfaces openvpn $vtun_name tls key-file $tls_key_path/vyatta.key


$COMMIT 
$SAVE

