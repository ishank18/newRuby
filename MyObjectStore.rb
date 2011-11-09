#### COMMENT - Implement the functionality with method_missing
#### disadvantages for this approach - ties our desired functionality with save method/ Also, once the method is defined, it still gets in the module logic,
#### cam be avoided with method_missing. Method will be invoked when called, doesn't go through method_missing logic again.

#### Handle non-enum methods for method_missing in the normal way for the class

module MyObjectStore
	def save
		if(self.class.instance_methods.include?(:validiate?)? validiate? : true)  #checks if the validate method exists
			self.class.instance_eval("@@var#{self.class} ||= []")
			self.class.instance_eval("@@var#{self.class}") << self

			self.class.instance_eval("@@ins#{self.class} ||= []")
			self.class.instance_eval("@@ins#{self.class} = #{self.instance_variables}") 
		else
			puts "Error :: Data is not validated!"
		end
	end

	module FindByMeths	
		def find_by_meths   #create dynamic find_by class methodsself.instance_variables
			MyObjectStore.class_variable_get("@@ins#{self}").each do |var_name|
				var_name = var_name.to_s.gsub(/@/, "")  
				
				class_eval "attr_accessor :#{var_name}"
				
				self.class.instance_eval do
					define_method("find_by_#{var_name}") do |val|  
					
					  ### COMMENT - Use select instead of iteration over array using each
					  
						found = false   #Checks if the object is found or not
				
						result = MyObjectStore.class_variable_get("@@var#{self}").select { |obj|
							class_eval("obj.#{var_name}.to_s == val.to_s")
						}
						if(result.length == 0)
							return "Object Not Found!"
						else
							return result	
						end		
					end	
				end	
			end
		end
		
		
		
		def method_missing(meth_name, *args, &block)   #works as a enumerator
			if(/find_by_/ =~ meth_name)
				find_by_meths
				class_eval("#{meth_name}(#{args[0]})")
			elsif MyObjectStore.class_variable_get("@@var#{self}").respond_to?("#{meth_name}")
				class_eval %{
					MyObjectStore.class_variable_get("@@var#{self}").#{meth_name} &block
				}
			else
				puts "Method Name #{meth_name} does not exists!"		 	
			end	
		end
	end
	
	
	
	def self.included klass  #Extends the module FindByMeths
		klass.extend FindByMeths
	end
end

class PerfectSquare
	include MyObjectStore
	def initialize(num)
		@num = num
		@age = 4
	end
	def validiate?
		Math.sqrt(@num).to_i.to_f == Math.sqrt(@num)	
	end
end

ps1 = PerfectSquare.new(9)
ps2 = PerfectSquare.new(4)
ps3 = PerfectSquare.new(4)
ps1.save
ps2.save
ps3.save
p PerfectSquare.find_by_num(4)
p PerfectSquare.count
PerfectSquare.sdf 
