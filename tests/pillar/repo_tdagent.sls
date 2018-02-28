linux:
  system:
    enabled: true
    repo:
      td-agent:
        source: 'deb  http://mirror.mirantis.com/testing/td-agent-{{ grains.get('oscodename') }} {{ grains.get('oscodename') }} contrib'
        key_url: 'http://packages.treasuredata.com.s3.amazonaws.com/GPG-KEY-td-agent'
      openstack-pike:
        source: 'deb [arch=amd64] http://apt.mirantis.com/{{ grains.get('oscodename') }}/openstack/pike/ testing main'
        key_url: 'http://apt.mirantis.com/public.gpg'
