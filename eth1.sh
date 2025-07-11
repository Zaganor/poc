ip link add bond0 type bond
ip link set bond0 type bond miimon 100 mode balance-rr
ip link set eth1 down
ip link set eth1 master bond0
ip link set bond0 up
ip link add link bond0 name bond0.10 type vlan id 10
ip link set bond0.10 up
