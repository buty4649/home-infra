#!/usr/bin/env ruby

require 'itamae/secrets'

host.properties["attributes"] ||= {}
secrets = Itamae::Secrets(File.join(__dir__, 'attributes/secret'))
Dir.glob(File.join(secrets.values_path, '*')).each do |path|
  name = File.basename(path)
  host.properties["attributes"][name] = secrets[name]
end
