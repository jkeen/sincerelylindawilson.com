
desc "Pings PING_URL to keep a dyno alive"
task :dyno_ping do
  require "net/http"

  if ENV['PING_URL']
    uri = URI(ENV['PING_URL'])
    Net::HTTP.get_response(uri)
  end
end


task :new_post, [:short_name, :short_date] do |t, args|
  require 'date'
  
  args.with_defaults(:short_date => DateTime.now.iso8601.split("T")[0], :short_name => ARGV[1].to_s)

  short_name = args.short_name
  short_date = args.short_date

  throw "need short name for creating new post" unless (short_name)
  
  name = short_name.downcase.gsub(/\s/, "-")
  
  folder = Dir.glob("source/letters/*").detect do |s|
    Regexp.new(name).match(s) && File.directory?(s)
  end
  
  unless folder
    # create folder
    folder = "source/letters/#{short_date}-#{short_name}"
    Dir.mkdir("source/letters/#{short_date}-#{short_name}")
  end
  
  files = Dir.glob(folder + "/*")
  number = nil
  if files.size > 0
    numbers = files.collect do |s|
      match = s.scan(/([0-9+])\.markdown/)
      match.flatten[0].to_i
    end
    last_number = numbers.flatten.max

    if last_number
      number = last_number + 1
    else
      number = 1
    end
  end
    
  file = File.join([folder, "#{[short_date, short_name, number].compact.join("-")}.markdown"])
  puts "creating file: #{file}"
  File.open(file, "w") do |f|
    f.puts("---")
    f.puts("layout: post")
    f.puts("date: #{DateTime.now.iso8601}")
    f.puts("title: #{short_name}")
    f.puts("type: original/sent/received")
    f.puts("category: #{short_name}")
    f.puts("---")
  end
end
