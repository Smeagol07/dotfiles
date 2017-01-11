#!/bin/ruby
#=================================================
# name:   mutt-html-markdown.rb
# author: Pawel Bogut <http://pbogut.me>
# date:   06/01/2017
#=================================================
srcfile = File.open(ARGV[0], 'rb')
mail = srcfile.read

body = mail.gsub(/\A.*?^$\n/m, '')
body.gsub!(/^(.*)$/,'\1  ') # force line break everywhere

new_body =  ''
pre_block = false
body.split("\n").each do |line|
  if line.match(/^>.*$/) && !pre_block
    new_body << "<pre class=\"quoted\">\n"
    pre_block = true
  end

  if !line.match(/^>.*$/) && pre_block
    new_body << "</pre>\n"
    pre_block = false
  end

  new_body << line + "\n"
end
# if body ended on quoted text, then close pre
new_body << "</pre>\n" if pre_block

html = `markdown <<< "#{new_body}"`

result = <<HTML
<html>
<head>
<meta http-equiv="Content-Type" content="text/html charset=UTF-8" />
<meta name="generator" content="mutt-html-markdown/0.1" />
<style>
code { font-family: 'Andale Mono', 'Lucida Console', 'Bitstream Vera Sans Mono', 'Courier New', monospace; }
pre { border-left: 20px solid #ddd; margin-left: 10px; padding-left: 5px; }
pre.quoted { border-left: 5px solid #ddd; margin-left: 0; }
</style>
</head>
<body>
#{html}
</body>
</html>
HTML

File.open(File.expand_path('~/.mutt/html-markdown-alternative.html'), 'w+') do |file|
  file.write(result)
end
puts result
