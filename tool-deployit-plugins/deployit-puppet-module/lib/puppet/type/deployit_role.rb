require 'puppet/type'

Puppet::Type.newtype :deployit_role do
  @doc = 'Manage a role on CI'

  newparam :name do
    desc 'resource name.'
  end

  autorequire(:server) do
    self[:server]
  end

  ensurable do
    defaultvalues
    defaultto :present
  end

end

