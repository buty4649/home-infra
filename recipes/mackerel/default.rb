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

template '/etc/mackerel-agent/mackerel-agent.conf' do
  variables(
    mackerel_api_key: node['mackerel_api_key']
  )
  notifies :restart, 'service[mackerel-agent]'
end

service 'mackerel-agent' do
  action [:start, :enable]
end
