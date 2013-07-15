deployit { "remote":
  username => "admin",
  password => "admin",
  url => "http://localhost:4516",
}

deployit_directory { "Infrastructure/dir-permission":
  server   => Deployit["remote"],
  ensure   => absent,
}

deployit_role{ "role1":
  server   => Deployit["remote"],
  ensure   => absent,
}








