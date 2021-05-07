#!/usr/bin/env bash


echo "Iniciando"
now=$(date +%s%N)
date=${now}
# date=1613859709965000000
#Minutos*segundos*mili*nano*micro
interval=4*60*1000*1000*1000
for i in $(seq 0 50)
do
  date=$((date - interval))
  if [ $1 ]
  then
    for measurement in xs;
    do
      for tag in 1 6;
      do
        value=$(( ( RANDOM % 100 )  + 1 ))
        echo $date $measurement $tag $value
        curl -i -XPOST 'http://198.58.114.115:8086/write?db=nb_iot' --data-binary "${measurement},id=${tag},prop=corrente value=${value} ${date}"
      done
    done
  fi
done
