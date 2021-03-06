type=official
#type=internal
lockedrhelrelease=0
cd /var/lib/jenkins/cloud/
rc=$?
if [ $rc -eq 0 ]; then
#  git checkout 13.0
  echo
  rc=$?
  if [ $rc -eq 0 ]; then
    sed -i 's/rhel=.*/rhel=7.9/g' setup.cfg.local
    rc=$?
    if [ $rc -eq 0 ]; then
      sed -i "s/lockedrhelrelease=.*/lockedrhelrelease=0/g" setup.cfg.local
      rc=$?
      sed -i 's/releasever=.*/releasever=rhosp13/g' setup.cfg.local
      rc=$?
      if [ $rc -eq 0 ]; then
        sed -i 's/minorver=.*/minorver=13.0/g' setup.cfg.local
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
#                bash stop_vms.sh
                echo Undercloud is up.
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

