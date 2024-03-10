mkr_plugin 'kazeburo/mackerel-plugin-pinging' do
  version 'v0.0.7'
end

file '/etc/mackerel-agent/conf.d/pinging.conf' do
  action :create
  content <<~CONF
    [plugin.metrics.pinging]
    command = "/opt/mackerel-agent/plugins/bin/mackerel-plugin-pinging --host 8.8.8.8 --key-prefix google_dns"

    [plugin.metrics.pinging_ff14]
    command = "/opt/mackerel-agent/plugins/bin/mackerel-plugin-pinging --host 124.150.157.156 --key-prefix ff14_titan"
  CONF
  notifies :reload, 'service[mackerel-agent]'
end
