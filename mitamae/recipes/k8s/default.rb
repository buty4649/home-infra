file '/etc/fstab' do
  action :edit
  block do |contents|
    contents.gsub!(/^.+\sswap\s.+\n/, '')
  end
end

execute 'swap off' do
  command 'swapoff -a'
  only_if 'swapon -s | grep -q .'
end

version = node['k8s']['version']

apt_gpg_key 'kubernetes-apt-keyring' do
  uri "https://pkgs.k8s.io/core:/stable:/v#{version}/deb/Release.key"
  path '/etc/apt/keyrings/kubernetes-apt-keyring.gpg'
end

apt_repository 'kubernetes' do
  uri "https://pkgs.k8s.io/core:/stable:/v#{version}/deb/"
  suites []
  components %w[/]
  options(
    'signed-by': '/etc/apt/keyrings/kubernetes-apt-keyring.gpg'
  )
end

%w[kubelet kubeadm kubectl].each do |name|
  package name
end

service 'systemd-modules-load' do
  action :nothing
end

file '/etc/modules-load.d/netfilter.conf' do
  content <<~CONTENT
    br_netfilter
  CONTENT
  notifies :restart, 'service[systemd-modules-load]', :immediately
end

execute 'sysctl --system' do
  command 'sysctl --system'
  action :nothing
end

file '/etc/sysctl.d/99-sysctl.conf' do
  block do |content|
    content.gsub!(/^#net.ipv4.ip_forward=1/, 'net.ipv4.ip_forward=1')
    content.gsub!(/^#net.ipv6.conf.all.forwarding=1/, 'net.ipv6.conf.all.forwarding=1')
  end
  action :edit
  notifies :run, 'execute[sysctl --system]', :immediately
end

download 'calicoctl' do
  version = node['k8s']['calicoctl_version']
  arch = node['os']['arch']
  uri "https://github.com/projectcalico/calico/releases/download/v#{version}/calicoctl-linux-#{arch}"
  dest '/usr/local/bin/calicoctl'
  owner 'root'
  group 'root'
  mode '0755'
  not_if "which calicoctl && calicoctl version | grep -q 'v#{version}'"
end
