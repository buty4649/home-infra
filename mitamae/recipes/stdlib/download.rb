define :download, uri: nil, dest: nil, owner: nil, group: nil, mode: nil do
  uri = params[:uri] || raise('uri must be specified')
  dest = params[:dest] || raise('dest must be specified')
  owner = params[:owner]
  group = params[:group]
  mode = params[:mode]

  execute "download #{uri} to #{dest}" do
    command <<~COMMAND
      wget -O "#{dest}" #{uri}
    COMMAND
  end

  if owner || group || mode
    file dest do
      owner owner
      group group
      mode mode
    end
  end
end
