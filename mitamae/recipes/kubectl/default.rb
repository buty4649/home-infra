gpg_keyring_path = '/etc/apt/trusted.gpg.d/kubenetes-archive-keyring.gpg'

apt_gpg_key 'kubernetes' do
  uri 'https://packages.cloud.google.com/apt/doc/apt-key.gpg'
  path gpg_keyring_path
end

apt_repository 'kubernetes' do
  types %w[deb]
  uri 'https://apt.kubernetes.io'
  suites %w[kubernetes-xenial]
  components %w[main]
end

package 'kubectl'
