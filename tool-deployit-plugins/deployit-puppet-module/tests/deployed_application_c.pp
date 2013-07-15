deployit { "remote":
  username => "admin",
  password => "admin",
  url => "http://localhost:4516",
}

deployit_environment { "Environments/dev_env":
  ensure   => present,
  server   => Deployit["remote"],
}


deployit_dictionary { 'Environments/dict_env':
  ensure => present,
  server   => Deployit["remote"],
  entries => {"file.DeployedFile.targetPath" => "/tmp"},
  environments => ['Environments/dev_env'],

}

deployit_version { "Applications/demo-app/1.0":
  ensure   => present,
  server   => Deployit["remote"],
  path     => "tests/dar/demo-app-1.0.dar"

}

deployit_container { "Infrastructure/local.host":
  type     => "overthere.LocalHost",
  ensure   => present,
  properties   => { os => UNIX },
  server   => Deployit["remote"],
  environments => ['Environments/dev_env'],
  require => Deployit_environment['Environments/dev_env']
}

deployed_application { "Puppet application is deployed on dev environment":
  version => "Applications/demo-app/1.0",
  environment => "Environments/dev_env",
  server => Deployit['remote'],
  require => [Deployit_container['Infrastructure/local.host'],Deployit_version["Applications/demo-app/1.0"], Deployit_dictionary['Environments/dict_env']],
}