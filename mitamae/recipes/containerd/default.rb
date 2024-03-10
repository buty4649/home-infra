version = node['containerd']['version']
arch = case node['kernel']['machine']
       when 'x86_64' then 'amd64'
       when 'aarch64' then 'arm64'
       end
dest_dir = '/usr/local/bin'
containerd_download_url = "https://github.com/containerd/containerd/releases/download/v#{version}/containerd-#{version}-linux-#{arch}.tar.gz"

execute "download and unarchive #{containerd_download_url}" do
  tempfile = Tempfile.new('mitaimae-unarchive')
  command "wget -O- '#{tempfile.path}' #{containerd_download_url} | tar -C #{dest_dir} -zxvf - --strip-components=1"
  not_if "test -f #{dest_dir}/containerd && containerd --version | grep -q ' v#{version} '"

  notifies :restart, 'service[containerd]'
end

remote_file '/etc/systemd/system/containerd.service' do
  notifies :run, 'execute[systemctl daemon-reload]', :immediately
end

service 'containerd' do
  action %i[enable start]
end
