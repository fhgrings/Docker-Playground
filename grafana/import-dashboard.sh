#!/bin/bash
### Please edit grafana_* variables to match your Grafana setup:
grafana_host="http://172.17.0.1:3000"
grafana_cred="admin:admin"

dashboard=$(cat dashboard.json)

curl -s -k -u "$grafana_cred" \
    -XPOST -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -d "${dashboard}" \
    $grafana_host/api/dashboards/db; echo ""
