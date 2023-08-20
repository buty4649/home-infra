package 'jq'

node.dig('pve', 'roles')&.each do |(name, value)|
  privs = value['privs']
  execute "pveum role add #{name}" do
    command "pveum role add #{name} --privs '#{privs.join(' ')}'"
    not_if "pveum role list --output-format=json | jq -r '.[].roleid' | grep -q #{name}"
  end
end

node.dig('pve', 'users')&.each do |params|
  name = params['name']
  type = params['type']
  userid = [name, type].join('@')
  password = params['password']
  acl = params['acl']
  role = params['role']

  execute "pveum user add #{userid}" do
    commands = %w[pveum user add]
    commands << userid
    commands << "--password '#{password}'" if password

    command commands.join(' ')
    not_if "pveum user list --output-format=json | jq -r '.[].userid' | grep -q #{userid}"
  end

  execute "pveum acl modify / -user #{userid} -role #{role}"
end
