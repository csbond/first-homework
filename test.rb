#!/use/bin/ruby
require 'net/http'
require 'yaml'  
require 'json'
num = 1 
problem = YAML.load_file("a.yml")
threads, test = [], []
problem.each {|k, v| 
	v.each do |c, e|
		threads << Thread.new("#{num}") do
			response = Net::HTTP.get(URI(e))
			filename = "/tmp/temp#{num}.json"
			File.open(filename,"w") do |f|
				f.write(JSON.parse(response).to_json)
			end
			pri = JSON.parse(File.read(filename))
			pri.each do |p, d|
				test[num - 1] = pri 
				puts "key: #{p}. value: #{d}" if d == 0 
			end
			num = num + 1
		end
	end
}
threads.each { |t| t.join  }
puts "The all result:"
test.each do |k, v|
	puts "#{k},#{v}"
end
