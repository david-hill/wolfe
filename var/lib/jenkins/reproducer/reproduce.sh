cd /var/lib/jenkins/cloud
git checkout 9.0 > /dev/null
echo $?
git pull > /dev/null
echo $?
sed -i 's/rhel=.*/rhel=7.3/g' setup.cfg.local
sed -i 's/releasever=.*/releasever=rhosp9/g' setup.cfg.local
sed -i 's/minorver=.*/minorver=9.0/g' setup.cfg.local
sed -i 's/minorver=.*/minorver=9.0/g' setup.cfg.local
bash delete_virsh_vms.sh rdo pike
rc=$?
if [ $rc -eq 0 ]; then
  bash delete_undercloud.sh rdo pike
  rc=$?
  if [ $rc -eq 0 ]; then
    bash create_undercloud.sh rdo pike
    rc=$?
    if [ $rc -eq 0 ]; then
      bash stop_vms.sh
      rc=$?
    fi
  fi
fi

echo "Reproduce $rc" >> /usr/src/kernels/linux-stable-new/state
echo "Reproduce $rc"

exit $rc

