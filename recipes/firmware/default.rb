codename = node.lsb.codename
suites = [codename, "#{codename}-updates", "#{codename}-backports"]

apt_repository 'debian-non-free-firmware' do
  types %w[deb deb-src]
  deb822 true
  uri 'mirror+file:///etc/apt/mirrors/debian.list'
  suites suites
  components %w[non-free-firmware]
end

%w[
  firmware-sof-signed
  firmware-misc-nonfree
  firmware-iwlwifi
  wireless-regdb
].each do |name|
  package name
end

file '/etc/modprobe.d/iwliwifi.conf' do
  content 'options iwlwifi enable_ini=N'
end
