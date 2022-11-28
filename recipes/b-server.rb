include_recipe 'apt'
include_recipe 'hostname'
include_recipe 'unattended_upgrades'
include_recipe 'timezone'
include_recipe 'local_user'

%w[install remove].each do |act|
  node['packages'][act].each do |name|
    package name do
      action act.to_sym
    end
  end
end

include_recipe 'mackerel'
include_recipe 'snapd'
include_recipe 'microk8s'
