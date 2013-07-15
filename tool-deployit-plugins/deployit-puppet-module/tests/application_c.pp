deployit { "remote":
  username => "admin",
  password => "admin",
  url => "http://localhost:4516",
}

deployit_version { "Applications/demo-app/1.0":
  ensure   => present,
  server   => Deployit["remote"],
  path     => "tests/dar/demo-app-1.0.dar"

}