%w[install remove].each do |act|
  node.dig('packages', act)&.each do |name|
    package name do
      action act.to_sym
    end
  end
end
