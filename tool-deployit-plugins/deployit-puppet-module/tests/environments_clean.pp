deployit { "remote":
  username => "admin",
  password => "admin",
  url => "http://localhost:4516",
}

deployit_container { "Infrastructure/simple.host.1":
  type     => "overthere.SshHost",
  ensure   => absent,
  properties   => { os => UNIX, address => $ipaddress, username  => tiger },
  server   => Deployit["remote"],
}

deployit_container { "Infrastructure/simple.host.2":
  type     => "overthere.SshHost",
  ensure   => absent,
  properties   => { os => UNIX, address => $ipaddress, username  => tiger},
  server   => Deployit["remote"],
}

