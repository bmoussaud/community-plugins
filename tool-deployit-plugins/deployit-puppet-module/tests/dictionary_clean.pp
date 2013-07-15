deployit { "remote":
  username => "admin",
  password => "admin",
  url => "http://localhost:4516",
}


deployit_container { "Infrastructure/host.dict":
  type     => "overthere.SshHost",
  ensure   => absent,
  properties   => { os => UNIX, address => "192.168.0.10", username  => tiger},
  tags => ['front','back','admin'],
  server   => Deployit["remote"],
}

deployit_container { "Infrastructure/host_next.dict":
  type     => "overthere.SshHost",
  ensure   => absent,
  properties   => { os => UNIX, address => "192.168.0.10", username  => tiger},
  tags => ['front','back','admin'],
  server   => Deployit["remote"],
}
