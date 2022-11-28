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

file "/home/#{username}/.ssh/authorized_keys" do
  owner username
  group groupname
  mode '0600'
  content 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC80CcHijYIWT9/PoeGaVL7yh8jkWJqVoUdFjxaw8aUoqXWmG5/GO3/XnKwupfHI/w+ufEnnagQOTmg6DJntVpvhRCT+76uStYia2fPVnBoKSIn7xZQcL3oL7yVesqlb7tYLzHE1oiVclS9npZ8lukAbxtuJ8YVphRmb54Z82ZYUL66V8b9ZZb0nNiBTqT7hL6CT1n++XU01HcOrjx8S0We0z87bX/pLscLKJieQZlOA/N1nvkuBp67Gmsbmj8yJ6djWSsTx8VDDqFqY/xEUW7odlASv5K0zhHkleRmLBI10KHsx+MGtsaVwH2CKi2Qckam+4Zh5ttR/njUC5KUXJI/'
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

node['local_user']['disable_users'].each do |name|
  user name do
    shell '/sbin/nologin'
    password '*'
  end

  key_path = "/home/#{name}/.ssh/authorized_keys"
  execute 'Delete authorized_keys' do
    command "rm -f #{key_path}"
    only_if "test -f #{key_path}"
  end
end
