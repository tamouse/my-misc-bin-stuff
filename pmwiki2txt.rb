#!/usr/bin/env ruby

# Convert a file in PmWiki format (http://www.pmwiki.org/wiki/PmWiki/PageFileFormat) to plain text

def convert_markup(s)

  s.sub(/\Atext=/,'')
    .gsub('%0a',"\n")
    .gsub('%3c',"<")
    .gsub('%25',"%")

end

def convert_file(f)
  new_file = "#{f}.txt"
  print("Converting #{f} to #{new_file}...")

  text_content = File.read(f)
    .encode(Encoding::UTF_8, {
      invalid: :replace,
      undef: :replace,
      replace: '?',
      universal_newline: true
    })
    .split(/\n/)
    .tap{|x| puts "number of lines read: #{x.size}"}
    .grep(/\Atext=/)
    .tap{|x| puts "number of lines grepped: #{x.size}"}
    .first
    .tap{|x| puts "first line: #{x}"}

  if text_content
    File.write(new_file, convert_markup(text_content))
    puts("..done")
  else
    puts("..skipped (empty)")
  end

end

ARGV.each do |file|
  convert_file(file)
end
