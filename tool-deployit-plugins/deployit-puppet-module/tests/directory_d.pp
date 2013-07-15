deployit { "remote":
  username => "admin",
  password => "admin",
  url => "http://localhost:4516",
}

deployit_directory { "Infrastructure/dir1":
  server   => Deployit["remote"],
  ensure   => absent,
}

deployit_directory { "Infrastructure/dir1/dir2":
  server   => Deployit["remote"],
  require  => Deployit_directory["Infrastructure/dir1"],
  ensure   => absent,
}




