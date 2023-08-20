package 'snapd'
service 'snapd' do
  action %i[enable start]
end

define 'snap_package', classic: false, channel: nil do
  name = params[:name]
  classic = ('--classic' if params[:classic])
  channel = if (channel = params[:channel])
              "--channel #{channel}"
            end

  execute "Install snap package: #{name}" do
    command "snap install #{name} #{classic} #{channel}"
    not_if "snap list #{name}"
  end
end
