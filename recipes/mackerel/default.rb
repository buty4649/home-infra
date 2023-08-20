gpg_keyring_path = '/etc/apt/keyrings/mackerel-v2-archive-keyring.gpg'

apt_gpg_key 'mackerel' do
  uri 'https://mackerel.io/file/cert/GPG-KEY-mackerel-v2'
  path gpg_keyring_path
end

apt_repository 'mackerel' do
  types %w[deb]
  uri 'http://apt.mackerel.io/v2/'
  suites %w[mackerel]
  components %w[contrib]
  options({
    arch: 'amd64,arm64',
    'signed-by': gpg_keyring_path,
  })
end

%w[
  mackerel-agent
  mackerel-agent-plugins
  mackerel-check-plugins
  mkr
].each do |name|
  package name
end

directory '/etc/mackerel-agent/conf.d'

template '/etc/mackerel-agent/mackerel-agent.conf' do
  variables(
    mackerel_api_key: node['mackerel_api_key']
  )
  notifies :restart, 'service[mackerel-agent]'
end

service 'mackerel-agent' do
  action [:start, :enable]
end

define :mkr_plugin, version: nil do
  name = params[:name]
  version = params[:version]
  package_name = version ? "#{name}@#{version}" : name
  release_tag_path = "/opt/mackerel-agent/plugins/meta/#{name}/release_tag"
  release_tag = run_command("cat #{release_tag_path} || true")

  if release_tag.stdout.empty?
    # Not installed
    execute "mkr plugin install #{name}" do
      command "mkr plugin install #{package_name}"
    end
  else
    execute "mkr plugin install #{name}" do
      command "mkr plugin install --upgrade #{package_name}"
      not_if { release_tag.stdout.chomp == version }
    end
  end
end

node.dig('mackerel', 'plugins')&.each do |name|
  include_recipe "plugin-#{name}"
end
