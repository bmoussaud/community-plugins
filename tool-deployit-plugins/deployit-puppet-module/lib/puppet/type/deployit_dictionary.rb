require 'puppet/type'

Puppet::Type.newtype :deployit_dictionary do
  @doc = 'Manage a Dictionary on Deployit Server.'

  newparam :id, :namevar => true do
    desc 'CI id'
  end

  newparam :type do
    desc 'CI Type'
    defaultto 'udm.Dictionary'
  end

  newproperty :entries do
    desc 'Entries'
  end

  newproperty :restrict_to_containers, :array_matching => :all do
    desc 'Restrict To Containers property'
    defaultto []
  end

  newproperty :restrict_to_applications, :array_matching => :all do
    desc 'Restrict To Applications property'
    defaultto []
  end

  newproperty :environments, :array_matching => :all do
    desc 'Environment Id on which the container needs to be attached'
    defaultto []
  end

  autorequire(:server) do
    self[:server]
  end

  ensurable do
    defaultvalues
    defaultto :present
  end

end
