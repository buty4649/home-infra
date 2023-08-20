# remote_file '/etc/apt/sources.list' do
#   notifies :run, 'execute[apt update]'
# end

execute 'apt update' do
  command 'apt-get update'
  action :nothing
end

define :apt_repository, deb822: false, path: nil, types:%w[deb], uri: nil, suites: nil, components: %w[main] do
  name = params[:name]
  deb822 = params[:deb822]

  path = params[:path] || -> do
    ext = deb822 ? 'sources' : 'list'
    "/etc/apt/sources.list.d/#{name}.#{ext}"
  end.call

  types = params[:types]
  raise 'uri must be specified' unless uri = params[:uri]
  suites = params[:suites] || [node.lsb.codename]
  components = params[:components]

  if deb822
    template path do
      source 'templates/deb822.erb'
      variables(
        types: types,
        uri: uri,
        suites: suites,
        components: components
      )
      notifies :run, 'execute[apt update]', :immediately
    end
  else
    template path do
      source 'templates/legacy.erb'
      variables(
        types: types,
        uri: uri,
        suites: suites,
        components: components
      )
      notifies :run, 'execute[apt update]', :immediately
    end
  end
end
