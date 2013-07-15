deployit_container { "Infrastructure/simple.host":
  type     => "overthere.SshHost",
  ensure   => absent,
  properties   => { os => UNIX, address => $ipaddress, username  => tiger, password => woods},
  server   => Deployit["remote"],
}

deployit_container { "Infrastructure/simple.host.with.tags":
  type     => "overthere.SshHost",
  ensure   => absent,
  properties   => { os => UNIX, address => $ipaddress, username  => tiger, password => woods},
  require  => Deployit_container["Infrastructure/simple.host"],
  tags => ['front','back','admin'],
  server   => Deployit["remote"],
}

deployit { "remote3-notused":
  username => "AdMin",
  password => "aDmin",
  url => "http://42.168.34.181:4516",
}

deployit { "notused":
  username => "Admin",
  password => "aDmin",
  url => "http://92.168.34.181:4516",
}

deployit { "remote":
  username => "admin",
  password => "admin",
  url => "http://localhost:4516",
}




