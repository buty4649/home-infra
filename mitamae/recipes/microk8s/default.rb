if node['machine'] == 'Raspberry Pi 4'
  # need cgroup
  # see. https://ubuntu.com/tutorials/how-to-kubernetes-cluster-on-raspberry-pi#4-installing-microk8s
  file '/boot/firmware/cmdline.txt' do
    action :edit
    block do |content|
      options = 'cgroup_enable=memory cgroup_memory=1'
      content.insert(0, "#{options} ") unless content.include?(options)
    end
    notifies :run, 'local_ruby_block[need_restart]', :immediately
  end

  local_ruby_block 'need_restart' do
    action :nothing
    block do
      warn "\e[31m**IMPORTANT**\e[0m"
      warn "\e[31mmicrok8s need cgroup.\e[0m"
      warn "\e[31mA reboot is required to activate the cgroup.\e[0m"
      $stderr.puts
      exit
    end
  end
end

snap_package 'microk8s' do
  classic true
  channel '1.25'
end

execute 'alias microk8s.kubectl to kubectl' do
  command 'snap alias microk8s.kubectl kubectl'
  not_if 'test -e /snap/bin/kubectl'
end

local_user = node['local_user']['name']
add_group 'microk8s' do
  user local_user
end

execute 'Restart microk8s' do
  action :nothing
  command 'microk8s stop; microk8s start'
end
