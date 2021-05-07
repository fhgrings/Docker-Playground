# vim: set background=dark:
# vim: set number:

#
# Wiki suporte unisys
#

serviceName="mediawiki-prod"


if [ -z "$(docker service ls | grep ${serviceName})" ]; then

   echo "criando servico ${serviceName}"

   echo "** baixar a imagem "
   docker pull mediawiki

   ## restor volume
   echo "** Verificando se existe o volume wiki-java-suporte no silpro1198"  
   echo "** execute manualmente: docker volume create wiki-java-suporte "
   echo "** execute manualmente: recover backup do volume "

# essa imagem nao tem suporte ao curl
#   --health-cmd="curl -s -o /dev/null -I -w '%{http_code}' localhost:5001 | grep 200 || exit 1" \
#   --health-interval=10s --health-retries=3 --health-timeout=2s	\


#   --mount source=mediawiki,destination=/var/www/data   \
#   --mount source=mediawiki,destination=/var/www/html/images   \

   ## criar serviço
   docker service create --name ${serviceName} --replicas=1 --limit-cpu=1 --limit-memory=150mb -p 10980:80  \
   --mount source=mediawiki,destination=/var/www/data   \
   --mount source=mediawiki,destination=/var/www/html/images   \
   --mount type=bind,source=/opt/docker-services-config/LocalSettings.php,destination=/var/www/html/LocalSettings.php   \
   --constraint node.hostname==silpro1192  \
   mediawiki:latest

   echo "sleep 10"
   sleep 10
   #

fi

##
echo "verificando o servico ${serviceName}"
echo "$(docker node ps $(docker node ls -q) -f name=${serviceName} --filter desired-state=Running)"
