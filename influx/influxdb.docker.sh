# vim: set background=dark:
# vim: set number:

#     I N F L U X D B 
#
#     InfluxDB is an open source time series database for recording metrics, events, and analytics.
#     novas versoes: https://hub.docker.com/_/influxdb
#
#     conectar no container e usar interface do influx:
#     docker exec -it <influx-container-id> bash
#      influx
#       show databases
#       use mydb
#        show measurements
#        show tag values from syslog with key  = appname
#       quit
#     CTRL+D
#

#set -e

SERVICE_NAME="influxdb"
VOLUME_NAME="influxdb"
DATABASE="mydb"
URL="172.17.0.1"
PORT=8086

if [ -z "$(docker service ls | grep ${serviceName})" ]; then
   echo "Criando o volume ${VOLUME_NAME}"

   docker volume create ${VOLUME_NAME}
   sleep 5

   echo "Criando service ${serviceName}"

   ## criar serviço 
   docker service create --name ${SERVICE_NAME} --replicas=1  --limit-cpu=2 --limit-memory=2048mb -p 8086:8086  \
   --mount type=volume,source=influxdb,destination=/var/lib/influxdb   \
   --env TZ=America/Argentina/Buenos_Aires  \
   --env INFLUXDB_DATA_QUERY_LOG_ENABLED=false  \
   --env INFLUXDB_DATA_MAX_VALUES_PER_TAG=0  \
   --env DOCKER_INFLUXDB_INIT_USERNAME=admin \
   --env DOCKER_INFLUXDB_INIT_PASSWORD=admin \
    influxdb:1.8.2

   #Sleep criação do banco
   for i in {1..5}; do echo -en "\rWaiting..$i - 5"; sleep 1; done
fi

## Cria banco de dados
echo "Criando banco de dados ${DATABASE}"
#curl -XPOST ${URL}:${PORT}/query --data-urlencode "q=CREATE DATABASE ${DATABASE} WITH DURATION 4d"
curl -XPOST ${URL}:${PORT}/query --data-urlencode "q=CREATE DATABASE ${DATABASE}"


#Sleep criação do banco
for i in {1..5}; do echo -en "\rWaiting..$i - 5"; sleep 1; done

## insert registro de teste
echo " " 
curl -i -XPOST ${URL}:${PORT}/write?db=${DATABASE} \
         --data-binary 'cpu_load_short,host=server01,region=us-west value=0.64 1434055562000000000'

echo "Qual o registro mais antigo no banco mydb ?"
curl -XPOST ${URL}:${PORT}/query  --data-urlencode db=${DATABASE} \
         --data-urlencode "q=SELECT min("timestamp") FROM "syslog""

# FIEMX: create user root with root ( nao eh necessario ainda para o syslogng)
#        grant all privileges to root

##
 echo " "
 echo "Verificando serviço..."
 echo "$(docker node ps $(docker node ls -q) -f name=${serviceName} --filter desired-state=Running)"

##
