class kafka_proxy {

  $confluent = "confluent-1.0"
  $confluent_kafka_rest = "confluent-kafka-rest"
  $start_script = "/usr/bin/kafka-rest-start-with-sysconfig.sh"
  $config_file = "/etc/kafka-rest/kafka-proxy.properties"
  $log_config = "/etc/kafka-rest/log4j.properties"
  $sysconfig = "sysconfig"

  $name = "kafka-proxy"

  class { 'common_pp_up': }
  class { "${module_name}::monitoring": }
  class { "${module_name}::supervisord": }
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
    $config_file:
      content => template("$module_name/kafka-proxy.properties.erb"),
      mode    => "0664"
  }

  file {
    $log_config:
      content => template("$module_name/log4j.properties.erb"),
      mode    => "0664"
  }

  file {
    $start_script:
      content => template("$module_name/kafka-rest-start-with-sysconfig")
  }

  file {
    $sysconfig:
      path    => "/etc/sysconfig/kafka-proxy",
      content => template("${module_name}/sysconfig.erb"),
      owner   => 'root',
      group   => 'root',
  }

  exec { 'restart_kafka-proxy':
    command     => "supervisorctl restart $name",
    path        => "/usr/bin:/usr/sbin:/bin",
    subscribe   => [
      Package[$confluent_kafka_rest],
      File[$config_file],
      File[$log_config],
      File[$start_script],
      File[$sysconfig],
      Class["${module_name}::supervisord"]
    ],
    before      => Class["${module_name}::monitoring"],
    refreshonly => true
  }

  Exec['enforce_jdk_used'] ~> Exec['restart_kafka-proxy']

}
