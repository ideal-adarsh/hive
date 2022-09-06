#!/bin/bash





CONTAINER_ALREADY_STARTED="CONTAINER_ALREADY_STARTED_PLACEHOLDER"
if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
    touch $CONTAINER_ALREADY_STARTED
    cat >> $HIVE_BIN/conf/hive-site.xml <<EOF
<configuration>
  <property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:mysql://${MYSQL_IP}/${MYSQL_DATABASE}?createDatabaseIfNotExist=true</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>com.mysql.cj.jdbc.Driver</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionUserName</name>
    <value>${MYSQL_USER}</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionPassword</name>
    <value>${MYSQL_PASSWORD}</value>
  </property>
  <property>
    <name>hive.metastore.schema.verification</name>
    <value>false</value>
  </property>
</configuration>
EOF
    echo "file created"
    echo "-- First container startup --"
    $HIVE_BIN/bin/schematool -dbType mysql -initSchema && $HIVE_BIN/bin/hiveserver2 --service metastore --hiveconf hive.root.logger=DEBUG,console --hiveconf fs.azure.account.key.${AZURE_ACCOUNT_NAME}.blob.core.windows.net=${AZURE_KEY}
else
    echo "-- Not first container startup --"
    $HIVE_BIN/bin/hiveserver2 --service metastore --hiveconf hive.root.logger=DEBUG,console --hiveconf fs.azure.account.key.${AZURE_ACCOUNT_NAME}.blob.core.windows.net=${AZURE_KEY}
fi
#  $HIVE_BIN/bin/hiveserver2 --service metastore --hiveconf hive.root.logger=DEBUG,console --hiveconf fs.azure.account.key.${AZURE_ACCOUNT_NAME}.blob.core.windows.net=${AZURE_KEY}