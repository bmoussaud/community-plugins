deployit { "remote":
  username => "admin",
  password => "admin",
  url => "http://localhost:4516",
}

deployit_environment { "Environments/host_env":
  ensure   => present,
  server   => Deployit["remote"],
}

deployit_container { "Infrastructure/container1":
  type     => "overthere.SshHost",
  ensure   => present,
  properties   => { os => UNIX, address => "127.0.0.1", username  => tiger},
  server   => Deployit["remote"],
  environments => ['Environments/host_env'],
  require => Deployit_environment['Environments/host_env']
}