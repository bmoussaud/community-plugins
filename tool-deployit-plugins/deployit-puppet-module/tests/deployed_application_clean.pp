deployit { "remote":
  username => "admin",
  password => "admin",
  url => "http://localhost:4516",
}

deployit_environment { "Environments/dev_env":
  ensure   => absent,
  server   => Deployit["remote"],
  require  => Deployit_container["Infrastructure/local.host"]
}

deployit_container { "Infrastructure/local.host":
  type     => "overthere.LocalHost",
  ensure   => absent,
  properties   => { os => UNIX },
  environments => ['Environments/dev_env'],
  server   => Deployit["remote"],
}


deployit_directory { "Applications/demo-app":
  ensure   => absent,
  server   => Deployit["remote"],
}


deployit_dictionary { 'Environments/dict_env':
  ensure => absent,
  server   => Deployit["remote"],
  entries => {"file.DeployedFile.targetPath" => "/tmp"},
  environments => ['Environments/dev_env'],
  require => Deployit_environment['Environments/dev_env'],
}






