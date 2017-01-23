require 'socket'
require './abstract.rb'

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
			else 'unknown'
			end
			reply_array.push(reply)
		end
		objects_list.push(Thread.current.object_id.to_s)
	else
		if objects_list.include?(requester_id) # we should check do we have object registered
			request_array.each_with_index do |data, i|
				case data
				when 'delete'
					objects_list.delete(requester_id)
					reply_array.push("deleted")
				when 'log'
					log_message = request_array[i+1]
					puts "[log] #{log_message}"
					reply_array.push("log_ok")
				when 'time'
					reply_array.push(Time.now.to_i)
				end
			end
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

def log(filename, string_to_log)
	logfile = File.new(filename, "a+")
	logfile.flock(File::LOCK_EX) # lock file to be sure that we're thread-safe here
	logfile.write("#{string_to_log}\n")
	logfile.close
	puts string_to_log
end

trap "SIGINT" do  # write epoch_end to file
	epoch_end = Time.now.to_i
	puts "\nepoch_end is #{epoch_end}, exiting..."
	exit 130
end


addr = "0.0.0.0"
port = "5555"

s = TCPServer.new(addr, port)

puts "Started #{s} at #{addr}:#{port}"
objects_list = []
tick_count = 0
filename = synthesize_os_safe_filename # use current time as filename
epoch_start = Time.now.to_i
tick_duration = 1 # CHANGE ME 
reference_frame = {
	:epoch_start => epoch_start,
	:tick_duration => tick_duration
}

log(filename, "Starting with #{reference_frame}")
log(filename, get_curr_ip)

#puts "Starting with #{reference_frame}"

l = Thread.new {
	loop {
		tick_count += 1
		#puts "tick # #{tick_count}: #{objects_list}"
		log(filename, "tick # #{tick_count}: #{objects_list}")
		sleep tick_duration
	}
}

loop {
	Thread.start(s.accept) do |client|
		puts "spawned #{Thread.current.object_id}"
		puts "List of objects: #{objects_list}" # debug
		request = client.gets.chomp
		reply = parse_request(request, objects_list)
		client.puts reply
		puts "Request from #{Thread.current.object_id} completed"
		client.close
	end
}