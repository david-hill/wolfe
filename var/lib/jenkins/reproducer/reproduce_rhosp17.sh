type=official
type=internal
#type=monitoring
lockedrhelrelease=0
rhel=8.3
releasever=rhosp17
standalone=0
minorver=17.0
cd /var/lib/jenkins/cloud/
rc=$?
if [ $rc -eq 0 ]; then
  git checkout 17.0
  rc=$?
  if [ $rc -eq 0 ]; then
    sed -i "s/^rhel=.*/rhel=${rhel}/g" setup.cfg.local
    sed -i "s/lockedrhelrelease=.*/lockedrhelrelease=${rhelrelease}/g" setup.cfg.local
    rc=$?
    if [ $rc -eq 0 ]; then
#      sed -i "s/releasever=.*/releasever=rhosp-beta/g" setup.cfg.local
      sed -i "s/standalone=.*/standalone=$standalone/g" setup.cfg.local
      sed -i "s/releasever=.*/releasever=${releasever}/g" setup.cfg.local
      rc=$?
      if [ $rc -eq 0 ]; then
        sed -i "s/minorver=.*/minorver=${minorver}/g" setup.cfg.local
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
                echo
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

