require 'puppet/provider/rest_provider'

Puppet::Type.type(:deployit_directory).provide :http, :parent => Puppet::Provider::DeployitCliProvider do
  @doc = "Manage a Deployit core.Directory CI using http protocol"

  def exists?
    repository.exists? @resource[:id]
  end

  def create
    repository.create to_ci
  end

  def destroy
    repository.delete @resource[:id]
  end

  def to_ci
    ConfigurationItem.new(@resource[:type], @resource[:id])
  end

end

