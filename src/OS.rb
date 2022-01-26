
# https://stackoverflow.com/a/171011/14874405

# OS specific stuff
module OS
	def OS.windows?
		(/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
	end

	def OS.mac?
		(/darwin/ =~ RUBY_PLATFORM) != nil
	end

	def OS.unix?
		!OS.windows?
	end

	def OS.linux?
		OS.unix? and not OS.mac?
	end

	def OS.jruby?
		RUBY_ENGINE == 'jruby'
	end

	# Project directories
	module Dirs
		def Dirs.config
			if OS.mac?
			  "#{Dir.home}/Library/Application Support/be.jonaseveraert.refs"
			elsif OS.linux?
			  "#{Dir.home}/.config/be.jonaseveraert.refs"
			elsif OS.windows?
			  "#{Dir.home}/AppData/Roaming/jonaseveraert/refs/config" # Needs testing if it works without \
			else
			  raise RuntimeError.new("Unimplemented for your operating system.")
			end
		end
	end
end
