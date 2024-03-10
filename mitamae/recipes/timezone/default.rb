timezone = 'Asia/Tokyo'

execute "set timezone to #{timezone}" do
  command "timedatectl set-timezone '#{timezone}'"
  not_if "timedatectl show -p Timezone | grep -q '^Timezone=#{timezone}'"
end
