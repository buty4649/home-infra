include_recipe 'host_inventory'

include_recipe 'apt'
include_recipe 'hostname'
include_recipe 'unattended_upgrades'
include_recipe 'timezone'
include_recipe 'local_user'
include_recipe 'packages'
include_recipe 'mackerel'

include_recipe 'firmware'
