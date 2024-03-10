define :unarchive, src: nil, dest: nil, strip_components: 0 do
  src = params[:src] || raise('src must be specified')
  dest = params[:dest] || raise('dest must be specified')
  strip_components = params[:strip_components].to_i > 0 ? "--strip-components=#{params[:strip_components]}" : ''

  execute "download and unarchive #{src}" do
    tempfile = Tempfile.new('mitaimae-unarchive')
    command "wget -O- '#{tempfile.path}' #{src} | tar -C #{dest} -zxf - #{strip_components}"
  end
end
