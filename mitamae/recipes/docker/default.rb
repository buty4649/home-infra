%w[
  ca-certificates
  curl
  gnupg
  lsb-release
].each do |name|
  package name
end

gpg_keyring_path = '/etc/apt/trusted.gpg.d/docker-archive-keyring.gpg'
apt_gpg_key 'docker' do
  uri 'https://download.docker.com/linux/ubuntu/gpg'
  path gpg_keyring_path
end

apt_repository 'docker' do
  types %w[deb]
  uri 'https://download.docker.com/linux/ubuntu'
  suites [node.lsb.codename]
  components %w[stable]
  options({
    arch: 'amd64',
    'signed-by': gpg_keyring_path
  })
end

%w[
  docker-ce
  docker-ce-cli
  containerd.io
  docker-compose-plugin
].each do |name|
  package name
end

service 'docker' do
  action %i[enable start]
end
