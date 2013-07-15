require 'puppet/provider/rest_provider'

Puppet::Type.type(:deployit_role).provide :http, :parent => Puppet::Provider::DeployitCliProvider do
  @doc = "Manage role using http protocol"

  def exists?
    security.role_exist? @resource[:name]
  end

  def create
    security.create_role @resource[:name]
  end

  def destroy
    security.delete_role @resource[:name]
  end

end

