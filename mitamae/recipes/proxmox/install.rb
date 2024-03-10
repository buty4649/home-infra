gpg_keyring_path = '/etc/apt/trusted.gpg.d/proxmox-archive-keyring.gpg'

apt_gpg_key 'proxmox' do
  uri 'https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg'
  path gpg_keyring_path
end

apt_repository 'proxmox' do
  types %w[deb]
  uri 'http://download.proxmox.com/debian/pve'
  suites [node.lsb.codename]
  components %w[pve-no-subscription]
  options({
            arch: 'amd64',
            'signed-by': gpg_keyring_path
          })
end

# ifupdown2のインストールがコケるので先につくっておく
directory '/run/network'

%w[
  pve-kernel-6.2
  proxmox-ve
  postfix
  open-iscsi
].each do |name|
  package name
end

# 削除が奨励されているパッケージ
package 'os-prober' do
  action :remove
end

linux_images = run_command('dpkg-query -f \'${Package}\n\' -W | grep linux-image-').stdout.split("\n")
linux_images.each do |name|
  package name do
    action :remove
  end
end

# ifupdown2とバッティングするので対処
package 'systemd-resolved' do
  action :remove
end

file '/etc/resolv.conf' do
  action :delete
  only_if 'test -L /etc/resolv.conf'
end

execute 'generate /etc/network/interfaces' do
  command <<~COMMAND
    ifquery --running $(ip -br link | awk '!/^lo/{print $1}') >> /etc/network/interfaces &&
    ifreload -a
  COMMAND
  not_if 'ifquery --list | grep -v "^lo\\$" | grep -q .'
end

service 'systemd-networkd' do
  action %i[stop disable]
end
