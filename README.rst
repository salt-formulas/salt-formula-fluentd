
===============
Fluentd Formula
===============

Many web/mobile applications generate huge amount of event logs
(c,f. login, logout, purchase, follow, etc). Analyzing these event
logs can be quite valuable for improving services. However, collecting
these logs easily and reliably is a challenging task.

Fluentd solves the problem by having: easy installation, small footprint,
plugins reliable buffering, log forwarding, etc.

Sample Pillars
==============

.. code-block:: yaml

		fluentd:
		  server:
		    enabled: true
		    plugins:
		    - fluent-plugin-elasticsearch
		    - fluent-plugin-mongo
		    config:
		    - name: forward
		      type: input
		      bind:
		        port: 24224
		        host: 0.0.0.0
		    - name: elasticsearch
		      type: output
		      bind:
		        port: 9200
		        host: localhost
		    - name: mongodb
		      type: output
		      bind:
		      	port: localhost
		      	host: localhost

More Information
================

* http://fluentd.org/
* http://docs.fluentd.org/
* http://docs.fluentd.org/categories/recipes
