require 'puppet/type'

Puppet::Type.newtype :deployit_directory do
  @doc = 'a core.Directory on Deployit Server.'

  newparam :id, :namevar => true do
    desc 'CI id'
  end

  newparam :type do
    desc 'CI Type'
    defaultto 'core.Directory'
  end

  autorequire(:server) do
    self[:server]
  end

  ensurable do
    defaultvalues
    defaultto :present
  end

end

