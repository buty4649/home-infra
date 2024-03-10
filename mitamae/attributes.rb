# frozen_string_literal: true

require 'itamae/secrets'
require 'erb'
require 'yaml'

host.properties['attributes'] ||= {}
host.properties['attributes']['nodename'] = host.name
secrets = Itamae::Secrets(File.join(__dir__, 'attributes/secret'))

def load_properties(role, vars = {})
  role_file = File.join('.', 'attributes', 'role', "#{role}.yml")
  return unless File.exist?(role_file)

  erb = ERB.new(File.read(role_file))
  override_properties = YAML.load(erb.result_with_hash(vars))
  if (recipes = override_properties.delete('recipes'))
    override_properties['run_list'] ||= []
    recipes.each do |recipe|
      basepath = File.join('.', 'recipes', recipe.split('::'))
      recipe_file = ["#{basepath}.rb", File.join(basepath, 'default.rb')].find do |path|
        File.exist?(path)
      end
      raise "recipe #{recipe} not found" unless recipe_file

      override_properties['run_list'] << recipe_file
    end
  end
  host.properties.merge!(override_properties)
end

load_properties(host.properties['role'], { secrets: })
