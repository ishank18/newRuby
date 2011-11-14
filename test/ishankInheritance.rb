module MyAttrAccessor
	def my_attr_accessor *args
		args.each do |var_name|
			self.instance_eval %{
				def #{var_name}= val
					return if @var_set
					@var_set = true
					temp = self.#{var_name}
					@#{var_name} = val
					classHirarchy = self.class_variable_get("@@classHirarchy")

					classHirarchy[classHirarchy.find_index(self)..(classHirarchy.length)].each do |v|
						if(temp == v.#{var_name})
							v.#{var_name} = val
						end	
					end	
					@var_set = false
				end
				def #{var_name}
					return @#{var_name} if @var_set
					@var_set = true
					temp = self.#{var_name}
					classHirarchy = self.class_variable_get("@@classHirarchy")
					classHirarchy[classHirarchy.find_index(self)..(classHirarchy.length)].each do |v|
						if(temp == v.#{var_name})
							v.#{var_name} = temp
						end	
					end
					@var_set = false
					return @#{var_name}
				end
			}
		end
	end
end

class A
	extend MyAttrAccessor
	@@classHirarchy = [self]
	def self.inherited(base)
		@@classHirarchy << base
		class_eval %{
			if(#{self}.a.class.to_s != "Fixnum")
				#{base}.a = #{self}.a.dup
				#{base}.b = #{self}.b.dup
			else
				#{base}.a = #{self}.a
				#{base}.b = #{self}.b
			end
		}
	end
	def self.carry_over_attribute(a, b)
		@a = a
		@b = a
	end
	carry_over_attribute(5, 2)
	my_attr_accessor :a, :b
end
class B < A

end
class C < B

end
class D < C

end
class E < D

end
class F < E
	
end


E.a = 7
B.a = 3

p A.a 
p B.a
p C.a
p D.a
p E.a
p F.a




