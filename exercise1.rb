##### COMMENT - Please dont use class variables unless required!!!! 

=begin
Shopping Cart

Implement a billing system for shopping complex. The shopping complex has pre-decided rates for all items on the display, however, they offer promotion for certain products from time to time. For example, they might say, "Price of Item X is Rs 400, Buy three and the total price would be 1000"

Every Item should be identified using a unique number.
Also, we should be able to pass a set of pricing rules to our system, we would list price of each item and special offers on it. Rules can be in JSON format.

The billing should be able accept items in any order. So bill can have 1 X, followed by 1 Y, followed by 2 X.
The system should scan items in this fashion and calculate the total after every entry.
Implement it using object oriented principles 
=end


class ShoppingCart
	@@price_table = Hash.new
	@@order = Hash.new

	def initialize(n)
		@num_item = n
	end

	def setUnitPrice(item_code, p)   #Set Initial price of a item
			price_of_item = Hash.new
			price_of_item[1] = p
			@@price_table[item_code] =  price_of_item
	end

	def setOffer(item_code, q, p)  #Set offer in any existing item
		offer = @@price_table[item_code];
		offer[q] = p
		@@price_table[item_code] = offer
		
	end

	def setOrder(item_code, q)  #Sets order of item
		## Dont need to check '!= nil' 
		if(@@order[item_code] != nil)
			@@order[item_code] = @@order[item_code] + q
		else
			@@order[item_code] = q
		end	
	end

	def calculatePrice   # Calculates the Amount
		puts "\nPrice Details : #{@@price_table}"
		puts "Order Details : #{@@order}\n\n"
		order_item_codes = @@order.keys
		amount = 0
		order_item_codes.each do |item_code|
			item_quantity = @@order[item_code]  # Quantity of items in Order
			item_qnty_price = @@price_table[item_code]  # Stores the unit and offer price in array
			item_qnty = item_qnty_price.keys.sort.reverse  # Sorts the offer in descending order
			i = 0
			#### COMMENT - Iterate over array - not index
			while item_quantity > 0 && i < item_qnty.length
				while(item_quantity >= item_qnty[i])
					item_quantity -= item_qnty[i]
					amount = amount + item_qnty_price[item_qnty[i]]
				end	
				i += 1
			end	
		end	
		puts "Total sum - #{amount}\n\n"
	end
end

sc = ShoppingCart.new(3)

sc.setUnitPrice(1, 50)
sc.setUnitPrice(2, 40)
sc.setUnitPrice(3, 30)

sc.setOffer(1, 2, 80)
sc.setOffer(3, 2, 50)

sc.setOrder(1, 3)
sc.setOrder(2, 3)
sc.setOrder(3, 3)
sc.setOrder(3, 1)

sc.calculatePrice
