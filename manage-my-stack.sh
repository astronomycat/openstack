#!/bin/sh

TENANT_NAME="vyatta"
ADMIN_TENANT="service"
TENANT_DESC="vyatta demo: L3, VPN, FW"
USER_NAME="vyatta"
USER_PWD="vyatta"
USER_EMAIL="vyatta@domain.com"
USER_ROLE="Member"
#===========================================
INT_NET_NAME="internal"
INT_SUBNET_NAME="subnet_int"
EXT_NET_NAME="external"
EXT_SUBNET_NAME="subnet_ext"
INT_IP_CIDR="192.168.100.0/24"
FLOAT_IP_START="9.186.105.242"
FLOAT_IP_END="9.186.105.250"
EXT_GATEWAY="9.186.105.1"
EXT_IP_CIDR="9.186.105.0/24"

IS_CREATE_RT=false
ROUTER_NAME="vRouter"

#===========================================
IMAGE_NAME="vyatta-lite"
IMAGE_FILE=/home/nfs/isos/vyatta-lite-ss.img

VM_IMAGE_NAME="ubuntu-lite"
VM_IMAGE_FILE=/home/nfs/ubuntu-lite.img

IS_DELETE_IMAGE="false"

#===========================================
FLAVOR_ID=10
IS_CREATE_VOL="false"
NUM_CREATE_VOL=1
VOL_PREFIX="vyatta-gw-vol-"
IS_DELETE_VOL="true"

#===========================================
NUM_CREATE_GW=1
GW_PREFIX="vyatta-gw-"
IS_DELETE_GW="true"

NUM_CREATE_VM=2
VM_PREFIX="ubuntu-host-"
IS_DELETE_VM="true"


#===========================================
source /root/keystone_rc

