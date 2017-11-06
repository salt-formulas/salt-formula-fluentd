linux:
  system:
    enabled: true
    repo:
      td-agent:
        source: 'deb  http://packages.treasuredata.com.s3.amazonaws.com/2/ubuntu/{{ grains.get('oscodename') }} {{ grains.get('oscodename') }} contrib'
        key_url: 'http://packages.treasuredata.com.s3.amazonaws.com/GPG-KEY-td-agent'

