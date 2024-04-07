package 'bird2'

template '/etc/bird/bird.conf' do
  owner 'bird'
  group 'bird'
  mode '0640'
  variables(
    router_id: node['local-ipv4'],
    local_community: "65002,#{node['local-ipv4'].split('.').last}",
    neighbor: '192.168.177.1',
    neighbor_asn: 65_001,
    local_asn: 65_002,
    cilium_asn: 65_003
  )
  notifies :reload, 'service[bird]'
end

service 'bird' do
  action %i[enable start]
end
