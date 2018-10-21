from centos:latest

RUN yum update -y
RUN yum install vim wget dnsutils -y

WORKDIR /app

#java 
COPY files/jdk-8u191-linux-x64.rpm /app/
RUN yum install /app/jdk-8u191-linux-x64.rpm -y
ENV JAVA_HOME /usr/java/latest

#Zookeeper
RUN wget http://www-eu.apache.org/dist/zookeeper/zookeeper-3.4.13/zookeeper-3.4.13.tar.gz
RUN tar -zxvf zookeeper-3.4.13.tar.gz -C /app
RUN mv /app/zookeeper-3.4.13/ /app/zookeeper
COPY files/zoo.cfg /app/zookeeper/conf/
COPY files/log4j.properties /app/zookeeper/conf/
RUN mkdir /app/zookeeper/logs

#Kafka
RUN wget http://www-eu.apache.org/dist/kafka/2.0.0/kafka_2.12-2.0.0.tgz
RUN tar -zxvf kafka_2.12-2.0.0.tgz -C /app/
RUN mv /app/kafka_2.12-2.0.0/ /app/kafka
ENV JMX_PORT=${JMX_PORT:-9999}
ENV KAFKA_HEAP_OPTS="-Xmx256M -Xms128M"
COPY files/kafka-run-class.sh /app/kafka/bin/


EXPOSE 2181 9092

COPY files/start.sh /app/start.sh
RUN chmod 777 /app/start.sh
CMD /app/start.sh
