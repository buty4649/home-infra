service 'systemd-resolved' do
  action %i[enable start]
end

file '/etc/systemd/resolved.conf' do
  action :edit
  block do |content|
    content.gsub!(/^#LLMNR=no$/, 'LLMNR=yes')
  end
  notifies :restart, 'service[systemd-resolved]'
end
