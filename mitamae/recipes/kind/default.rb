install_path = node.dig('kind', 'install_path') || '/usr/local/bin/kind'
version = node['kind']['version']

execute 'Download kind binary' do
  command <<~COMMAND
    wget https://github.com/kubernetes-sigs/kind/releases/download/v#{version}/kind-linux-amd64
    wget -q -O- https://github.com/kubernetes-sigs/kind/releases/download/v#{version}/kind-linux-amd64.sha256sum | sha256sum -c - || { rm kind-linux-amd64; exit 1; }
    mv kind-linux-amd64 #{install_path}
  COMMAND
  not_if "test -x #{install_path} && #{install_path} --version | grep -q 'kind version #{version}'"
end

file install_path do
  mode '0755'
end

execute 'kind create cluster' do
  not_if 'kind get clusters | grep -q kind'
end

directory '/etc/kubernetes'
execute 'kind get kubeconfig' do
  command 'kind get kubeconfig > /etc/kubernetes/admin.conf'
end

file '/etc/kubernetes/admin.conf' do
  mode '0600'
end
