#!/bin/bash
echo "Iniciando JBoss Domain.sh"
/root/EAP-7.0.0/bin/domain.sh -Djboss.bind.address=0.0.0.0 \
-Djboss.bind.address.management=0.0.0.0 > domain.log 2>> domain.log & tail -f domain.log
