#!/bin/bash
### Please edit grafana_* variables to match your Grafana setup:

grafana_host="http://localhost:3000"
grafana_cred="admin:admin"
datasource_name="Main"
type="influxdb"
user="admin"
password="admin"
database="mydb"

curl -s -k -u "$grafana_cred" -XPOST -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -d "{ \"name\":\"${datasource_name}\", \
          \"type\":\"${type}\", \
          \"url\":\"http://172.17.0.1:8086\", \
          \"access\":\"proxy\", \"database\": \"mydb\", \
          \"user\": \"${admin}\", \
          \"password\": \"${admin}\", \
          \"isDefault\": true, \
          \"basicAuth\":false \
        }" \
    $grafana_host/api/datasources; echo ""
