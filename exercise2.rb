## The last bracket is missing is the result file

class CssCompressor
	def initialize(fn, opf)
		@file_name = fn
		@output_file = opf
	end	
	## Omit the paranthesis
	def compressStyle
		begin
			input_file = IO.read(@file_name)
			regEx = /(\s{1,})/
			input_file = input_file.gsub(regEx, " ")  #substitute all space, tabs, multiline with single space
			output_string = removeComment(input_file)  #calls remove comment method that will remove all the comments
			if(FileTest.exists?(@output_file))
				op_file = File.new(@output_file, "w")
				op_file.puts output_string	
				puts "\n#{@output_file} successfully overwritten!\n\n"
			else
				op_file = File.new(@output_file, "w")
				op_file.puts output_string
				puts "\n#{@output_file} successfully Created!\n\n"
			end	
			rescue => e
				puts "\nError Occured : #{e}\n\n"
			ensure
				op_file.close		
		end	
	end
	def removeComment(input_file)
		output_string = String.new()
		on_comment = false #boolean value which is true when the scanned string is in commented
		
		## Use ' i in [0..input_file-1]
		i = 0
		while i < input_file.length-1
			if(input_file[i] == "/" && input_file[i+1] == "*")
				on_comment = true
			end
			if(input_file[i] == "*" && input_file[i+1] == "/")
				on_comment = false
				i += 2
			end
			## you can write 'unless on_comment'
			unless on_comment # puts nothing in output_string when scanned string is commeted 
				output_string[output_string.length] = input_file[i]
			end
			i += 1
		end
		return output_string
	end		
end	

## Also check files names are non-blank here itself
print "Enter the input file name : "
input_file = gets.chomp
print "Enter the output file : "
output_file = gets.chomp
if(input_file != "" && output_file != "")
	if(FileTest.exists?(input_file)) #checkes whether the input and the output file exists
		if(FileTest.exists?(output_file))
			print "File named #{@output_file} already exist, do you want to overwrite (y) ? "
			prompt = gets.chomp
			if(prompt.to_s.downcase == 'y')
				c = CssCompressor.new(input_file, output_file) 
				c.compressStyle
			else
				puts "\nNothing Effected\n\n"
			end
		else
			c = CssCompressor.new(input_file, output_file) 
			c.compressStyle
		end	
	else
		puts "\n#{input_file} - Does not exists\n\n"
	end		
else
	puts "Filenames can not be empty"	
end

