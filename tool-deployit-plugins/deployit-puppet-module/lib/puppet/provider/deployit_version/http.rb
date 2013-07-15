require 'puppet/provider/rest_provider'

Puppet::Type.type(:deployit_version).provide :http, :parent => Puppet::Provider::DeployitCliProvider do
  @doc = "Manage version using http protocol"

  def exists?
    repository.exists? @resource[:id]
  end

  def create
    application.upload_package @resource[:id], @resource[:path]
  end

  def destroy
    repository.delete @resource[:id]
  end

end

