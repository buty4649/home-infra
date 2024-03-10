arch = case node['kernel']['machine']
       when 'x86_64' then 'amd64'
       when 'aarch64' then 'arm64'
       end

unarchive 'containerd' do
  version = node['containerd']['version']
  download_url = "https://github.com/containerd/containerd/releases/download/v#{version}/containerd-#{version}-linux-#{arch}.tar.gz"

  src download_url
  dest '/usr/local/bin'
  strip_components 1
  not_if "test -f /usr/local/bin/containerd && containerd --version | grep -q ' v#{version} '"
  notifies :restart, 'service[containerd]'
end

directory '/etc/containerd'

remote_file '/etc/containerd/config.toml' do
  notifies :restart, 'service[containerd]'
end

remote_file '/etc/systemd/system/containerd.service' do
  notifies :run, 'execute[systemctl daemon-reload]', :immediately
end

service 'containerd' do
  action %i[enable start]
end

directory '/opt/cni/bin'

unarchive 'CNI plugins' do
  version = node['containerd']['cni_version']
  download_url = "https://github.com/containernetworking/plugins/releases/download/v#{version}/cni-plugins-linux-#{arch}-v#{version}.tgz"

  src download_url
  dest '/opt/cni/bin'
end
