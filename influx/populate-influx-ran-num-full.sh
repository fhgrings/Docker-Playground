#!/usr/bin/env bash

now=$(date +%s%N)
date=${now}
#Minutos*segundos*mili*nano*micro
interval=4*60*1000*1000*1000
for i in $(seq 0 50)
do
  date=$((date - interval))
  if [ $1 ]
  then
    for measurement in potencia_sinal cpu_load_short memory_usage;
    do
      for tag in server01 server02;
      do
        #value=$(( ( RANDOM % 100 )  + 1 ))
	value=10
        echo $date $measurement $tag $value
        curl -i -XPOST 'http://localhost:8086/write?db=mydb' --data-binary "${measurement},host=${tag},region=us-west value=${value} ${date}"
      done
    done
  else 
    for tag in 10 20 30 40 50 60 70 80 90 11 21 31 41 51 61 71 81 91 91;
    do
#      value=$(( ( RANDOM % 100 )  + 1 ))
	value=10
      echo $date $measurement $tag $value
      curl -i -XPOST 'http://localhost:8086/write?db=mydb' --data-binary "matchio.data,node=${tag},manager=10,gateway=35 value=${value} ${date}"
    done
  fi
done
