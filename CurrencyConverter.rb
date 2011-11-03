require 'xmlsimple'
require 'json'
class CurrencyConverter
  
	def initialize
		@item_price_list = XmlSimple.xml_in('itemPriceList.xml')
		@rate_of_conversion = JSON.parse(File.read('currencyRate.json'))
	end
	
	
	def showCurrConverRatio
		@rate_of_conversion.each do |r|
		  p "#{r[1]} / #{r[1]["den"]} = #{r[1]["ratio"]}"
			puts r[1]["num"] + "/" + r[1]["den"] + " = " + r[1]["ratio"].to_s
		end	
	end
	
	
	def showPriceTable
		@item_price_list["item"].each do |item|
			puts item["id"] + " -> " + item["unit"][0] + " - " + item["price"][0]
		end
	end
	
	
	def convertRate(item_no, currency)
		puts "{Converting Item No. #{item_no} to #{currency}}"
		
		@path = []
    item_currency = ""
    item_price = 0.0
				 
		@item_price_list["item"].each do |item|
			if(item_no.to_s == item["id"])
				item_currency = item["unit"][0]
				item_price = item["price"][0].to_f
			end	
		end
		
		num = ""
		den = ""
		ratio = 0.0
		output = 0.0
		
		@rate_of_conversion.each do |r|
			if(item_currency+"2"+currency == r[0] || currency+"2"+item_currency == r[0])
				num = r[1]["num"]
				ratio = r[1]["ratio"]
			end	
		end
		
    # use empty?
		if(num != "")
			output = outputCalc(num, currency, item_price, ratio)		
		else
			pathCalc(item_currency, currency)
			output = item_price
			@path.each do |index|
			  
			  s = @rate_of_conversion.select { |k,v| index == k}
        num, den, ratio = s[index]["num"], s[index]["den"], s[index]["ratio"].to_f
        
			  
        # @rate_of_conversion.each do |r|
        #   if(index == r[0])
        #     num = r[1]["num"]
        #     den = r[1]["den"]
        #     ratio = r[1]["ratio"]
        #   end 
        # end
        
				if(num == item_currency)
					item_currency = den
					output = output*ratio
				else
					item_currency = num
					output = output/ratio	
				end
			end	
		end
		puts "\nOutput = #{output}\n\n"	
	end
	
	
	def pathCalc(item_currency, currency)
		while(true)
			@rate_of_conversion.each do |r|
				if(item_currency == r[0].split("2")[0])
					@path[@path.length] = r[0]
					item_currency = r[0].split("2")[1]
				elsif(item_currency == r[0].split("2")[1])
					@path[@path.length] = r[0]
					item_currency = r[0].split("2")[0]
				else	
				end
			end
			if(item_currency == currency)
				break
			end
		end		
	end	
	
	
	def outputCalc(num, currency, item_price, ratio)
		if(num == currency)
			output = item_price/ratio
		else
			output = item_price*ratio	
		end
	end
end	

cc = CurrencyConverter.new
puts "\nPrice Table :- \n\n"
cc.showPriceTable
puts "\nConversion Rate :- \n\n" 
cc.showCurrConverRatio
puts ""
cc.convertRate(7, "AUD")
