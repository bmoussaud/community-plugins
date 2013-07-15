deployit_container { "Infrastructure/simple.host.not.created":
  type     => "overthere.SshHost",
  ensure   => present,
  properties   => { os => UNIX, address => "192.168.0.10", username  => tiger},
}


deployit { "remote":
  username => "admin",
  password => "admin",
  url => "http://localhost:4516",
}






