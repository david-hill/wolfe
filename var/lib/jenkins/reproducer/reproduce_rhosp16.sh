#type=official
type=internal
#type=monitoring
#type=dvr
standalone=0
minorver=16.1
rhelrelease=8.2
lockedrhelrelease=8.2
# 16.0 = 8.1 , 16.1 = 8.2, 16.2 = 8.3
cd /var/lib/jenkins/cloud/
rc=$?
if [ $rc -eq 0 ]; then
  git checkout $minorver
  rc=$?
  if [ $rc -eq 0 ]; then
    sed -i "s/^rhel=.*/rhel=${rhelrelease}/g" setup.cfg.local
    rc=$?
    sed -i "s/lockedrhelrelease=.*/lockedrhelrelease=${lockedrhelrelease}/g" setup.cfg.local
    rc=$?
    if [ $rc -eq 0 ]; then
#      sed -i "s/releasever=.*/releasever=rhosp-beta/g" setup.cfg.local
      sed -i "s/releasever=.*/releasever=rhosp16/g" setup.cfg.local
      sed -i "s/standalone=.*/standalone=$standalone/g" setup.cfg.local
      rc=$?
      if [ $rc -eq 0 ]; then
        sed -i "s/minorver=.*/minorver=$minorver/g" setup.cfg.local
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

