type=official
#type=internal
cd /var/lib/jenkins/cloud/
rc=$?
if [ $rc -eq 0 ]; then
  git checkout 15.0
  rc=$?
  if [ $rc -eq 0 ]; then
    sed -i 's/rhel=.*/rhel=8.0/g' setup.cfg.local
    rc=$?
    if [ $rc -eq 0 ]; then
      sed -i 's/releasever=.*/releasever=rhosp15/g' setup.cfg.local
      rc=$?
      if [ $rc -eq 0 ]; then
        sed -i 's/minorver=.*/minorver=15.0/g' setup.cfg.local
        rc=$?
        if [ $rc -eq 0 ]; then
          bash delete_virsh_vms.sh
          rc=$?
          if [ $rc -eq 0 ]; then
            bash delete_undercloud.sh
            rc=$?
            if [ $rc -eq 0 ]; then
              bash create_undercloud.sh $type
              rc=$?
              if [ $rc -eq 0 ]; then
                bash stop_vms.sh
                rc=$?
              fi
            fi
          fi
        fi
      fi
    fi
  fi
fi

echo "Reproduce $rc" >> /var/lib/jenkins/reproducer/state
echo "Reproduce $rc"

exit $rc

