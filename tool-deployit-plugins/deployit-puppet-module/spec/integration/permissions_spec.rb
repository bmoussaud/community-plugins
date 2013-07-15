require 'spec_helper'

describe PuppetDeployitModule do

  def run_puppet_command_with_file(filename)
    `puppet apply --modulepath .. tests/#{filename}  --trace`
  end

  it 'manages permissions ' do

    communicator = DeployitCommunicator.new('http://localhost:4516', 'admin', 'admin', '/')
    repository = Repository.new(communicator)
    security = Security.new(communicator)

    run_puppet_command_with_file 'permission_c.pp'
    repository.exists?('Infrastructure/dir-permission').should == true
    security.granted?('read', 'role1', 'Infrastructure/dir-permission').should == true

    run_puppet_command_with_file 'permission_d.pp'
    security.granted?('read', 'role1', 'Infrastructure/dir-permission').should == false

    run_puppet_command_with_file 'permission_clean.pp'
  end

end