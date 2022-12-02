if node['machine'] == 'Raspberry Pi 4'
  # need cgroup
  # see. https://ubuntu.com/tutorials/how-to-kubernetes-cluster-on-raspberry-pi#4-installing-microk8s
  file '/boot/firmware/cmdline.txt' do
    action :edit
    block do |content|
      options = 'cgroup_enable=memory cgroup_memory=1'
      unless content.include?(options)
        content.insert(0, "#{options} ")
      end
    end
    notifies :run, 'local_ruby_block[need_restart]', :immediately
  end

  local_ruby_block 'need_restart' do
    action :nothing
    block do
      STDERR.puts "\e[31m**IMPORTANT**\e[0m"
      STDERR.puts "\e[31mmicrok8s need cgroup.\e[0m"
      STDERR.puts "\e[31mA reboot is required to activate the cgroup.\e[0m"
      STDERR.puts
      exit
    end
  end
end

snap_package 'microk8s' do
  classic true
  channel '1.25'
end

local_user = node['local_user']['name']
add_group 'microk8s' do
  user local_user
end

if node['machine'] == 'NanoPi R4S'
  # fix: overlayfs: filesystem on '~' not supported as upperdir
  file '/var/snap/microk8s/current/args/containerd-template.toml' do
    action :edit
    block do |content|
      content.gsub!('snapshotter = "${SNAPSHOTTER}"', 'snapshotter = "native"')
    end
    notifies :run, 'execute[Restart microk8s]'
  end
end

execute 'Restart microk8s' do
  action :nothing
  command 'microk8s stop; microk8s start'
end
