class kafka_proxy::monitoring {
  nagios::nrpe_checks::check_tcp {
    "${::certname}/1":
      host          => "localhost",
      port          => 8080,
      notes         => "check ${::certname} [$hostname] listening on api HTTP port 8080 ";
  }
}
