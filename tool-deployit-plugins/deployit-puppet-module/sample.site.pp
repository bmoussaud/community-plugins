package {
  'apache2': ensure => installed,
}
package {
  'tomcat6': ensure => installed,
}

package {
  'libxslt-dev': ensure => installed,
}
package {
  'libxml2-dev': ensure => installed,
}

package { 'nokogiri':
  ensure   => 'installed',
  provider => 'gem',
}


service { 'apache2':
  ensure => true,
  enable => true,
  require => Package['apache2']
}


service { 'tomcat6':
  ensure => running,
  require => Package['tomcat6'],
}


deployit { "local":
  username => "admin",
  password => "admin",
  url => "http://localhost:4516",
}

deployit { "remote":
  username => "adminremote",
  password => "adminremote",
  url => "http://remote:4516",
}

deployit_directory { "Infrastructure/Dir1":
  server   => Deployit["local"],
}

deployit_directory { "Infrastructure/Dir1/Dir2":
  server   => Deployit["local"],
}

deployit_directory { "Infrastructure/Dir1/Dir2/Dir3":
  server   => Deployit["local"],
}

deployit_permissions { "Infrastructure/Dir1/Dir2":
  server => Deployit["local"],
  properties => { role1 => read, role2 => read } ,
}

deployit_container { "Infrastructure/host":
  type     => "overthere.SshHost",
  ensure   => present,
  properties   => { os => UNIX, address => $ipaddress, username  => scott, password => tiger},
  server   => Deployit["local"],
}

deployit_container { "Infrastructure/host/apache":
  type     => "www.ApacheHttpdServer",
  tags     => ['frontend', 'www'],
  ensure   => present,
  properties   => { startCommand => "start.sh" , stopCommand => "stop.sh", defaultDocumentRoot => '/opt/doc', configurationFragmentDirectory => '/opt/conf' },
  require => [Deployit_container['Infrastructure/host'], Package["apache2"]],
  server   => Deployit["local"],
}

deployit_container { "Infrastructure/host/tomcat":
  type     => "tomcat.Server",
  tags     => ['frontend', 'www'],
  ensure   => present,
  properties   => { startCommand => "start.sh" , stopCommand => "stop.sh", home => '/opt/tomcat6', startWaitTime => 10, stopWaitTime => 22 },
  require => [Deployit_container['Infrastructure/host'], Package["apache2"]],
  server   => Deployit["local"],
  environment => "Environments/dev",
}

deployit_container { "Infrastructure/host/tomcat/tomcat.vh" :
  type     => "tomcat.VirtualHost",
  require => Deployit_container['Infrastructure/host/tomcat'],
  server   => Deployit["local"],
  properties   => { },
}

deployit_environment {"Environments/dev":
  members => ['Infrastructure/host/apache','Infrastructure/host','Infrastructure/host/tomcat/tomcat.vh'],
  dictionaries => ['Environments/b','Environments/a'],
  require => Deployit_container['Infrastructure/host/apache'],
  ensure   => present,
  server   => Deployit["local"],
}




