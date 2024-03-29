remote_file '/usr/local/bin/mackerel-plugin-rootfs' do
  owner 'root'
  group 'root'
  mode '0755'
end

file '/etc/mackerel-agent/conf.d/rootfs.conf' do
  action :create
  content <<~CONF
    [plugin.metrics.rootfs]
    command = "/usr/local/bin/mackerel-plugin-rootfs"
  CONF
  notifies :reload, 'service[mackerel-agent]'
end
