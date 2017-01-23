require 'socket'


def parse_reply(reply)
	reply.split(";")
end


def send_request(addr, port, request)
	s = TCPSocket.open(addr, port)
	s.puts request
	reply = s.gets
	s.close
	parse_reply(reply)
end

addr = "0.0.0.0"
port = "5555"
id = 0

epoch_start = Time.now.to_i
tick_duration = 2

reference_frame = {
	:epoch_start => epoch_start,
	:tick_duration => tick_duration
}


puts "Starting at #{addr}:#{port}"

### initialize -- get ID from server ###

reply_array = send_request(addr, port, "uninitialized;id")
id = reply_array[0]

puts "received #{id}"


### clean up on exit ###

