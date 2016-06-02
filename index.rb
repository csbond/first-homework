#!/use/bin/ruby
require 'net/http'
require 'yaml'  
require 'json'
class GetJson
	def run
		loop_num = 1 
		restful_api = YAML.load_file("a.yml")
		threads, jsons= [], []
		restful_api.each {|k, v| 
			v.each do |c, e|
				threads << Thread.new("#{loop_num}") do
					response = Net::HTTP.get(URI(e))
					filename = "/tmp/temp#{loop_num}.json"
					File.open(filename,"w") do |f|
						f.write(JSON.parse(response).to_json)
					end
					puts ">>>>>>>When the value equal to 0:" if loop_num == 1 
					pri = JSON.parse(File.read(filename))
					pri.each do |p, d|
						jsons[loop_num - 1] = pri
						puts "key: #{p}. value: #{d}" if d == 0 
					end
					loop_num = loop_num + 1
				end
			end
		threads.each { |t| t.join  }
		puts ">>>>>>>The all json :"
		jsons.each do |k, v|
			puts "#{k},#{v}"
		end
		}
	end
end
GetJson.new.run
