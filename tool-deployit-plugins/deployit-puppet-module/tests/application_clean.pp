deployit { "remote":
  username => "admin",
  password => "admin",
  url => "http://localhost:4516",
}

deployit_directory { "Applications/demo-app":
  ensure   => absent,
  server   => Deployit["remote"],
}