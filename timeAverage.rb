require 'date'
class TimeAverage
	@@timeArray = []
	def addTimeToArray(t)
		puts "Time = "+t
		time = DateTime.strptime(t, "%H%M")
		@@timeArray[@@timeArray.length] = time
	end
	def calculateAverage
		minSum = 0
		hourSum = 0
		len = @@timeArray.length.to_f
		@@timeArray.each do |time|
			minSum += time.strftime("%M").to_i
			hourSum += time.strftime("%H").to_i
		end
		avgHour = hourSum/len
		fracHour = avgHour - avgHour.to_i
		minCarry = fracHour*60
		avgMin = (minSum/len) + minCarry
		if(avgHour.to_i < 10)
			strHour = "0"+avgHour.to_i.to_s
		else
			strHour = avgHour.to_i.to_s
		end
		if(avgMin.to_i < 10)
			strMin = "0" + avgMin.to_i.to_s
		else
			strMin = avgMin.to_i.to_s
		end		
		puts "Average Time = " + strHour + strMin
	end		
end
ta = TimeAverage.new
ta.addTimeToArray("1200")
ta.addTimeToArray("1333")
ta.addTimeToArray("1500")
ta.calculateAverage
