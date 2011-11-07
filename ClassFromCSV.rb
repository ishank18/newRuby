def read_file(input_file)
	 input_file.split(".")[0].capitalize
	 $input_lines = IO.readlines(input_file) 
end

puts "Enter the name of file : "
input_file = gets.chomp 
FileTest.exists?(input_file)? read_file(input_file) : puts("No Such File!"); exit;

$regEx = /[\s\n]/ 
$method_name = $input_lines[0].gsub($regEx, "").split(",")

class_name = input_file.split(".")[0].capitalize

csv_class = Object.const_set(class_name, Class.new)
csv_class.class_eval do
	def initialize(input)
		input_array = input.gsub($regEx, "").split(",")
		i = 0
		$method_name.each do |method_name|
			eval "@#{method_name} = '#{input_array[i]}'"
			i += 1
		end	
	end
	$method_name.each do |method_name|
		eval "attr_accessor :#{method_name}"
	end		
end

obj_array = []
for i in 1...$input_lines.length
	obj_array << csv_class.new($input_lines[i])
end
p obj_array
