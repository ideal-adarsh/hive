FROM amd64/centos:7

LABEL MAINTAINER="yellow" 

RUN yum update -y \
    && yum install -y curl wget vim less uuid python3 python3-pip ca-certificates python3-devel util-linux \
    && pip3 install --upgrade pip 

RUN yum install -y https://cdn.azul.com/zulu/bin/zulu-repo-1.0.0-1.noarch.rpm
RUN yum install -y zulu11-jdk
RUN wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.rpm
RUN rpm -ivh jdk-17_linux-x64_bin.rpm
ENV JAVA_HOME=/usr/lib/jvm/zulu11
WORKDIR /opt
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz
RUN tar -xzvf hadoop-3.3.4.tar.gz && mv hadoop-3.3.4 hadoop
ENV HADOOP_HOME=/opt/hadoop
RUN wget https://dlcdn.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz
RUN tar -xzvf apache-hive-3.1.3-bin.tar.gz && mv apache-hive-3.1.3-bin apache-hive-bin
ENV HIVE_BIN=/opt/apache-hive-bin
RUN rm $HIVE_BIN/lib/guava-19.0.jar && cp $HADOOP_HOME/share/hadoop/hdfs/lib/guava-27.0-jre.jar $HIVE_BIN/lib
RUN cd $HIVE_BIN/lib && \
    wget https://repo1.maven.org/maven2/com/microsoft/azure/azure-storage/8.6.6/azure-storage-8.6.6.jar && \
    wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/3.3.4/hadoop-azure-3.3.4.jar && \
    wget https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-web/2.8.2/log4j-web-2.8.2.jar  &&\
    wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.30/mysql-connector-java-8.0.30.jar
RUN rm hadoop-3.3.4.tar.gz && rm apache-hive-3.1.3-bin.tar.gz
COPY ./had /opt/hadoop
COPY ./hi /opt/apache-hive-bin
EXPOSE 9083
COPY ./init_script.sh .
ENV AZURE_ACCOUNT_NAME=
ENV AZURE_KEY=
ENV MYSQL_IP=
ENV MYSQL_USER=
ENV MYSQL_PASSWORD=
ENV MYSQL_DATABASE=
ENTRYPOINT sh ./init_script.sh