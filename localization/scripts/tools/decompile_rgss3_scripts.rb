require "fileutils"
require "zlib"

input, output = ARGV
abort "usage: ruby decompile_rgss3_scripts.rb INPUT OUTPUT" unless input && output

scripts = Marshal.load(File.binread(input))
FileUtils.rm_rf(output)
FileUtils.mkdir_p(output)

scripts.each_with_index do |entry, index|
  parts = entry[1].to_s.split("/").map { |part| part.delete(':*?"<>|') }
  basename = parts.pop || ""
  path = File.join(output, *parts, "#{index} - #{basename}.rb")
  FileUtils.mkdir_p(File.dirname(path))
  File.binwrite(path, Zlib::Inflate.inflate(entry[2]))
end

puts "Extracted #{scripts.length} script sections to #{output}"
