## How to Run 

  sudo docker-compose build
  sudo docker-compose up


Install e config JBoss EAP

https://www.youtube.com/watch?v=MTzSiM-Z-QA

Na maquina domain:

java -jar jboss-eap-7.x......

./EAP-7.x/bin/add-user.sh

Adicionar usuário no managementRealm Guardar o token "secure" para usar mais tarde.

Rodar o domain:

./EAP-7.0.0/bin/domain.sh -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=0.0.0.0 > domain.log & tail -f domain.log

Na maquina Slave: java -jar jboss-eap-7.x......

nano /EAP-7.x/domain/configuration/host-slave.xml Adicionar um nome em

<host xmlns="urn:jboss:domain:4.1" name="node1">
  <extensions>
    <extension module="org.jboss.as.jmx"/>
  </extensions>

Adicionar o secure recebido anterioremente no add-user

  <security-realm name="ManagementRealm">
    <server-identities>
     --------- <secret value="amJvc3NhZG1pbg==" />   --------
    </server-identities>
    <authentication>
      <local default-user="$local" skip-group-loading="true"/>
      <properties path="mgmt-users.properties" relative-to="jboss.domain.config.dir"/>
    </authentication>
    <authorization map-groups-to-roles="false">
      <properties path="mgmt-groups.properties" relative-to="jboss.domain.config.dir"/>
    </authorization>
  </security-realm>

Adicionar o username criado anteriormente em:

<domain-controller>
    <remote security-realm="ManagementRealm" !!!!!!!username="jbossadmin"!!!!!!!!!>
        <discovery-options>
            <static-discovery name="primary" protocol="${jboss.domain.master.protocol:remote}" host$
        </discovery-options>
    </remote>
</domain-controller>

Rodar com o comando:

 ./EAP-7.0.0/bin/domain.sh --host-config=host-slave.xml \
 -Djboss.domain.master.address=IP_DOMAIN -Djboss.bind.address.management=0.0.0.0 \
 -Djboss.bind.address=0.0.0.0 > slave.log & tail -f slave.log

Configuração mod_jk

https://4fasters.com.br/posts/jboss/

Desativar Setenforce para evitar maiores problemas

sudo setenforce 0

Instalar os pacotes necessários

$ sudo yum install httpd-devel kernel-devel kernel-headers gcc java-11-openjdk -y

Baixar e configurar modulo Tomcat (mod_jk)

https://tomcat.apache.org/download-connectors.cgi

$ tar xvzf tomcat-connectors-1.2.48-src.tar.gz
$ cd tomcat-connectors-1.2.48-src/native/
$ LDFLAGS=-lc ./configure -with-apxs=/bin/apxs
$ make
$ sudo cp ./apache-2.0/mod_jk.so /etc/httpd/modules

So it is time to setup our load balancing.

I truly suggest you to go through this blog too. It shows exactly how to setup mod_jk with JBoss.

Inside /etc/httpd/conf, create a file called workers.properties with this content:

worker.list=loadbalancer,status

# Define Node1
# modify the host as your host IP or DNS name.

worker.node1.port=8259
worker.node1.host=172.31.125.224
worker.node1.type=ajp13
worker.node1.ping_mode=A
worker.node1.lbfactor=1

# Define Node2
# modify the host as your host IP or DNS name.
worker.node2.port=8459
worker.node2.host=172.31.125.224
worker.node2.type=ajp13
worker.node2.ping_mode=A
worker.node2.lbfactor=1

# Load-balancing behavior
worker.loadbalancer.type=lb
worker.loadbalancer.balance_workers=node1,node2
worker.loadbalancer.sticky_session=1

# Status worker for managing load balancer
worker.status.type=status

Pay attention on worker.node1.host that must be the IP address from the VM and the worker.node1.port that should be the AJP port from the servers with full-ha profile. You can find this information on the web interface.

Find the AJP port on Runtime -> Host -> Server -> Open Ports. Each server will have one (if using the full-ha profile)

Secondly, inside /etc/httpd/conf.d you have to create a modjk.conf with the following content:

LoadModule jk_module modules/mod_jk.so
JkWorkersFile conf/workers.properties
JkLogFile logs/mod_jk.log
JkLogLevel debug
JkMount /* loadbalancer
JkShmFile logs/jk.shm

Restart the Apache web server.

$ sudo systemctl restart httpd

It will pass any request to the load balancer and distribute on AJP ports.

You can try it out by opening http://ipaddress/SampleWebApp.

I hope you enjoyed this lab, please leave a comment below. :)
Configurações HTTPS

Adicionar Pacotes

sudo yum install mod_ssl openssl

Gerar chave RSA

openssl genrsa -out procergs.key 2048

Gerar CSR

openssl req -new -key procergs.key -out procergs.csr

Gerar Certificado

openssl x509 -req -days 365 -in procergs.csr -signkey procergs.key -out procergs.crt

Alterar as configuraçoes no arquivo /etc/httpd/conf.d/ssl.conf Encontrar os diretórios dos atuais certificados e CSR. Adicionar os novos diretórios dos certificado e CSR.
Adicionar HTTPS ao balanceador de carga.

Ao final da chave do arquivo ssl.conf Adicionar a seguinte linha

  JkMount /* loadbalancer

Acessar https:IP_Destino
Datasources JBoss

http://www.sgaemsolutions.com/2019/07/add-mysql-driver-and-creation-of.html

https://access.redhat.com/documentation/en-us/red_hat_jboss_enterprise_application_platform/7.0/html/configuration_guide/datasource_management
