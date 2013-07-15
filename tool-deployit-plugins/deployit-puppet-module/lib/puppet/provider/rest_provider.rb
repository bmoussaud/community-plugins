require 'puppet'
require 'puppet_x/xebialabs/deployit/cli.rb'

class Puppet::Provider::DeployitCliProvider < Puppet::Provider

  attr_accessor :ci

  def exists?
    !ci.nil?
  end

  def create
    @state = :create
    @ci = to_ci
  end

  def destroy
    @state = :destroy
  end

  def properties
    #ci.properties.select { |p| @resource[:properties].keys.include? p } not work using ruby 1.8.7
    props = {}
    ci.properties.each do |key, value|
      if @resource[:properties].keys.include? key
        props[key]=value
      end
    end

    #encrypt fields
    if props.keys.include? 'password'
      @resource[:properties]['password'] = repository.encrypt(@resource[:properties]['password'], deployit_resource[:encrypted_dictionary])
    end
    if props.keys.include? 'passphrase'
      @resource[:properties]['passphrase'] = repository.encrypt(@resource[:properties]['passphrase'], deployit_resource[:encrypted_dictionary])
    end

    props
  end

  def properties=(values)
    ci.properties=values
    @state = :modify
    @property_hash[:properties]=values
  end

  def communicator
    return @communicator if defined?(@communicator)
    @communicator = DeployitCommunicator.new(deployit_resource[:url], deployit_resource[:username], deployit_resource[:password], deployit_resource[:context])
    Puppet.debug("Deployit Server #{@communicator}")
    @communicator
  end

  def deployit_resource
    return @deployit_resource if defined?(@deployit_resource)
    unless @deployit_resource = resource.catalog.resource("#{resource[:server]}")
      raise "Can't find #{resource[:server]}"
    end
    @deployit_resource
  end

  def repository
    return @repository if defined?(@repository)
    @repository = Repository.new(communicator)
    @repository
  end

  def security
    return @security if defined?(@security)
    @security = Security.new(communicator)
    @security
  end

  def deployment
    return @deployment if defined?(@deployment)
    @deployment = Deployment.new(communicator)
    @deployment
  end

  def tasks
    return @tasks if defined?(@tasks)
    @tasks = Tasks.new(communicator)
    @tasks
  end

  def application
    return @application if defined?(@application)
    @application = Application.new(communicator)
    @application
  end

end


