require 'puppet/provider/rest_provider'

Puppet::Type.type(:deployed_application).provide :http, :parent => Puppet::Provider::DeployitCliProvider do
  @doc = 'Manage Deployit Deployed Application CI using http protocol'

  def exists?
    if resource[:force_deployment]
      Puppet.debug ' deployed_app: exists? force redeployment'
      return false
    end
    application = repository.read(resource[:version])['application']
    if deployment.exists?(application, resource[:environment])
      deployed_application = repository.read(deployment.deployed_application_id(resource[:version], resource[:environment]))
      Puppet.debug " deployed_app: #{deployed_application}"
      deployed_application['version'].eql? resource[:version]
    else
      false
    end
  end

  def create
    task_id = deployment.deployment_task(resource[:version], resource[:environment])
    tasks.start_and_wait task_id
    tasks.archive task_id
  end

  def destroy
    task_id = deployment.undeployment_task(resource[:version], resource[:environment])
    tasks.start_and_wait task_id
    tasks.archive task_id
  end


end

