FROM centos:7
WORKDIR /opt

COPY . .

RUN yum install httpd-devel kernel-devel kernel-headers gcc java-11-openjdk make -y \
    && tar xvzf tomcat-connectors-1.2.48-src.tar.gz \
    && cd tomcat-connectors-1.2.48-src/native/ \
    && LDFLAGS=-lc ./configure -with-apxs=/bin/apxs \
    && make \ 
    && cp ./apache-2.0/mod_jk.so /etc/httpd/modules \
    && cd ../../ \
    && cp workers.properties /etc/httpd/conf \
    && cp modjk.conf /etc/httpd/conf.d

CMD apachectl -k start && tail -f /etc/httpd/logs/access_log

EXPOSE 80

