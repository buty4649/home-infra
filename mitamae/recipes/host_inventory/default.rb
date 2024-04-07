node['lsb'] = {}
result = run_command('lsb_release -a 2> /dev/null || true')
result.stdout.split("\n").each do |line|
  case line
  when /^Distributor ID:\s*(.+)$/
    node['lsb']['platform'] = Regexp.last_match[1]
  when /^Description:\s*(.+)$/
    node['lsb']['description'] = Regexp.last_match[1]
  when /^Release:\s*(.+)$/
    node['lsb']['release'] = Regexp.last_match[1]
  when /^Codename:\s*(.+)$/
    node['lsb']['codename'] = Regexp.last_match[1]
  end
end

node['os'] ||= {}
node['os']['arch'] = case node['kernel']['machine']
                     when 'x86_64' then 'amd64'
                     when 'aarch64' then 'arm64'
                     end

addresses = JSON.parse(run_command('ip -4 -j addr').stdout).flat_map { |i| i['addr_info'].flat_map{ |a| a['local'] } }
node['local-ipv4'] = addresses.find {|a| a =~ /^192.168.177/ }
