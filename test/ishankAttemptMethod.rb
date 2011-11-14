## Ishank Gupta

module Attempt

	@@code = []
	["", "klass."].each do |k|
		@@code << %{
		def #{k}attempt(*args, &block)
				if(!args[0])
					block.call
				else		
					meth_name = args[0].to_sym
					args = args.slice(1...args.length)
					send meth_name, *args, &block
				end				
			end
			def #{k}method_missing(meth_name, *args, &block)
				return nil
			end
		}
	end	
	class_eval @@code[0]
	def self.included klass
		class_eval @@code[1]
	end	
end


class Article
	include Attempt
	def self.collect &block
		block.call
	end	
	def reverse obj
		p obj.reverse
	end
end


a = Article.new
a.attempt(:reverse, "abc")
Article.attempt {p "ishank"}
a.abc 
