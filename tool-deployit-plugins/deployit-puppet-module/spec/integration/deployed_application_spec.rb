require 'spec_helper'

describe PuppetDeployitModule do

  def run_puppet_command_with_file(filename)
    `puppet apply --modulepath .. tests/#{filename}  --trace`
  end


  it 'manages deployed applications' do
    communicator = DeployitCommunicator.new('http://localhost:4516', 'admin', 'admin', '/')
    repository = Repository.new(communicator)
    deployed_application_id='Environments/dev_env/demo-app'

    run_puppet_command_with_file 'deployed_application_c.pp'
    repository.exists?(deployed_application_id).should == true
    ci=repository.read(deployed_application_id)
    ci['version'].should include('1.0')

    run_puppet_command_with_file 'deployed_application_u.pp'
    repository.exists?(deployed_application_id).should == true
    ci=repository.read(deployed_application_id)
    ci['version'].should include('2.0')

    run_puppet_command_with_file 'deployed_application_d.pp'
    repository.exists?(deployed_application_id).should == false

    run_puppet_command_with_file 'deployed_application_clean.pp'
  end


end