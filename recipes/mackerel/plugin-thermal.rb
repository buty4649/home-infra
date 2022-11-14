mkr_plugin 'buty4649/mackerel-plugin-thermal' do
  version 'v1.0.1'
end

file '/etc/mackerel-agent/conf.d/thermal.conf' do
  action :create
  content <<~EOL
    [plugin.metrics.thermal]
    command = "/opt/mackerel-agent/plugins/bin/mackerel-plugin-thermal"
  EOL
  notifies :reload, 'service[mackerel-agent]'
end
