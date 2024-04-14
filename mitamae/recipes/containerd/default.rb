arch = node['os']['arch']
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
state_dir = node.dig('containerd', 'state_dir') || '/run/containerd'

template '/etc/containerd/config.toml' do
  notifies :restart, 'service[containerd]'
  variables(
    state_dir: state_dir,
  )
end

remote_file '/etc/systemd/system/containerd.service' do
  notifies :run, 'execute[systemctl daemon-reload]', :immediately
end

service 'containerd' do
  action %i[enable start]
end

download 'runc' do
  version = node['containerd']['runc_version']
  uri "https://github.com/opencontainers/runc/releases/download/v#{version}/runc.#{arch}"
  dest '/usr/local/bin/runc'
  owner 'root'
  group 'root'
  mode '0755'
  not_if "which runc && runc --version | grep -q 'runc version #{version}'"
end

directory '/opt/cni/bin'

unarchive 'CNI plugins' do
  version = node['containerd']['cni_version']
  download_url = "https://github.com/containernetworking/plugins/releases/download/v#{version}/cni-plugins-linux-#{arch}-v#{version}.tgz"

  src download_url
  dest '/opt/cni/bin'
  not_if "test -f /opt/cni/bin/dummy && /opt/cni/bin/dummy --version 2>&1 | grep -q ' v#{version}'"
end
