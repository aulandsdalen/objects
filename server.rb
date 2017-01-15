require 'socket'


def parse_request(request)
	reply = case request
		when 'id' then Thread.current.object_id
		when 'time' then Time.now.to_i
		else 'unknown'
	end
	reply
end 

addr = "0.0.0.0"
port = "5555"

s = TCPServer.new(addr, port)

puts "Started #{s} at #{addr}:#{port}"

loop {
	Thread.start(s.accept) do |client|
		puts "spawned #{Thread.current.object_id}"
		request = client.gets.chomp
		if request == 'uninitialized'
			request = client.gets.chomp
			client.puts parse_request(request)
		else
			while request != "end" do
				request = client.gets.chomp
				puts request
			end
		end
		puts "#{Thread.current.object_id} completed"
		client.close
	end
}
