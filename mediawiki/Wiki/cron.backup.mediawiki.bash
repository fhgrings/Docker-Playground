#!/bin/bash

# https://docs.docker.com/storage/volumes/#backup-restore-or-migrate-data-volumes

# opcao 
#   = backup
#   = restore
#

# nome do volume que sera salvo
containerVolumeName="mediawiki"

# nome do arquivo onde sera salvo o volume
backupOutput="mediawiki-storage-$(date +"%y-%m-%d-%Hh%Mm").tar"
backupRestoreInput="mediawiki-storage-20-09-21-10h11m.tar"

echo $backupOutput

echo -n "Executar backup ou restore? [backup]: "
read -t 10 opcao
case "$opcao" in
    backup|"")
       echo "iniciando backup de ${nomeVolume} para o arquivo ${backupOutput} "
       # sobe container temporario com imabem do busybox (precisamos do targz )
       # monta o ${nomeVolume} dentro do container
       # monta um diretorio do host dentro do container em /backup
       # move o conteudo do volume para o arquivo .tar
       docker run --privileged --rm -v ${containerVolumeName}:/volume/data:rw \
          -v /opt/docker-volume-backup:/backup   \
          busybox tar cvf /backup/${backupOutput} /volume/data
    ;;
    restore)
        # cria o volume, se nao existir
        docker volume create ${containerVolumeName}

        # sobe container temporario que descompacta o arquivo do disco 
        # dentro do volume 
        docker run --privileged --rm -v ${containerVolumeName}:/volume/data:rw \
          -v /opt/docker-volume-backup:/backup \
          busybox tar xvf /backup/${backupRestoreInput}

    ;;
    *)
        echo "Opção inválida"
    ;;
esac


# conferir resultado do restore
# docker run --privileged --rm -v ${nomeVolume}:/volume/data busybox ls -l /volume/data

