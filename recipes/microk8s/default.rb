snap_package 'microk8s' do
  classic true
  channel '1.25'
end

local_user = node['local_user']['name']
add_group 'microk8s' do
  user local_user
end

# fix: overlayfs: filesystem on '~' not supported as upperdir
file '/var/snap/microk8s/current/args/containerd-template.toml' do
  action :edit
  block do |content|
    content.gsub!('snapshotter = "${SNAPSHOTTER}"', 'snapshotter = "native"')
  end
  notifies :run, 'execute[Restart microk8s]'
end

execute 'Restart microk8s' do
  action :nothing
  command 'microk8s stop; microk8s start'
end
