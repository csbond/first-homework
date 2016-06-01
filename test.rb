#!/use/bin/ruby
require 'net/http'
require 'yaml'  
require 'json'
num = 1 
problem = YAML.load_file("a.yml")
threads = []
problem.each {|k, v| 
	v.each do |c, f|
		threads << Thread.new("#{num}") do
			response = Net::HTTP.get(URI(f))
			File.open(File.new( "temp#{num}.json","w"),"w") do |f|
				f.write(JSON.parse(response).to_json)
			end
			pri = JSON.parse(File.read("temp#{num}.json"))
			pri.each do |p, d|
				puts "key: #{p}. value: #{d}" if d == 0 
			end
			num = num + 1
		end
	end
}
threads.each { |t| t.join  }
