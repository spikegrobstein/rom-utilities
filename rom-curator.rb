require 'bundler/setup'
require 'pry'
require 'highline'

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
  original = filename
  filename = File.basename(filename)
  extension = File.extname(filename)
  components = filename.match(/^(.+?)\s((v\.\d+|v\d+\b|\(|-|\[).+)$/i)

  {
    original: original,
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

listfile = ARGV[0]
outfile = ARGV[1]

unless listfile && outfile
  puts "USAGE: rom-curator <infile> <outfile>"
  exit 1
end

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

File.open(outfile, 'w') do |f|
  cli = HighLine.new

  results.each { |key, files|
    if files.length == 1
      puts "Automaticly choosing #{key}"
      f.puts files[0][:original]
      next
    end

    filenames = files.map { |file|
      file[:original]
    }.sort { |a,b|
      a <=> b
    }

    puts "Choice: #{key} (#{files.length} files)"
    choice = cli.choose do |menu|
      menu.prompt = "Which rom for #{ key }?"
      menu.choice :all
      menu.choice :none

      filenames.each { |filename|
        menu.choice filename
      }

      menu.default = filenames.last
    end

    if choice == :all
      filenames.each do |filename|
        f.puts filename
      end
    elsif choice == :none
      puts "Skipping #{key}"
    else
      f.puts choice
    end
  }
end

