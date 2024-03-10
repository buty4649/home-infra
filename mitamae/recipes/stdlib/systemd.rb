execute 'systemctl daemon-reload' do
  command 'systemctl daemon-reload'
  action :nothing
end
