type=official
#type=internal
cd /var/lib/jenkins/cloud/
rc=$?
if [ $rc -eq 0 ]; then
  git checkout 7.3.6
  rc=$?
  if [ $rc -eq 0 ]; then
    sed -i 's/rhel=.*/rhel=7.3/g' setup.cfg.local
    rc=$?
    if [ $rc -eq 0 ]; then
      sed -i 's/releasever=.*/releasever=rhosp7/g' setup.cfg.local
      rc=$?
      if [ $rc -eq 0 ]; then
        sed -i 's/minorver=.*/minorver=7.3.6/g' setup.cfg.local
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
                echo Run bash stop_vms.sh
                rc=$?
              fi
            fi
          fi
        fi
      fi
    fi
  fi
fi

echo "Reproduce $rc" >> /usr/src/kernels/linux-stable-new/state
echo "Reproduce $rc"

exit $rc

