def read_file(input_file)
	 input_file.split(".")[0].capitalize
	 $input_lines = IO.readlines(input_file) 
end

puts "Enter the name of file : "
input_file = gets.chomp 
FileTest.exists?(input_file)? read_file(input_file) : (puts("No Such File!"); exit;)

$regEx = /[\s\n]/
$method_name = $input_lines[0].gsub($regEx, "").split(",")

class_name = input_file.split(".")[0].capitalize

csv_class = Object.const_set(class_name, Class.new)

csv_class.class_eval do
	def initialize(input)
		input_array = input.gsub($regEx, "").split(",")
    
    ###### COMMENT - use each with index
    ###### COMMENT - dont use eval
		$method_name.each_with_index do |method_name, i|
			eval "@#{method_name} = '#{input_array[i]}'"
		end	
	end
	
	##### COMMENT - Refactored
	$method_name.each do |method_name|
		send(:attr_accessor, method_name.to_sym)
	end
			
end

obj_array = []
###### COMMENT - use each with index
$input_lines.each_with_index do |element, index|
	obj_array << csv_class.new(element) unless index == 0
end

p obj_array
