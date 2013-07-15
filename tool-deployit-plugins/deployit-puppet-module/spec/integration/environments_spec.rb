require 'spec_helper'

describe PuppetDeployitModule do

  def run_puppet_command_with_file(filename)
    `puppet apply --modulepath .. tests/#{filename}  --trace`
  end

  it 'manages environments' do

    communicator = DeployitCommunicator.new('http://localhost:4516', 'admin', 'admin', '/')
    repository = Repository.new(communicator)

    run_puppet_command_with_file 'environments_c.pp'
    repository.exists?('Environments/simple.env').should == true
    repository.read('Environments/simple.env')['members'].should include 'Infrastructure/simple.host.2'
    repository.read('Environments/simple.env')['members'].should include 'Infrastructure/simple.host.1'


    run_puppet_command_with_file 'environments_u.pp'
    repository.exists?('Environments/simple.env').should == true
    repository.read('Environments/simple.env')['members'].should include 'Infrastructure/simple.host.2'
    repository.read('Environments/simple.env')['members'].should_not include 'Infrastructure/simple.host.1'

    run_puppet_command_with_file 'environments_d.pp'
    repository.exists?('Environments/simple.env').should == false

    run_puppet_command_with_file 'environments_clean.pp'
  end


end