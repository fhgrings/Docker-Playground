FROM centos:7

WORKDIR /opt

COPY . .

RUN yum clean all && yum clean metadata \
    && yum install -y java-1.8.0-openjdk \
    && java -jar jboss-eap-7.0.0-installer.jar auto.xml -variablefile auto.xml.variables \
    && mv domain.xml /root/EAP-7.0.0/domain/configuration \
    && cp -r com/ /root/EAP-7.0.0/modules/system/layers/base

CMD [ "/bin/bash" , "/opt/domain.sh" ]

EXPOSE 8080
EXPOSE 8009

EXPOSE 8230
EXPOSE 8159

EXPOSE 9990
EXPOSE 9090

