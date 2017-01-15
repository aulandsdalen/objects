require 'socket'


def parse_request(request, objects_list)
	request_array = request.split(";") # split request string based on \;\ delimiter
	requester_id = request_array[0] # format specifies either numeral id, or 'uninitialized'
	request_array.delete_at(0) # won't parse id later
	reply_array = [] # empty for now
	reply_string = ""
	if requester_id == 'uninitialized'
		request_array.each do |data|
			reply = case data
			when 'id' then Thread.current.object_id
			when 'time' then Time.now.to_i
			else 'unknown'
			end
			reply_array.push(reply)
		end
		objects_list.push(Thread.current.object_id.to_s)
	else
		if objects_list.include?(requester_id) # we should check do we have object registered
			reply_array.push("you're in the list")
		else
			reply_array.push("unknown")
		end
		reply_array.push(requester_id)
	end
	reply_array.each do |r|
		reply_string = reply_string + "#{r};"
	end
	reply_string
end 

addr = "0.0.0.0"
port = "5555"

s = TCPServer.new(addr, port)

puts "Started #{s} at #{addr}:#{port}"
objects_list = []

loop {
	Thread.start(s.accept) do |client|
		puts "spawned #{Thread.current.object_id}"
		puts "List of objects: #{objects_list}" # debug
		request = client.gets.chomp
		reply = parse_request(request, objects_list)
		client.puts reply
		puts "#{Thread.current.object_id} completed"
		client.close
	end
}
