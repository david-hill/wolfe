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

yum -y install vim jenkins python2-libvirt gcc redhat-rpm-config python2-devel tuned lm_sensors

pip list | grep virtualbmc
if [ $? -ne 0 ]; then
	pip install virtualbmc
fi

mkdir -p /root/.ssh
cp root/.ssh/* /root/.ssh/
chmod 600 /root/.ssh/authorized_keys


cp usr/lib/systemd/system/* /usr/lib/systemd/system
systemctl daemon-reload
systemctl reset-failed

enable_start tuned
enable_start vbmcd

tuned-adm profile virtual-host


#rsync --progress --inplace -a -v -e ssh  root@192.168.1.3:/var/lib/jenkins/ /var/lib/jenkins/ --exclude VMs --exclude *.tar --exclude *.iso --exclude *.qcow2
rsync --progress --inplace -a -v -e ssh  root@192.168.1.3:/var/lib/jenkins/ /var/lib/jenkins/ 

