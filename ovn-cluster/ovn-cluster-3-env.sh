
### set ovn northbound db systemd
cat << EOF > /lib/systemd/system/ovn-ovsdb-server-nb.service
[Unit]
Description=Open vSwitch database server for OVN Northbound database
After=network.target
PartOf=ovn-central.service
DefaultDependencies=no

[Service]
Type=simple
EnvironmentFile=-/etc/default/ovn-central
PIDFile=%t/ovn/ovnnb_db.pid
ExecStart=/usr/share/ovn/scripts/ovn-ctl --db-nb-addr=ovn-cluster-3 --db-nb-cluster-local-addr=ovn-cluster-3 --db-nb-cluster-remote-addr=ovn-cluster-1 run_nb_ovsdb
ExecStop=/usr/share/ovn/scripts/ovn-ctl stop_nb_ovsdb
Restart=on-failure
LimitNOFILE=65535
TimeoutStopSec=15

[Install]
Alias=ovn-nb-ovsdb.service
EOF

### set ovn southbound db systemd
cat << EOF > /lib/systemd/system/ovn-ovsdb-server-sb.service
[Unit]
Description=Open vSwitch database server for OVN Southbound database
After=network.target
PartOf=ovn-central.service
DefaultDependencies=no

[Service]
Type=simple
EnvironmentFile=-/etc/default/ovn-central
PIDFile=%t/run/ovn/ovnsb_db.pid
ExecStart=/usr/share/ovn/scripts/ovn-ctl --db-sb-addr=ovn-cluster-3 --db-sb-cluster-local-addr=ovn-cluster-3 --db-sb-cluster-remote-addr=ovn-cluster-1 run_sb_ovsdb
ExecStop=/usr/share/ovn/scripts/ovn-ctl stop_sb_ovsdb
Restart=on-failure
LimitNOFILE=65535
TimeoutStopSec=15

[Install]
Alias=ovn-sb-ovsdb.service
EOF

### set ovn northd systemd
cat << EOF > /lib/systemd/system/ovn-northd.service
[Unit]
Description=Open Virtual Network central control daemon
After=network.target ovn-nb-ovsdb.service ovn-sb-ovsdb.service
PartOf=ovn-central.service
DefaultDependencies=no

[Service]
Type=forking
EnvironmentFile=-/etc/default/ovn-central
PIDFile=%t/ovn/ovn-northd.pid
ExecStart=/usr/bin/ovn-northd --detach --pidfile \
--ovnnb-db=tcp:ovn-cluster-1:6641,tcp:ovn-cluster-2:6641,tcp:ovn-cluster-3:6641 \
--ovnsb-db=tcp:ovn-cluster-1:6642,tcp:ovn-cluster-2:6642,tcp:ovn-cluster-3:6642 \
--log-file=/var/log/ovn/ovn-northd.log
ExecStop=/usr/share/ovn/scripts/ovn-ctl stop_northd --no-monitor
Restart=on-failure
LimitNOFILE=65535
TimeoutStopSec=15
EOF

### ovn 프로세스 실행 옵션을 정의
#cat << EOF > /etc/default/ovn-central
#OVN_CTL_OPTS= \
#  --db-nb-addr=ovn-1 \
#  --db-sb-addr=ovn-1 \
#  --db-nb-cluster-local-addr=ovn-1 \
#  --db-sb-cluster-local-addr=ovn-1 \
#  --db-nb-create-insecure-remote=yes \
#  --db-sb-create-insecure-remote=yes \
#  --ovn-northd-nb-db=tcp:ovn-1:6641,tcp:ovn-2:6641,tcp:ovn-3:6641 \
#  --ovn-northd-sb-db=tcp:ovn-1:6642,tcp:ovn-2:6642,tcp:ovn-3:6642
#EOF

systemctl daemon-reload
systemctl restart ovn-central
