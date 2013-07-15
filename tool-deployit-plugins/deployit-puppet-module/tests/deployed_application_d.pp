deployit { "remote":
  username => "admin",
  password => "admin",
  url => "http://localhost:4516",
}

deployed_application { "Puppet application is deployed on dev environment":
  version => "Applications/demo-app/2.0",
  environment => "Environments/dev_env",
  server => Deployit['remote'],
  ensure   => absent,
}