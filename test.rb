module CreateAccessor
	def setter_getter(name_of_var)
		define_method("#{name_of_var}=") do |val|
			eval "@#{name_of_var} = val" 
		end
		define_method("#{name_of_var}") do
			eval "@#{name_of_var}" 
		end
	end
end
class Test
	extend CreateAccessor
	setter_getter :a
	def initialize(a, b)
		@a = a
		@b = b
	end
	def sum
		puts @a + @b
	end
end
t = Test.new(2,6)
t.a = 4
puts t.a
t.sum
