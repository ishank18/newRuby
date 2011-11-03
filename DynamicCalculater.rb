## use send, eval is not safe
def calculate a, sign, b
	eval "a #{sign} b"
end
puts calculate 3, :+, 2
