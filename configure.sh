function disable_stop {
  s=$1
  systemctl status $s | grep -q enabled
  if [ $? -eq 0 ]; then
    systemctl disable $s
  fi
  systemctl status $s | grep -q running
  if [ $? -ne 0 ]; then
    systemctl stop $s
  fi
}

function enable_start {
  s=$1
  systemctl status $s | grep -q enabled
  if [ $? -ne 0 ]; then
    systemctl enable $s
  fi
  systemctl status $s | grep -q running
  if [ $? -ne 0 ]; then
    systemctl start $s
  fi
}

yum -y install vim jenkins python2-libvirt gcc redhat-rpm-config python2-devel tuned lm_sensors ntp libvirt docker ncurses-compat-libs net-snmp-utils net-snmp numactl ntpdate uptimed tmux screen dbus-tools terminator

pip list | grep virtualbmc
if [ $? -ne 0 ]; then
	pip install virtualbmc
fi

mkdir -p /root/.ssh
cp root/.ssh/* /root/.ssh/
chmod 600 /root/.ssh/authorized_keys

cp etc/pki/tls/certs/* /etc/pki/tls/certs/
cp etc/NetworkManager/system-connections/* /etc/NetworkManager/system-connections
chmod 600 /etc/NetworkManager/system-connections/*
nmcli c reload

cp usr/local/bin/*  /usr/local/bin/
cp usr/lib/systemd/system/* /usr/lib/systemd/system
systemctl daemon-reload
systemctl reset-failed

cp etc/snmp/* /etc/snmp
cp etc/ntp.conf /etc
mkdir /etc/virtualbmc
cp etc/virtualbmc/* /etc/virtualbmc/


ntpdate 192.168.1.3

enable_start snmpd
enable_start sshd
enable_start ntpd
enable_start tuned
enable_start uptimed
enable_start vbmcd

tuned-adm profile virtual-host

cp etc/sudoers.d /etc/sudoers.d
mkdir -p /var/lib/jenkins/reproducer
cp var/lib/jenkins/reproducer/* /var/lib/jenkins/reproducer/

cp etc/firewalld/firewalld.conf /etc/firewalld
systemctl restart firewalld
firewall-cmd --reload

wget http://techedemic.com/wp-content/uploads/2015/10/8-07-14_MegaCLI.zip
wget http://www.avagotech.com/docs-and-downloads/raid-controllers/raid-controllers-common-files/8-07-14_MegaCLI.zip

firewall-cmd --zone=internal --add-service snmp --permanent
firewall-cmd --zone=FedoraWorkstation --add-service snmp --permanent
firewall-cmd --reload

#rsync --progress --inplace -a -v -e ssh  root@192.168.1.3:/var/lib/jenkins/ /var/lib/jenkins/ --exclude VMs --exclude *.tar --exclude *.iso --exclude *.qcow2

if [ -e /root/.ssh/id_rsa ]; then
  rsync --progress --sparse -a -v -e ssh  root@192.168.1.3:/var/lib/jenkins/ /var/lib/jenkins/ 
fi