if [ "$1" = "add" ]; then
	
	TENANT_ID=
	TENANT_ID=`keystone tenant-list|grep ${TENANT_NAME}|awk '{print $2}'`
	if [ -n "$TENANT_ID" ]; then
		echo project exists
	else
		echo create a new project
		keystone tenant-create --name ${TENANT_NAME} --description "${TENANT_DESC}"
		TENANT_ID=`keystone tenant-list|grep ${TENANT_NAME}|awk '{print $2}'`
	fi

	INT_NET_ID=
	INT_NET_ID=`neutron net-list | grep  ${INT_NET_NAME} |awk '{print $2}'`
	if [ -n "$INT_NET_ID" ]; then
		echo internal net exists
	else
		echo create a new internal net and subnet
		neutron net-create --tenant-id ${TENANT_ID} ${INT_NET_NAME}
		neutron subnet-create --tenant-id ${TENANT_ID} --name ${INT_SUBNET_NAME} ${INT_NET_NAME} ${INT_IP_CIDR} --dns_nameservers list=true 8.8.8.8
	fi

	EXT_NET_ID=
	EXT_NET_ID=`neutron net-list | grep  ${EXT_NET_NAME} |awk '{print $2}'`
	if [ -n "$EXT_NET_ID" ]; then
                echo external net exists
	else
		echo create a new external net and subnet
		ADMIN_ID=`keystone tenant-list| grep ${ADMIN_TENANT} |awk '{print $2}'`
		neutron net-create --tenant-id ${ADMIN_ID} ${EXT_NET_NAME} --router:external=True
		EXT_NET_VLAN_ID=`neutron net-show ${EXT_NET_NAME}|grep provider:segmentation_id | awk '{print $4}'`
		echo External_VLAN_ID= ${EXT_NET_VLAN_ID}
		neutron subnet-create --tenant-id ${ADMIN_ID} --name ${EXT_SUBNET_NAME} --allocation-pool start=${FLOAT_IP_START},end=${FLOAT_IP_END} --gateway ${EXT_GATEWAY} ${EXT_NET_NAME} ${EXT_IP_CIDR} --enable_dhcp=True
	fi

	if [ "$IS_CREATE_RT" = "true" ]; then
	echo add routers external gateway
	EXT_NET_ID=`neutron net-list|grep ${EXT_NET_NAME}|awk '{print $2}'`
	neutron router-gateway-set ${ROUTER_ID} ${EXT_NET_ID}
	fi

	IMAGE_ID=
	IMAGE_ID=`nova image-list|grep ${IMAGE_NAME}|awk '{print $2}'`
	if [ -n "${IMAGE_ID}" ]; then
		echo vyatta image exists
	else
		echo upload the vyatta image
		glance add disk_format=qcow2 container_format=ovf name=${IMAGE_NAME} is_public=true < ${IMAGE_FILE}
    		glance image-list
	fi

	VM_IMAGE_ID=
        VM_IMAGE_ID=`nova image-list|grep ${VM_IMAGE_NAME}|awk '{print $2}'`
        if [ -n "${VM_IMAGE_ID}" ]; then
                echo ubuntu image exists
        else
                echo upload the ubuntu image
                glance add disk_format=qcow2 container_format=ovf name=${VM_IMAGE_NAME} is_public=true < ${VM_IMAGE_FILE}
                glance image-list
        fi


	FLAVOR_NAME=
	FLAVOR_NAME=`nova flavor-list| grep ${FLAVOR_ID}| awk '{print $4}'`
	if [ -n "$FLAVOR_NAME" ]; then
		echo flavor $FLAVOR_NAME exists.
	else
		echo nova flavor-create --is-public true vyatta $FLAVOR_ID 512 1 1
		nova flavor-create --is-public true vyatta $FLAVOR_ID 512 1 1
	fi
	
	#neutron port-list --all-tenant
	#neutron net-list --all-tenant
	#neutron router-list --all-tenant

	if [ "$IS_CREATE_VOL" = true ]; then
		IMAGE_ID=`nova image-list|grep ${IMAGE_NAME}|awk '{print $2}'`
		if [ -n "$IMAGE_ID" ]; then
			echo glance image found
			for (( i=1; i<=$NUM_CREATE_VOL; i++ ));do 
				VOL_NAME=$VOL_PREFIX$i
				echo $VOL_NAME
				VOL_ID=	
				VOL_ID=`cinder list |grep $VOL_NAME| awk '{print $2}'`
				if [ -n "$VOL_ID" ]; then
					echo volume exists
				else
					echo cinder create --image-id $IMAGE_ID --display-name $VOL_NAME 1
					cinder create --image-id $IMAGE_ID --display-name $VOL_NAME 1 
					sleep 60
				fi
			done
		else echo no image provided
		fi
	fi

	if [ "$NUM_CREATE_GW" -gt 0 ]; then
		AVA_ZONE=control-zone
		NETWORK_ID_INT=`neutron net-list|grep ${INT_NET_NAME}|awk '{print $2}'`
		NETWORK_ID_EXT=`neutron net-list|grep ${EXT_NET_NAME}|awk '{print $2}'`

		for (( i=1; i<=$NUM_CREATE_GW; i++ ));do
			if [ "$IS_CREATE_VOL" = true ]; then
				VOL_NAME=$VOL_PREFIX$i
				VOL_ID=`nova volume-list |grep ${VOL_NAME}| awk '{print $2}'`
				GW_NAME=$GW_PREFIX$i
				echo $GW_NAME
				GW_ID=
				GW_ID=`nova list | grep $GW_NAME| awk '{print $2}'`
				if [ -n "$GW_ID" ]; then
                                        echo $GW_NAME exists
                        	else
                                        echo  nova boot --availability-zone ${AVA_ZONE} --flavor ${FLAVOR_ID} --block_device_mapping vda=${VOL_ID}:::0 --nic net-id=${NETWORK_ID_EXT} --nic net-id=${NETWORK_ID_INT} ${GW_NAME}

					nova boot --availability-zone ${AVA_ZONE} --flavor ${FLAVOR_ID} --block_device_mapping vda=${VOL_ID}:::0 --nic net-id=${NETWORK_ID_EXT} --nic net-id=${NETWORK_ID_INT} ${GW_NAME}
                                        
                        	fi
			else	
				echo create gw from image directly
				IMAGE_ID=`glance image-list|grep ${IMAGE_NAME}|awk '{print $2}'`
				GW_NAME=$GW_PREFIX$i
                                echo $GW_NAME
                                GW_ID=
                                GW_ID=`nova list | grep $GW_NAME| awk '{print $2}'`
                                if [ -n "$GW_ID" ]; then
                                        echo $GW_NAME exists
                                else
                                        echo  nova boot --availability-zone ${AVA_ZONE} --flavor ${FLAVOR_ID} --image ${IMAGE_ID} --nic net-id=${NETWORK_ID_EXT} --nic net-id=${NETWORK_ID_INT} ${GW_NAME}

					nova boot --availability-zone ${AVA_ZONE} --flavor ${FLAVOR_ID} --image ${IMAGE_ID} --nic net-id=${NETWORK_ID_EXT} --nic net-id=${NETWORK_ID_INT} ${GW_NAME}
				fi
			fi

		done
	fi



        if [ "$NUM_CREATE_VM" -gt 0 ]; then
                AVA_ZONE=compute-zone
                NETWORK_ID_INT=`neutron net-list|grep ${INT_NET_NAME}|awk '{print $2}'`
		VM_IMAGE_ID=`glance image-list|grep ${VM_IMAGE_NAME}|awk '{print $2}'`
                for (( i=1; i<=$NUM_CREATE_VM; i++ ));do
                        VM_NAME=$VM_PREFIX$i
                        echo vm $VM_NAME is to be created
                        VM_ID=
                        VM_ID=`nova list | grep $VM_NAME| awk '{print $2}'`
                        if [ -n "$VM_ID" ]; then
                                        echo $VM_NAME exists
                        else
					nova boot --availability-zone ${AVA_ZONE} --flavor 1  --image ${VM_IMAGE_ID} --nic net-id=${NETWORK_ID_INT} ${VM_NAME}
					nova list
                        fi
                done

        fi


