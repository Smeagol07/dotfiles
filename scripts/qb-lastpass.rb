#!/usr/bin/env ruby
#=================================================
# name:   qb-lastpass.rb
# author: Pawel Bogut <pbogut@ukpos.com> <http://pbogut.me>
# date:   14/02/2017
#=================================================

require "csv"
require "open3"

action, = ARGV

list = `lpass export`
formated_list = ''
no = -1
list.each_line do |line|
  no += 1
  next if no <= 0
  begin
    line = CSV.parse(line)[0]
    url = line[0]
    user = line[1]
    pass= line[2]
    name = line[4]
    cat = line[5]
    cat = "#{cat}/" if cat
    formated_list <<  ('%3.3s| %-50.50s %-50.50s %s' % [no, "#{cat}#{name}" , user, url]) + "\n"
  rescue
  end
end
site_url = ENV['QUTE_URL'].gsub(/^.*?\/\/(.*?)\/.*/, '\1')

cmd = "(sleep 0.2s; xdotool keyup Ctrl; xdotool type '#{site_url}')" +
      " & rofi -dmenu -p 'acc:'"
selection, _, _ = Open3.capture3(cmd, stdin_data: formated_list)

index = selection.gsub(/(\d+).*/, '\1').to_i

exit unless index > 0

result_line = list.split("\n")[index]
result = CSV.parse(result_line)[0]

user = result[1]
pass = result[2]

sleep 0.2


if action == '--copy-user'
  _, _, _ = Open3.capture3('xsel -p -i', stdin_data: user)
end
if action == '--copy-pass'
  _, _, _ = Open3.capture3('xsel -p -i', stdin_data: pass)
end
if action == '--copy-user-and-pass'
  _, _, _ = Open3.capture3('xsel -b -i', stdin_data: user)
  _, _, _ = Open3.capture3('xsel -p -i', stdin_data: pass)
end
if action == '--type-user'
  File.open(ENV['QUTE_FIFO'], 'w') do |file|
    file.write("fake-key #{user}\n")
    # file.write("fake-key -g <esc>i\n")
  end
end
if action == '--type-pass'
  File.open(ENV['QUTE_FIFO'], 'w') do |file|
    file.write("fake-key #{pass}\n")
    # file.write("fake-key -g <esc>i\n")
  end
end
if action == '--type-user-and-pass' or action.blank?
  File.open(ENV['QUTE_FIFO'], 'w') do |file|
    file.write("fake-key #{user}\n")
    file.write("fake-key <tab>\n")
    file.write("fake-key #{pass}\n")
    # file.write("fake-key -g <esc>i\n")
  end
end

