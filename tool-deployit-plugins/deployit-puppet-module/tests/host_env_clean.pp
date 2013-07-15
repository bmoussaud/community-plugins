deployit { "remote":
  username => "admin",
  password => "admin",
  url => "http://localhost:4516",
}

deployit_environment { "Environments/host_env":
  ensure   => absent,
  server   => Deployit["remote"],
}


deployit_container { "Infrastructure/container2":
  type     => "overthere.SshHost",
  ensure   => absent,
  properties   => { os => UNIX, address => "127.0.0.1", username  => tiger},
  server   => Deployit["remote"],
  require => Deployit_environment['Environments/host_env']
}

deployit_container { "Infrastructure/container1":
  type     => "overthere.SshHost",
  ensure   => absent,
  properties   => { os => UNIX, address => "127.0.0.1", username  => tiger},
  server   => Deployit["remote"],
  require => Deployit_environment['Environments/host_env']
}
