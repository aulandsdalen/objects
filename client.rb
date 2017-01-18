require 'socket'

addr = "0.0.0.0"
port = "5555"

epoch_start = Time.now.to_i
tick_duration = 2

reference_frame = {
	:epoch_start => epoch_start,
	:tick_duration => tick_duration
}