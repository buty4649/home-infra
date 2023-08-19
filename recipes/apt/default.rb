# remote_file '/etc/apt/sources.list' do
#   notifies :run, 'execute[apt update]'
# end

execute 'apt update' do
  action :nothing
end
