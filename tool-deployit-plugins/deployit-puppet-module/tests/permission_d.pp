deployit { "remote":
  username => "admin",
  password => "admin",
  url => "http://localhost:4516",
}


deployit_directory { "Infrastructure/dir-permission":
  server   => Deployit["remote"],
}

deployit_permission { "set read on directory dir-permission":
  id => "Infrastructure/dir-permission",
  role => "role1",
  permission => "read",
  server   => Deployit["remote"],
  ensure   => absent,
  require => Deployit_directory['Infrastructure/dir-permission'],
}





