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
  if recipes = override_properties.delete('recipes')
    override_properties['run_list'] ||= []
    recipes.each do |recipe|
      basepath = File.join('.', 'recipes', recipe.split("::"))
      recipe_file = ["#{basepath}.rb", File.join(basepath, 'default.rb')].find do |path|
        File.exist?(path)
      end
      raise "recipe #{recipe} not found" unless recipe_file
      override_properties['run_list'] << recipe_file
    end
  end
  host.properties.merge!(override_properties)
end

load_properties(host.properties['role'])
