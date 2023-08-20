%w[install remove].each do |act|
  node['packages'][act].each do |name|
    package name do
      action act.to_sym
    end
  end
end
