execute 'add apt key' do
  command 'wget -q -O- https://mackerel.io/file/cert/GPG-KEY-mackerel-v2 | apt-key add -'
  not_if 'apt-key finger | grep -q "9DD9 479D 06BA A713 2280  3AC1 6633 2B78 417E 73EA"'
end

remote_file '/etc/apt/sources.list.d/mackerel.list' do
  notifies :run, 'execute[apt update]'
end

%w[
  mackerel-agent
  mackerel-agent-plugins
  mackerel-check-plugins
  mkr
].each do |name|
  package name
end

directory '/etc/mackerel-agent/conf.d'

template '/etc/mackerel-agent/mackerel-agent.conf' do
  variables(
    mackerel_api_key: node['mackerel_api_key']
  )
  notifies :restart, 'service[mackerel-agent]'
end

service 'mackerel-agent' do
  action [:start, :enable]
end

define :mkr_plugin, version: nil do
  name = params[:name]
  version = params[:version]
  package_name = version ? "#{name}@#{version}" : name
  release_tag_path = "/opt/mackerel-agent/plugins/meta/#{name}/release_tag"
  release_tag = run_command("cat #{release_tag_path}")

  if release_tag.exit_status == 0
    execute "mkr plugin install #{name}" do
      command "mkr plugin install --upgrade #{package_name}"
      not_if { release_tag.stdout.chomp == version }
    end
  else
    # Not installed
    execute "mkr plugin install #{name}" do
      command "mkr plugin install #{package_name}"
    end
  end
end

include_recipe 'plugin-pinging'
include_recipe 'plugin-thermal'
