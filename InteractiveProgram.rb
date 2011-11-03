### You can collect user inout in a string on the very first go, dont need an array
prog_array = [""] #Array that will take input

while(prog_array[prog_array.length - 1].chomp != "q")
	prog_array[prog_array.length] = gets
end

prog_array.pop
prog_string = ""

prog_array.each do |str|  #Converts the array into string
	prog_string += str
end

puts "\n\nOutput of program is : \n\n"

eval prog_string 

puts "\n"
