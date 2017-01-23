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
