package 'bird2'

local_ipv4 = node['local-ipv4'].split('.')

# local_ipv4の一つ前がuplink_ip
uplink_ip = local_ipv4[0..2].push(local_ipv4.last.to_i - 1)

template '/etc/bird/bird.conf' do
  owner 'bird'
  group 'bird'
  mode '0640'
  variables(
    router_id: local_ipv4.join('.'),
    community_tag: local_ipv4.last,
    uplink_ip: uplink_ip.join('.'),
    uplink_asn: 65_001,
    my_asn: 65_002,
    cilium_asn: 65_003,
    pod_cidr: '172.16.0.0/16',
    service_cidr: '172.16.252.0/22',
    external_cidr: '192.168.177.64/27'
  )
  notifies :reload, 'service[bird]'
end

service 'bird' do
  action %i[enable start]
end
