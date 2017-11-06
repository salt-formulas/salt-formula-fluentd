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
docker:
  host:
    enabled: true
    experimental: true
    insecure_registries:
      - 127.0.0.1
    log:
      engine: json-file
      size: 50m
