require 'bundler/setup'
require 'pry'

# given:
# "./Puzzler 2000 V.43 (Aug 26) (1998) (PD).lnx"
# return:
# {
#   filename: ,
#   basename: ,
#   year: .
#   extension: "lnx"
# }
def parse_filename(filename)
  filename = File.basename(filename)
  extension = File.extname(filename)
  components = filename.match(/^(.+?)\s((v\.\d+|v\d+\b|\(|-|\[).+)$/i)

  {
    filename: filename,
    extension: extension,
    basename: components[1],
    extra: components[2],
    year: (filename.match(/(?:\()\d{4}(?:\))/) || [""])[0].gsub(/\D/, '')
  }

rescue
  puts "Error parsing: #{ filename }"
  raise
end

listfile = ARGV.first
puts "Parsing: #{ listfile }"

results = File.open(listfile).map { |line|
  line.chomp!

  parse_filename(line)
}.sort { |a, b|
  a[:basename] <=> b[:basename]
}.reduce({}) { |acc, file|
  acc[file[:basename]] ||= []

  acc[file[:basename]] << file

  puts "processing #{ file[:basename] }"

  acc
}

results.each { |key, files|
  if files.length == 1
    puts "Skipping #{key}"
    next
  end

  puts "Choice: #{key} - #{files.length}"
}
