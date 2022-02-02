#!/usr/bin/ruby

# This script will install the cli to /usr/local/bin on unix
# and \Windows\System32 on Windows (needs testing)

require_relative('./src/OS.rb')

puts "If you haven't put this folder your desired location yet, please stop the process using ⌃C (CONTROL+C). Installing in 5 seconds..."
sleep 5

cli_dir = File.expand_path("src/cli.rb")
if OS.unix?
    Dir.chdir("/usr/local/bin") do
        system "ln -s #{cli_dir} refs"
    end
    puts "Succesfully installed CLI. You can now call it from any terminal using \"refs\""
elsif OS.windows?
    Dir.chdir("/Windows/System32") do
        system "mklink refs #{cli_dir.gsub('/', '\\')}"
    end
    puts "Succesfully installed CLI. You can now call it from the command line using \"refs\"" 
else
    puts "Your operating system is not supported, please install the CLI manually."
    puts "If you are running Linux, MacOS or Windows, please open a new issue"
end

print "Do you also want to install the template engine? (y/n) "
answer = gets 
if answer.match("y")
    cli_dir = File.expand_path("template-engine/src/engine.rb")
    if OS.unix?
        Dir.chdir("/usr/local/bin") do
            system "ln -s #{cli_dir} refst"
        end
    else
        Dir.chdir("/usr/local/bin") do
            system "mklink refst #{cli_dir.gsub('/', '\\')}"
        end
    end
end