class StringSub < String
	def initialize(input)
		@input = input
	end	
	def pallindrome?
		(@input.downcase == @input.reverse.downcase)? true: false
	end
	def say_hello
		"Hi from #{@input}"
	end	
end
print "Enter the String : "
input = gets.chomp
print "Enter the name of method : "
name_of_method = gets.chomp
ss = StringSub.new(input)
output = eval "ss.#{name_of_method}"
puts output
