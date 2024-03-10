file '/etc/fstab' do
  action :edit
  block do |contents|
    contents.gsub!(/^.+\sswap\s.+\n/, '')
  end
end

execute 'swap off' do
  command 'swapoff -a'
  only_if 'swaponf -s | grep -q .'
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
