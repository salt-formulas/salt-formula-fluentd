
# Fluentd

Many web/mobile applications generate huge amount of event logs (c,f. login, logout, purchase, follow, etc). Analyzing these event logs can be quite valuable for improving services. However, collecting these logs easily and reliably is a challenging task.

Fluentd solves the problem by having: easy installation, small footprint, plugins reliable buffering, log forwarding, etc.

### Sample pillar

    fluentd:
      server:
        enabled: true

## Read more

* http://fluentd.org/
* http://docs.fluentd.org/
* http://docs.fluentd.org/categories/recipes