#!/usr/bin/env ruby
# a script to find the biggest directory recursively to identify heavy disk space usage
#

# find the biggest directory in the current directory and return it's name
def biggest()
    @size = 0
    @name = ""

    # this is faster than doing it in Ruby
    this_dir = `du -x --max-depth 1`
    # break into lines
    dir_lines = this_dir.split("\n")
    # break into size/name pair
    dir_lines.each do |y|
        s,n = y.split("./")
        s = s.to_i
        # avoid current directory. only look at subs
        if n
            if (s > @size)
                @size = s
                @name = n
            end
        end
    end
return @name
end

result = biggest()
puts "largest directory is #{result}"
Dir.chdir("./#{result}")

result2 = biggest()
puts "largest directory is now #{result2}"
Dir.chdir("./#{result2}")
