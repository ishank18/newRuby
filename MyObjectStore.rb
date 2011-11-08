module MyObjectStore
	def save
		if(self.class.instance_methods.include?(:validiate?)? validiate? : true)  #checks if the validate method exists
			self.class.instance_eval("@@var#{self.class} ||= []")
			self.class.instance_eval("@@var#{self.class}") << self
		else
			puts "Error :: Data is not validated!"
		end
		self.class.setInstances self.instance_variables  #calls the setInstances method in each save
	end
	
	module FindByMeths
		def setInstances args  #sets the instance variable in a class variables named ins{ClassName}
			class_eval %{
				@@ins#{self} ||= []
				if(@@ins#{self}.length == 0)  #checks if the instance variables of the class exists
					@@ins#{self} = args
					find_by_meths
				end
			}
		end
		def find_by_meths   #create dynamic find_by class methods
			class_variable_get("@@ins#{self}").each do |var_name|
				var_name = var_name.to_s.gsub(/@/, "")  
				class_eval "attr_accessor :#{var_name}"
				self.class.instance_eval do
					define_method("find_by_#{var_name}") do |val|  
						found = false   #Checks if the object is found or not
						MyObjectStore.class_variable_get("@@var#{self}").each do |obj|
							class_eval %{
								if(obj.#{var_name}.to_s == val.to_s) 
									p obj
									found = true
								end
							}
						end
						if(!found)
							puts "Object Not Found!"
						end		
					end	
				end	
			end
		end
		def method_missing(meth_name, *args, &block)   #works as a enumerator
			class_eval %{
				MyObjectStore.class_variable_get("@@var#{self}").#{meth_name} &block
			}
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
		@hi = 3
		Math.sqrt(@num).to_i.to_f == Math.sqrt(@num)
		
	end
	
end

ps1 = PerfectSquare.new(9)
ps2 = PerfectSquare.new(4)
ps3 = PerfectSquare.new(16)
ps1.save
ps2.save
ps3.save
PerfectSquare.find_by_num(4)
p PerfectSquare.count 
