require 'socket'
require './protocol.rb'

class Client 


	@id = nil
	@epoch_start = nil
	@tick_duration = nil
	@reference_frame = {
		:epoch_start => @epoch_start,
		:tick_duration => @tick_duration
	}


	def initialize(addr, port, tick_duration)
		_r = send_request(addr, port, Protocol::Request_GET_ID)
		@id = _r[0]
		@epoch_start = Time.now.to_i
		@tick_duration = tick_duration
		@reference_frame = {
			:epoch_start => @epoch_start,
			:tick_duration => @tick_duration
		}
	end

	def status
		puts "my id = #{@id}"
		puts "my reference_frame = #{@reference_frame}"
	end

	def tick
		# do something awesome here
	end

	private
	def parse_reply(reply)
		reply.split(";")
	end


	def send_request(addr, port, request)
		s = TCPSocket.open(addr, port)
		s.puts request
		_reply = s.gets
		s.close
		parse_reply(_reply)
	end


end