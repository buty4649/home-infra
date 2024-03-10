execute 'apt update' do
  command 'apt-get update'
  action :nothing
end

define :apt_repository, deb822: false, path: nil, types:%w[deb], uri: nil, suites: nil, components: %w[main], options: nil do
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
  options = params[:options]

  if deb822
    template path do
      source 'templates/apt/deb822.erb'
      mode '0644'
      variables(
        types: types,
        uri: uri,
        suites: suites,
        components: components
      )
      notifies :run, 'execute[apt update]', :immediately
    end
  else
    options_str = if options
      str = options.map do |key, value|
        "#{key}=#{value}"
      end
      " [#{str.join(' ')}]"
    end
    template path do
      source 'templates/apt/legacy.erb'
      mode '0644'
      variables(
        types: types,
        uri: uri,
        suites: suites,
        components: components,
        options: options_str
      )
      notifies :run, 'execute[apt update]', :immediately
    end
  end
end

define :apt_gpg_key, uri: nil, path: nil do
  uri = params[:uri]
  raise 'uri must be specified' unless uri
  path = params[:path]
  raise 'path must be specified' unless path

  package 'gpg'
  execute "add gpg key #{uri}" do
    command "wget -q -O- #{uri} | gpg --dearmor -o #{path}"
    not_if "test -f #{path}"
  end
end
