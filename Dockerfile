FROM cgswong/confluent-rest-proxy

ADD ft-kafka_proxy/templates/log4j.properties.erb /etc/kafka-rest/log4j.properties

CMD [ "/usr/local/bin/rest-proxy-docker.sh" ]