elif [ "$1" = "delete" ]; then
	
	TENANT_ID=`keystone tenant-list|grep ${TENANT_NAME}|awk '{print $2}'`
	SUBNET_ID=`neutron subnet-list|grep ${INT_SUBNET_NAME}|awk '{print $2}'`
	ROUTER_ID=`neutron router-list|grep ${ROUTER_NAME}|awk '{print $2}'`
	EXT_NET_ID=`neutron net-list|grep ${EXT_NET_NAME}|awk '{print $2}'`


	if [ "$IS_DELETE_VM" = "true" ]; then
                for (( i=1; i<=$NUM_CREATE_VM; i++ ));do
                        VM_NAME=$VM_PREFIX$i
                        echo vm $VM_NAME is to be deleted
                        VM_ID=
                        VM_ID=`nova list | grep $VM_NAME| awk '{print $2}'`
                        if [ -n "$VM_ID" ]; then
                        	nova delete ${VM_NAME}
                        else
				echo ${VM_NAME} does not exist
                        fi
                nova list
                done

	else 	
		echo keep vyatta-gw instances
		echo now exist deleting...
		exit
	fi

	if [ "$IS_DELETE_GW" = true ]; then
		for (( i=1; i<=$NUM_CREATE_GW; i++ ));do
                        GW_NAME=$GW_PREFIX$i
                        echo vyatta GW $GW_NAME is to be deleted
                        GW_ID=
                        GW_ID=`nova list | grep $GW_NAME| awk '{print $2}'`
                        if [ -n "$GW_ID" ]; then
                                        nova delete ${GW_NAME}
                        else
                                        echo ${GW_NAME} does not exist
                        fi
                nova list
                done
	else	echo keep vyatta-gw instances
                echo now exist deleting...
                exit
        fi

	sleep 5
	
	if [ "$IS_DELETE_VOL" = true ]; then
		for (( i=1; i<=$NUM_CREATE_VOL; i++ ));do
                        VOL_NAME=$VOL_PREFIX$i
                        echo vyatta GW volume $VOL_NAME is to be deleted
                        VOL_ID=
                        VOL_ID=`cinder list | grep $VOL_NAME| awk '{print $2}'`
                        if [ -n "$VOL_ID" ]; then
       				cinder delete ${VOL_NAME}
                        else
                                echo ${VOL_NAME} does not exist
                        fi
                cinder list
                done

	else 	echo keep created cinder-volumes
	fi


	if [ -n "$ROUTER_ID" ]; then
		echo Removing the router added
		neutron router-gateway-clear ${ROUTER_ID} ${EXT_NET_ID}
		neutron router-interface-delete ${ROUTER_ID} ${SUBNET_ID}
		neutron router-delete ${ROUTER_ID}
	fi


	INT_NET_ID=`neutron net-list|grep ${INT_NET_NAME}|awk '{print $2}'`
	if [ -n "$INT_NET_ID" ]; then
		echo Removing the internal net added
		neutron net-delete ${INT_NET_ID}
	fi


	if [ -n "$EXT_NET_ID" ]; then
		echo Removing the external net added
		ADMIN_ID=`keystone tenant-list| grep ${ADMIN_TENANT} |awk '{print $2}'`
		neutron net-delete ${EXT_NET_NAME} --router:external=True
	fi

	if [ -n "$TENANT_ID" ]; then
        	echo Removing the project added
        	TENANT_ID=`keystone tenant-list|grep ${TENANT_NAME}|awk '{print $2}'`
        	keystone tenant-delete ${TENANT_ID}
	fi


	if [ "$IS_DELETE_IMAGE" = true ]; then 
		IMAGE_ID=
		IMAGE_ID=`nova image-list|grep ${IMAGE_NAME}|awk '{print $2}'`
		if [ -n "$IMAGE_ID" ]; then
			echo Removing the vyatta image added
			glance image-delete ${IMAGE_ID}
		fi

		VM_IMAGE_ID=
                VM_IMAGE_ID=`nova image-list|grep ${VM_IMAGE_NAME}|awk '{print $2}'`
                if [ -n "$VM_IMAGE_ID" ]; then
                        echo Removing the vm image added
                        glance image-delete ${VM_IMAGE_ID}
                fi

	else	echo keep uploaded images 
	fi


	FLAVOR_NAME=
	FLAVOR_NAME=`nova flavor-list| grep ${FLAVOR_ID}| awk '{print $4}'`
	if [ -n "$FLAVOR_NAME" ]; then
		echo Removing the flavor $FLAVOR_NAME
		nova flavor-delete ${FLAVOR_ID}
	fi


	echo done-delete!
	echo neutron net-list
	neutron net-list
	echo neutron port-list
	neutron port-list
	echo neutron router-list
	neutron router-list
	echo nova list

else 
	echo "Usage:"
	echo "   ./manage-my-stack.sh add"
	echo "   ./manage-my-stack.sh delete"
	echo
	echo "   Make sure you updated the environment parameters correctly before execution"

fi
