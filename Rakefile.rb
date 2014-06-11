require 'colorize'

def rtask(*tasks)
  tasks.each { |task| Rake::Task[task].invoke }
end

# Show subprocess output through console
def rshell(*commands)
  commands.each do |cmd|
    puts cmd
    IO.popen(cmd, "r+") do |io|
      while line = io.gets
        line.chomp!
        puts line.blue
      end
    end
  end
end

namespace :ssh do
  desc "Enable agent forwarding"
  task :eaf do
    puts 'Enabling agent forwarding..'.green
    rshell 'ssh-add ~/.ssh/id_rsa'
  end
  desc "Add ssh tmp resources folder"
  task :add do
    puts 'Adding ssh tmp resources..'.green
    rshell 'mkdir -p tmp',
           'cp -f ~/.ssh/id_rsa.pub tmp/id_rsa.pub',
           'cp -f ~/.ssh/known_hosts tmp/known_hosts'
  end
  desc "Remove ssh tmp resources folder"
  task :del do
    puts 'Removing ssh tmp resources..'.green
    rshell 'rm -rf tmp'
  end
end

namespace :vagrant do
  task :before_run do
    puts 'Before command'.green.underline
    rtask "ssh:eaf", "ssh:add"
  end
  task :run, [:cmd] => [:before_run] do |t, args|
    puts "Running vagrant command..".green.underline
    command = args[:cmd] || "up"
    rshell "vagrant #{command}"
  end
  task :after_run, [:cmd] => [:run] do
    puts 'After command'.green.underline
    rtask "ssh:del"
  end
end

task :vagrant, [:cmd] => ["vagrant:after_run"] do
  rtask "after_run"
end
