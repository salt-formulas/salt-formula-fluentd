include:
{%- if pillar.fluentd.get("server", {'enabled':False}).enabled %}
- fluentd.server
{%- endif %}