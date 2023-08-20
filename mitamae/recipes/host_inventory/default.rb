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
