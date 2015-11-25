# kafka-rest-proxy

Puppet module for deploying the kafka-rest-proxy (https://github.com/confluentinc/kafka-rest)

Read more about [here](http://docs.confluent.io/1.0/installation.html#installation-yum)


### Usage

This app is managed by [Supervisord](https://github.com/Supervisor/supervisor).

```
supervisorctl status kafka-proxy

supervisorctl start kafka-proxy

supervisorctl stop kafka-proxy

supervisorctl restart kafka-proxy

```

You can access the lightweight admin web interface on port :9001