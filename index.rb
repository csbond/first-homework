#!/use/bin/ruby
require 'net/http'
require 'yaml'  
require 'json'
class GetJson
	def get_response(api)
		return Net::HTTP.get(URI(api))
	end
	def open_file(filename, response)
		file = File.open(filename,"w") do |f|
                	 f.write(JSON.parse(response).to_json)
		end
		return file
	end
	def read_file(filename, loop_num, jsons)
		pri = JSON.parse(File.read(filename))
                pri.each do |p, d|
                	jsons[loop_num - 1] = pri
                	puts "key: #{p},value: #{d}. from #{filename}" if d == 0 
                end
		return jsons 
	end	
	def run
		loop_num = 1 
		restful_api = YAML.load_file("a.yml")
		threads, jsons= [], []
		restful_api.each do |k, v| 
			v.each do |c, e|
				threads << Thread.new("#{loop_num}") do
					response = get_response(e)
					filename = "/tmp/temp#{loop_num}.json"
					begin
						file = open_file(filename, response)
						if file
							puts ">>>>>>>When the value equal to 0:" if loop_num == 1 
                                        		jsons = read_file(filename, loop_num, jsons) 
							puts ">>>>>>>The all data :" if loop_num == 3 
                                       		        loop_num = loop_num + 1
						end
					rescue
						puts "file open error"
					end
				end
			end
			begin
				if threads 
					threads.each { |t| t.join }
					jsons.each do |k|
						puts k 
					end	
				end
			rescue
				puts "thread new error"
			end
		end
	end
end
GetJson.new.run
