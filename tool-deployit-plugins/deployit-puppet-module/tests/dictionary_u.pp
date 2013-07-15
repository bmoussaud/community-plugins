deployit { "remote":
  username => "admin",
  password => "admin",
  url => "http://localhost:4516",
}


deployit_container { "Infrastructure/host.dict":
  type     => "overthere.SshHost",
  ensure   => present,
  properties   => { os => UNIX, address => "192.168.0.10", username  => tiger},
  tags => ['front','back','admin'],
  server   => Deployit["remote"],
}

deployit_container { "Infrastructure/host_next.dict":
  type     => "overthere.SshHost",
  ensure   => present,
  properties   => { os => UNIX, address => "192.168.0.10", username  => tiger},
  tags => ['front','back','admin'],
  server   => Deployit["remote"],
}


deployit_dictionary { "Environments/dict1":
  server   => Deployit["remote"],
  entries => {"A" => "1","B" => "3"},
  restrict_to_containers => ['Infrastructure/host_next.dict'],
  require  => Deployit_container["Infrastructure/host_next.dict"],
}
