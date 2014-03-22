ovs-vsctl -- --id=@s create sFlow agent=eth0 target=\"192.168.105.173:6343\" header=128 sampling=4 polling=2 -- set Bridge br-int sflow=@s
