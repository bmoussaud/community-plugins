require 'puppet/type'

Puppet::Type.newtype :deployit_version do
  @doc = 'Manage version of udm.Application'

  newparam :id, :namevar => true do
    desc 'CI id'
  end

  newparam :path do
    desc 'The path to the dar file. Must be fully qualified.'
  end


  autorequire(:server) do
    self[:server]
  end

  ensurable do
    defaultvalues
    defaultto :present
  end

end

