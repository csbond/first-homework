#!/use/bin/ruby
require 'net/http'
require 'yaml'  
require 'json'
class GetJson
	def run
		loop_num = 1 
		restful_api = YAML.load_file("a.yml")
		threads, jsons= [], []
		restful_api.each do |k, v| 
			v.each do |c, e|
				threads << Thread.new("#{loop_num}") do
					response = Net::HTTP.get(URI(e))
					filename = "/tmp/temp#{loop_num}.json"
					begin
						file = File.open(filename,"w") do |f|
							f.write(JSON.parse(response).to_json)
						end
						if file
							puts ">>>>>>>When the value equal to 0:" if loop_num == 1 
                                        		pri = JSON.parse(File.read(filename))
                                       		        pri.each do |p, d|
                                                		jsons[loop_num - 1] = pri
                                               			 puts "key: #{p},value: #{d}. from #{filename}" if d == 0 
                                        		end
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
