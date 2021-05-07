#!/usr/bin/env bash
# date=1613859709965000000

# Padrão de POST
# name - measurement
# tag: 
#   appname
#   host
#   severity
# values:
#   message
#   timestamp

echo "Iniciando"
now=$(date +%s%N)
date=${now}
#Minutos*segundos*mili*nano*micro
interval=4*60*1000*1000*1000

# Variaveis
severityList=("err" "warning" "info" "debug")
appname="CRUD1"
host="Cloud-host"
URL='http://172.17.0.1:8086/write?db=mydb'

for i in $(seq 0 50)
do
  timestamp=$((date - interval))
  for measurement in logs;
  do
    for tag in 1 2;
    do
      severity=${severityList[$(( RANDOM % 4 ))]}
      message="${severity}: Teste de logs por script"
      echo $date $measurement $appname $severity
      # curl -i -XPOST  URL --data-binary  Database {Measurement},{tags,} {values,} {time}
      curl -i -XPOST  ${URL} --data-binary "${measurement},appname=${appname},host=${host},severity=\"${severity}\" message=\"${message}\",timestamp=${timestamp} ${date}"
    done
  done
done


