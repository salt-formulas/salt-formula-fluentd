{% from "fluentd/map.jinja" import server with context %}

fluentd_packages:
  pkg.installed:
  - names: 
    - curl
    - libcurl-devel

fluentd_install:
  cmd.run:
  - names:
    - curl -L http://toolbelt.treasuredata.com/sh/install-redhat.sh | sh
    - touch /root/fluentd_installed
  - cwd: /root
  - unless: "[ -f /root/fluentd_installed ]"
  require:
  - pkg: fluentd_packages

{%- for plugin in server.get("plugins", []) %}
fluentd_install_plugin:
  cmd.run:
  - names:
    -  /usr/lib64/fluent/ruby/bin/fluent-gem install plugin {{ plugin }}
    -  touch /root/{{ plugin }}_installed
  - cwd: /root
  - unless: "[ -f /root/{{ plugin }}_installed ]"
  require:
  - pkg: fluentd_packages
{% endfor %}

{{ server.config }}:
  file.managed:
  - source: salt://fluentd/conf/td-agent.conf
  - template: jinja
  - require:
    - cmd: fluentd_install

fluentd_service:
  service.running:
  - name: {{ server.service }}
  - enable: True
  - watch:
    - file: {{ server.config }}

{#
fluentd_repo:
  pkgrepo.managed:
    - human_name: TreasureData
    - comments: 
      - '#http://packages.treasure-data.com/debian/RPM-GPG-KEY-td-agent'
    - name: TreasureData
    - baseurl: http://packages.treasure-data.com/redhat/\$basearch
    - file: /etc/apt/sources.list.d/fluentd.list
    - key_url: salt://fluentd/conf/treasure-data.gpg
    - gpgcheck: 1


    - deb http://packages.treasure-data.com/{{ grains.oscodename }}/ {{ grains.oscodename }} contrib
#}