#!/usr/bin/env ruby

require 'itamae/secrets'

host.properties['attributes'] ||= {}
host.properties['attributes']['nodename'] = host.name
secrets = Itamae::Secrets(File.join(__dir__, 'attributes/secret'))
Dir.glob(File.join(secrets.values_path, '*')).each do |path|
  name = File.basename(path)
  host.properties['attributes'][name] = secrets[name]
end

def load_properties(role)
  role_file = File.join('.', 'attributes', 'role', "#{role}.yml")
  return unless File.exist?(role_file)

  override_properties = YAML.load_file(role_file)
  host.properties.merge!(override_properties)
end

load_properties(host.properties['role'])
