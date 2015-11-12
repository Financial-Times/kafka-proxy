class kafka_proxy {

  $confluent = "confluent-1.0"
  $confluent_kafka_rest = "confluent-kafka-rest"
  $config_file = "/etc/kafka-rest/kafka-proxy.properties"
  $log_file = "/etc/kafka-rest/log4j.properties"
  $init_file = "/etc/init.d/kafka-proxy"

  class { 'common_pp_up': }
  class { "${module_name}::monitoring": }
  class { 'jdk': version => '1.8.0' }

  yumrepo {
    $confluent:
      baseurl  => "http://packages.confluent.io/rpm/1.0",
      gpgcheck => 1,
      gpgkey   => "http://packages.confluent.io/rpm/1.0/archive.key",
      enabled  => 1
  }

  package {
    $confluent_kafka_rest:
      ensure  => installed,
      require => [ Yumrepo[$confluent], Class['jdk'] ]
  }

  file {
    $init_file:
      content => template("$module_name/kafka-proxy"),
      mode    => "0755"
  }

  file {
    $config_file:
      content => template("$module_name/kafka-proxy.properties.erb"),
      mode    => "0664"
  }

  file {
    $log_file:
      content => template("$module_name/log4j.properties.erb"),
      mode    => "0664"
  }

  file { 
    'sysconfig':
      path    => "/etc/sysconfig/kafka-proxy",
      content => template("${module_name}/sysconfig.erb"),
      owner   => 'root',
      group   => 'root',
  }

  service {
    'kafka-proxy':
      ensure    => "running",
      enable    => true,
      subscribe => [ Package[$confluent_kafka_rest], File[$init_file], File[$config_file], File[$log_file], File['sysconfig'] ]
  }

  Exec['enforce_jdk_used'] ~> Service['kafka-proxy']

}
