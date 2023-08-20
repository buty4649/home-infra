hostname = node['nodename']
execute 'set hostname' do
  command "hostnamectl set-hostname #{hostname}"
  not_if "test `hostnamectl --static` = '#{hostname}'"
end
