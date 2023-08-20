package 'unattended-upgrades'

service 'unattended-upgrades' do
  action [:start, :enable]
end
