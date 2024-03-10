hostname = node['nodename']
execute 'set hostname' do
  command "hostnamectl set-hostname #{hostname}"
  not_if "test `hostnamectl --static` = '#{hostname}'"
end

file '/etc/hosts' do
  action :edit
  block do |content|
    content.gsub!(/^(127.0.1.1\s+).+$/, "\\1#{hostname}")
  end
end
