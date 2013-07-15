require 'puppet/type'

Puppet::Type.newtype :deployed_application do
  @doc = "%q{Update the deployed application.
  Example:
    deployed_application { 'PetClinic application is deployed on dev environment ':
      version => 'Applications/Java/PetPortal/2.0-56',
      environment => 'Environments/Dev/Tomcat-Dev',
      server => Deployit['remote'],
    }
  }"

  newparam :id, :namevar => true do
    desc 'id'
  end

  newparam :version do
    desc 'Application version'
  end

  newparam :environment do
    desc 'environment id'
  end

  newparam :force_deployment do
    desc 'always trigger the deployment task even if the version has not changed in between'
    defaultto false
  end

  autorequire(:server) do
    self[:server]
  end

  ensurable do
    defaultvalues
    defaultto :present
  end

end