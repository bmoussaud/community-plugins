require 'puppet/provider/rest_provider'

Puppet::Type.type(:deployit_permission).provide :http, :parent => Puppet::Provider::DeployitCliProvider do
  @doc = "Set and unset permission on core.Directory CI using http protocol"

  def exists?
    security.granted?(@resource[:permission], @resource[:role], @resource[:id])
  end

  def create
    security.grant(@resource[:permission], @resource[:role], @resource[:id])
  end

  def destroy
    security.revoke(@resource[:permission], @resource[:role], @resource[:id])
  end

end

