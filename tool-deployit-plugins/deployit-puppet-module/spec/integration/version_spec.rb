require 'spec_helper'

describe PuppetDeployitModule do

  def run_puppet_command_with_file(filename)
    `puppet apply --modulepath .. tests/#{filename}  --trace`
  end

  it 'manages permissions ' do

    communicator = DeployitCommunicator.new('http://localhost:4516', 'admin', 'admin', '/')
    repository = Repository.new(communicator)

    run_puppet_command_with_file 'application_c.pp'
    repository.exists?('Applications/demo-app/1.0').should == true
    repository.exists?('Applications/demo-app/1.0/sample.txt').should == true

    run_puppet_command_with_file 'application_d.pp'
    repository.exists?('Applications/demo-app/1.0').should == false
    repository.exists?('Applications/demo-app/1.0/sample.txt').should == false

    run_puppet_command_with_file 'application_clean.pp'
  end

end