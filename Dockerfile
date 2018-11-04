FROM tomcat:8-alpine
RUN  sed -i 's#dl-cdn.alpinelinux.org#mirrors.ustc.edu.cn#g'  /etc/apk/repositories && \
 apk  --no-cache  add mysql-client  \
 tzdata curl  && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone
RUN mkdir /data && chmod 777 /data/ -R && mkdir -p /data/appdatas/cat/ && mkdir /app
RUN rm -rf $( find /usr/local/tomcat/webapps/ ! -name "manager" -a -maxdepth 1 -a -mindepth 1 )
RUN cd /tmp/ && wget http://unidal.org/nexus/service/local/repositories/releases/content/com/dianping/cat/cat-home/3.0.0/cat-home-3.0.0.war  && \
mkdir -p /usr/local/tomcat/webapps/cat &&  cd  /usr/local/tomcat/webapps/cat && \
unzip /tmp/cat*.war && rm -rf /tmp/*

#support mysql 8
#RUN cd  /usr/local/tomcat/webapps/cat/WEB-INF/lib && rm -f mysql*.jar && \
#wget http://central.maven.org/maven2/mysql/mysql-connector-java/8.0.13/mysql-connector-java-8.0.13.jar

RUN apk --no-cache add libc6-compat  
ADD script/ /
RUN chmod +x /app/*.sh && mkdir -p /data/applogs/cat && \
cd  /usr/local/tomcat/conf && \
sed -i 's#<Connector port=#<Connector URIEncoding="UTF-8" maxHttpHeaderSize="65536"  minSpareThreads="16" enableLookups="false" acceptCount="500" maxThreads="400" port=#g' ./server.xml && \
sed -i 's#port="8080" protocol="[^"]*"#port="8080" protocol="org.apache.coyote.http11.Http11AprProtocol"#g' ./server.xml

ENTRYPOINT /app/entrypoint.sh