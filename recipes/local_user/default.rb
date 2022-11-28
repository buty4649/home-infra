username = 'buty4649'
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

%w[adm sudo].each do |name|
  execute "Add #{username} to #{name} group" do
    command "usermod -a -G #{name} #{username}"
    not_if "groups #{username} | grep -q #{name}"
  end
end

file "/etc/sudoers.d/#{username}" do
  mode '0440'
  content "#{username} ALL=NOPASSWD: ALL\n"
end

# disable default user
%w[pi].each do |name|
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
