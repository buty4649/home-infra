username = node['local_user']['name']
groupname = username

group groupname
user username do
  gid groupname
  home "/home/#{username}"
  system_user false
  shell '/bin/bash'
  create_home true
end

directory "/home/#{username}/.ssh" do
  owner username
  group groupname
  mode '0700'
end

remote_file "/home/#{username}/.ssh/authorized_keys" do
  owner username
  group groupname
  mode '0600'
end

define 'add_group', user: nil do
  group = params[:name]
  user = params[:user]
  raise 'user must not be empty' unless user

  execute "Add #{user} to #{group} group" do
    command "usermod -a -G #{group} #{user}"
    not_if "groups #{user} | grep -q #{group}"
  end
end

%w[adm sudo].each do |name|
  add_group name do
    user username
  end
end

file "/etc/sudoers.d/#{username}" do
  mode '0440'
  content "#{username} ALL=NOPASSWD: ALL\n"
end

node['local_user']['disable_users']&.each do |name|
  execute "Delete #{name} user" do
    command "userdel -r #{name}"
    only_if "id #{name} && ! pgrep -U #{name}"
  end
end
