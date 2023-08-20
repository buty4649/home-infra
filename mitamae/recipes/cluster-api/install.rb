install_path = node.dig('cluster-api', 'install_path') || '/usr/local/bin/clusterctl'
version = node['cluster-api']['version']

execute 'Download clusterctl binary' do
  command <<~COMMAND
    wget https://github.com/kubernetes-sigs/cluster-api/releases/download/v#{version}/clusterctl-linux-amd64 -O #{install_path}
  COMMAND
  not_if "test -x #{install_path} && #{install_path} version -o short | grep -q v#{version}"
end

file install_path do
  mode '0755'
end
