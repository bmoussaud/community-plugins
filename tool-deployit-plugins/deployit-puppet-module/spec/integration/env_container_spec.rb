require 'spec_helper'

describe PuppetDeployitModule do

  def run_puppet_command_with_file(filename)
    `puppet apply --modulepath .. tests/#{filename}  --trace`
  end

  it 'manages environment in a container' do

    communicator = DeployitCommunicator.new('http://localhost:4516', 'admin', 'admin', '/')
    repository = Repository.new(communicator)

    run_puppet_command_with_file 'host_env_c.pp'
    env = repository.read('Environments/host_env')
    env['members'].should include 'Infrastructure/container1'

    run_puppet_command_with_file 'host_env_u.pp'
    env = repository.read('Environments/host_env')
    env['members'].should include 'Infrastructure/container1'
    env['members'].should include 'Infrastructure/container2'

    run_puppet_command_with_file 'host_env_d.pp'
    env = repository.read('Environments/host_env')
    env['members'].should include 'Infrastructure/container2'
    env['members'].should_not include 'Infrastructure/container1'

    run_puppet_command_with_file 'host_env_clean.pp'

  end


end