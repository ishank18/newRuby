=begin ##First Method
class NewMethod	
	def self.new_method(name_of_method, code)
		define_method(name_of_method) do
			eval(code)
		end
	end
end
=end
puts "Enter the method name :: "
$name_of_method = gets.chomp
puts "\nEnter a one line code :: "
$code = gets.chomp
class << self
	define_method($name_of_method) do
		eval($code)
	end
end
eval("#{$name_of_method}")
