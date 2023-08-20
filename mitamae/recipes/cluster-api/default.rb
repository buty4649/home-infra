include_recipe 'install'

config_path = node.dig('cluster-api', 'config_path')
infrastructure = node.dig('cluster-api', 'infrastructure')

directory File.dirname(config_path)
file config_path do
  mode '0600'
  content YAML.dump(node['cluster-api']['config'])
end

execute 'clusterctl init' do
  command "clusterctl init --config #{config_path} --infrastructure #{infrastructure}"
  not_if "kubectl get namespaces | grep -q ^capi-kubeadm-bootstrap-system"
end
