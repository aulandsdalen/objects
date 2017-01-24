unless defined?(Socket)
	require 'socket'
end

def windows? # on windows, we can't create filename w/ certain symbols, which are legal in unix
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
end

def synthesize_os_safe_filename
	if windows?
		"#{Time.now.to_s.tr(':', '-')}.txt"
	else
		"#{Time.now.to_s}.txt"
	end
end

def get_curr_ip
	 ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
end


def log(filename, string_to_log)
	logfile = File.new(filename, "a+")
	logfile.flock(File::LOCK_EX) # lock file to be sure that we're thread-safe here
	logfile.write("#{string_to_log}\n")
	logfile.close
	puts string_to_log
end