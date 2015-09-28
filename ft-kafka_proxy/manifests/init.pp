class kafka_proxy {

  $confluent = "confluent-1.0"
  $kafka_rest = "confluent-kafka-rest"
  $config_file = "/etc/kafka-proxy.properties"

  class { 'common_pp_up': }
  class { "${module_name}::monitoring": }

  yumrepo {
    $confluent:
      baseurl  => "http://packages.confluent.io/rpm/1.0",
      gpgcheck => 1,
      gpgkey   => "http://packages.confluent.io/rpm/1.0/archive.key",
      enabled  => 1
  }

  package {
    $kafka_rest:
      ensure          => installed,   
      require         => Yumrepo[$confluent]
  }

  file {
    $config_file:
      content => template("$module_name/kafka-proxy.properties.erb"),
      mode    => "0664"
  }

  exec {
    'stop-kafka-rest-proxy':
      command		=> "/usr/bin/kafka-rest-stop || true",
      subscribe		=> [ Package[$kafka_rest], File[$config_file] ],
      refreshonly	=> true
  }

  exec {
    'start-kafka-rest-proxy':
      command		=> "/usr/bin/kafka-rest-start",
      subscribe 	=> Exec['stop-kafka-rest-proxy'],
      refreshonly	=> true
  }
}
