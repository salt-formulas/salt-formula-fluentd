===============
Fluentd Formula
===============

Many web/mobile applications generate huge amount of event logs
(c,f. login, logout, purchase, follow, etc). Analyzing these event
logs can be quite valuable for improving services. However, collecting
these logs easily and reliably is a challenging task.

Fluentd solves the problem by having: easy installation, small footprint,
plugins reliable buffering, log forwarding, etc.

**NOTE: WORK IN PROGRES**
NOTE: DESIGN OF THIS FORMULA IS NOT YET STABLE AND MAY CHANGE
NOTE: FORMULA NOT COMPATIBLE WITH OLD VERSION

Sample Pillars
==============

General pillar structure
------------------------

.. code-block:: yaml

  fluentd:
    config:
      label:
        filename:
          input:
            input_name:
              params
          filter:
            filter_name:
              params
            filter_name2:
              params
          match:
            match_name:
              params
      input:
        filename:
          input_name:
            params
          input_name2:
            params
        filename2:
          input_name3:
            params
      filter:
        filename:
          filter_name:
            params
          filter_name2:
            params
        filename2:
          filter_name3:
            params
      match:
        filename:
          match_name:
            params

Example pillar
--------------
.. code-block:: yaml

  fluentd:
    enabled: true
    config:
      label:
        monitoring:
          filter:
            parse_log:
              tag: 'docker.monitoring.{alertmanager,remote_storage_adapter,prometheus}.*'
              type: parser
              reserve_data: true
              key_name: log
              parser:
                type: regexp
                format: >-
                  /^time="(?<time>[^ ]*)" level=(?<severity>[a-zA-Z]*) msg="(?<message>.+?)"/
                time_format: '%FT%TZ'
            remove_log_key:
              tag: 'docker.monitoring.{alertmanager,remote_storage_adapter,prometheus}.*'
              type: record_transformer
              remove_keys: log
          match:
            docker_log:
              tag: 'docker.**'
              type: file
              path: /tmp/flow-docker.log
        grok_example:
          input:
            test_log:
              type: tail
              path: /var/log/test
              tag: test.test
              parser:
                type: grok
                custom_pattern_path: /etc/td-agent/config.d/global.grok
                rule:
                  - pattern: >-
                      %{KEYSTONEACCESS}
        syslog:
          filter:
            add_severity:
              tag: 'syslog.*'
              type: record_transformer
              enable_ruby: true
              record:
                - name: severity
                  value: 'record["pri"].to_i - (record["pri"].to_i / 8).floor * 8'
            severity_to_string:
              tag: 'syslog.*'
              type: record_transformer
              enable_ruby: true
              record:
                - name: severity
                  value: '{"debug"=>7,"info"=>6,"notice"=>5,"warning"=>4,"error"=>3,"critical"=>2,"alert"=>1,"emerg"=>0}.key(record["severity"])'
            severity_for_telegraf:
              tag: 'syslog.*.telegraf'
              type: parser
              reserve_data: true
              key_name: message
              parser:
                type: regexp
                format: >-
                  /^(?<time>[^ ]*) (?<severity>[A-Z])! (?<message>.*)/
                time_format: '%FT%TZ'
            severity_for_telegraf_string:
              tag: 'syslog.*.telegraf'
              type: record_transformer
              enable_ruby: true
              record:
                - name: severity
                  value: '{"debug"=>"D","info"=>"I","notice"=>"N","warning"=>"W","error"=>"E","critical"=>"C","alert"=>"A","emerg"=>"E"}.key(record["severity"])'
            prometheus_metric:
              tag: 'syslog.*.*'
              type: prometheus
              label:
                - name: ident
                  type: variable
                  value: ident
                - name: severity
                  type: variable
                  value: severity
              metric:
                - name: log_messages
                  type: counter
                  desc: The total number of log messages.
          match:
            rewrite_tag_key:
              tag: 'syslog.*'
              type: rewrite_tag_filter
              rule:
                - name: ident
                  regexp: '^(.*)'
                  result: '__TAG__.$1'
            syslog_log:
              tag: 'syslog.*.*'
              type: file
              path: /tmp/syslog
      input:
        syslog:
          syslog_log:
            type: tail
            label: syslog
            path: /var/log/syslog
            tag: syslog.syslog
            parser:
              type: regexp
              format: >-
                '/^\<(?<pri>[0-9]+)\>(?<time>[^ ]*) (?<host>[^ ]*) (?<ident>[a-zA-Z0-9_\/\.\-]*)(?:\[(?<pid>[0-9]+)\])?(?:[^\:]*\:)? *(?<message>.*)$/'
              time_format: '%FT%T.%L%:z'
          auth_log:
            type: tail
            label: syslog
            path: /var/log/auth.log
            tag: syslog.auth
            parser:
              type: regexp
              format: >-
                '/^\<(?<pri>[0-9]+)\>(?<time>[^ ]*) (?<host>[^ ]*) (?<ident>[a-zA-Z0-9_\/\.\-]*)(?:\[(?<pid>[0-9]+)\])?(?:[^\:]*\:)? *(?<message>.*)$/'
              time_format: '%FT%T.%L%:z'
        prometheus:
          prometheus:
            type: prometheus
          prometheus_monitor:
            type: prometheus_monitor
          prometheus_output_monitor:
            type: prometheus_output_monitor
        forward:
          forward_listen:
            type: forward
            port: 24224
            bind: 0.0.0.0
      match:
        docker_monitoring:
          docker_monitoring:
            tag: 'docker.monitoring.{alertmanager,remote_storage_adapter,prometheus}.*'
            type: relabel
            label: monitoring

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-nova/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-nova

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
