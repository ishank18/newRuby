module MyModule
	def self.included klass
		def klass.chained_aliasing(meth, with)
			last_char = ""
			pvt_methods = self.private_instance_methods
			pro_methods = self.protected_instance_methods
			original_method = meth
			if(!(/\w/ =~ meth[meth.length-1]))
				last_char = meth[meth.length-1]
				original_method = meth[0...meth.length-1] 
			end
			with_meth = "#{original_method}_with_#{with}#{last_char}"
			without_meth = "#{original_method}_without_#{with}#{last_char}"
			alias_method without_meth, meth
			alias_method meth, with_meth
			if(pvt_methods.include?(meth))
				class_eval "private :#{meth}, :#{with_meth}, :#{without_meth}"
			elsif(pro_methods.include?(meth)) 
				class_eval "protected :#{meth}, :#{with_meth}, :#{without_meth}"
			else
			end	
		end
	end		 
end
class Hello
	include MyModule
	def greet(*args, &block)
		puts "Hello"
	end
	
	public :greet
	
end 
class InheritHello < Hello
	def greet_with_logger(*args, &block)
		puts '--logging start'
		greet_without_logger(*args, &block)
		puts "--logging end" 
	end
	chained_aliasing :greet, :logger	
end
h = InheritHello.new
h.greet
