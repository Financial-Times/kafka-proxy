class kafka_proxy {

  $confluent = "confluent-1.0"
  $kafka_rest = "confluent-kafka-rest"
  $config_file = "/etc/kafka-rest/kafka-proxy.properties"
  $log_file = "/etc/kafka-rest/log4j.properties"

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
    $kafka_rest:
      ensure          => installed,   
      require         => Yumrepo[$confluent]
  }

  file {
    $config_file:
      content => template("$module_name/kafka-proxy.properties.erb"),
      mode    => "0664"
  }

  file {
    $log_file:
      content	=> template("$module_name/log4j.properties.erb"),
      mode	=> "0664"
  }

  exec {
    'restart-kafka-rest-proxy':
      command		=> "/usr/bin/kafka-rest-stop || true && nohup /usr/bin/kafka-rest-start $config_file &",
      subscribe		=> [ Package[$kafka_rest], File[$config_file], File[$log_file], Class['jdk'] ],
      refreshonly	=> true
  }

  Exec['enforce_jdk_used'] ~> Exec['restart-kafka-rest-proxy']

}
