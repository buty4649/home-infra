remote_file '/etc/apt/sources.list'

execute 'apt update' do
  action :nothing
end
