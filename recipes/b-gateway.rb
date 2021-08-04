include_recipe 'apt'
include_recipe 'hostname'
include_recipe 'unattended_upgrades'
include_recipe 'timezone'
include_recipe 'mackerel'

# hochoに必要
package 'rsync'
