class kafka_proxy {

  $confluent = "confluent-1.0"
  $config_file = "/etc/kafka-proxy.properties"

  class { 'common_pp_up': }
  class { "${module_name}::monitoring": }

  yumrepo {
    $confluent:
      name     => "Confluent repository for 1.x packages",
      baseurl  => "http://packages.confluent.io/rpm/1.0",
      gpgcheck => 1,
      gpgkey   => "http://packages.confluent.io/rpm/1.0/archive.key",
      enabled  => 1
  }

  package {
    "confluent-kafka-rest-2.11.5":
      ensure          => installed,   
      require         => Yumrepo[$confluent]
  }

  file {
    $config_file:
      content => template("$module_name/kafka-proxy.properties.erb"),
      mode    => "0664";
  }
}
