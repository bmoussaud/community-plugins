require 'puppet/type'

Puppet::Type.newtype :deployit_permission do
  @doc = 'Manage the permissions on CI'

  newparam :name do
    desc 'resource name.'
  end
  newparam :id do
    desc 'CI id'
  end

  newparam :role do
    desc 'role name on the ci'
  end

  newparam :permission do
    desc 'permission name on the ci'
  end

  autorequire(:server) do
    self[:server]
  end

  ensurable do
    defaultvalues
    defaultto :present
  end

end

