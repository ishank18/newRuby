## GENERAL COMMENTS - 
# 1. Schedule meeting next day if the user specified day is a holiday, or the user specified time is past working hours of the business center


=begin
Day Scheduling -
We have schedule appointments for a Business Center.
We should be able to specify the start and end timings for the Business Center for everyday.
h = BusinessCenterHours.new("0900", "1500")

We should be able to individually modify a particular day's start and end time.
h.update "Jan 4, 2011", "0800", "1300"
h.update :sat, "1000", "1700"

We should be able to mark a particular day as no-business day, ie handle situation where the business center is closed.
h.closed :wed, :thu, "Dec 25, 2011"

We should be able to schedule meeting for clients, who specify their preferred day, start-time and meeting duration (in secs)

h.calculate_deadline(7*60*60, "Dec 24, 2011 1845") # => Mon Dec 27 11:00:00 2010
Here, 7 hours (25200 seconds) which starts before opening on Dec 24th. There are only 5 business hours on Dec 24th which leaves 2 hours remaining for the next business day. The next two days are closed (Dec 25th and Sunday) therefore the deadline is not until 2 hours after opening on Dec 27th.

Implement it using object oriented principles 
=end


require 'date'
class BusinessCenterHours
	def initialize(s, e)
		@start_everyday = s
		@end_everyday = e
		@diff_time = []
		@no_bissn_days = [:sun]
		@meetings = Array.new
    ## COMMENT - Common to every object. Make this class variable.
		@weekdays = [:sun, :mon, :tue, :wed, :thr, :fri, :sat]
		@months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	end
	def update(day, s_time, e_time)
		u_day = [day, s_time, e_time]
		@diff_time[@diff_time.length] = u_day
	end	
	def closed(*args)
		args.each do |day|
			@no_bissn_days[@no_bissn_days.length] = day
		end	
	end
	def calculate_deadline(duration, day)
		## COMMENT - Use DateTime.strptime	
		meeting_date = DateTime.strptime(day, "%b %d, 20%y %H%M")
		m_day_name = @weekdays[meeting_date.wday]
		@no_bissn_days.each do |hld| #checks if the meeting date is not a holiday
			if(m_day_name == hld || meeting_date.strftime("%b %d, 20%y") == hld)
				meeting_date = meeting_date + 1
			end	
		end
		m_day_start_time = @start_everyday.to_i
		m_day_end_time = @end_everyday.to_i				
		m_time = meeting_date.strftime("%H%M").to_i
		@diff_time.each do |dt| # finds the starting and end time of the day
			if(dt[0] == meeting_date.strftime("%b %d, 20%y") || dt[0] == m_day_name)
				m_day_start_time = DateTime.strptime(dt[1], "%H%M")
				m_day_end_time = DateTime.strptime(dt[2], "%H%M")
			end		
		end
		unless m_time > m_day_start_time.strftime("%H%M").to_i && m_time < m_day_end_time.strftime("%H%M").to_i
			meeting_date = meeting_date + 1
		end
		## COMMENT - Use DateTime's inbuilt functions to convert 12 hour clock to 24 hour clock, comparing time
		day_end_hour = m_day_end_time.strftime("%H").to_i #variables which extracts the hours and minutes from the 24 hour time format
		day_end_min = m_day_end_time.strftime("%M").to_i
		m_start_hour = meeting_date.strftime("%H").to_i
		m_start_min = meeting_date.strftime("%M").to_i	
		d_hour = duration/(60.0*60.0)
		## COMMENT - Use in-built Ruby fuctions for float, integer manipulation
		## I tried this but I was not able to find the name of the function...please let me know the function name...
		d_min_ratio = d_hour - d_hour.to_i
		d_hour = d_hour.to_i
		d_min = (d_min_ratio*60).to_i
		m_end_min = d_min + m_start_min
		carry_to_hour = m_end_min / 60
		m_end_hour = d_hour + m_start_hour + carry_to_hour
		carry_day = 0
		if(m_end_hour > day_end_hour) #Checks whether the end time of the meeting is greated than days end time
			d_min = m_end_min - day_end_min
			d_hour = m_end_hour - day_end_hour
			if(d_min < 0)
				d_min += 60
				d_hour -= 1
			end
			carry_day = 1
		elsif(m_end_hour == day_end_hour) #Checks if the hours are equal and minutes are greater
			if(m_end_min > day_end_min)
				d_min = m_end_min - day_end_min
				d_hour = 0
				carry_day = 1
			end
		else	
			carry_day = 0
		end
		if (carry_day == 0)
			puts "#{m_day_name} #{meeting_date.strftime("%b")} #{meeting_date.strftime("%d")} #{m_end_hour}:#{m_end_min}:#{duration/(60*60*60)} #{meeting_date.strftime("20%y")}"
		else
			while(true) #find the day when there is no holiday
				meeting_date = meeting_date + 1
				next_day = @months[meeting_date.month - 1] + " " + meeting_date.day.to_s + ", " + meeting_date.year.to_s
				h = false
				@no_bissn_days.each do |hld|
					if(@weekdays[meeting_date.wday] == hld || next_day == hld)
						h = true
					end	
				end
				#### COMMENT - Can be written as unless h
				unless(h)
					break
				end
			end
			m_day_start_time = @start_everyday.to_i
			m_day_end_time = @end_everyday.to_i				
			@diff_time.each do |dt| #finds the starting and end time of the day
				if(dt[0] == @weekdays[meeting_date.wday] || dt[0] == next_day)
					m_day_start_time = dt[1].to_i
					m_day_end_time = dt[2].to_i
				end		
			end
			day_start_hour = m_day_start_time/100
			day_start_min = m_day_start_time - (day_start_hour*100)
			m_end_min = d_min + day_start_min
			carry_to_hour = m_end_min / 60
			m_end_hour = d_hour + day_start_hour + carry_to_hour
			puts "#{@weekdays[meeting_date.wday]} #{@months[meeting_date.month - 1]} #{meeting_date.day} #{m_end_hour}:#{m_end_min}:#{(duration/(60*60*60)).to_i} #{meeting_date.year}"
		end	
	end	
end
h = BusinessCenterHours.new("0900", "1500")
h.update "Jan 4, 2011", "0800", "1300"
h.update :sat, "1000", "1700"
h.closed :wed, :thr, "Dec 24, 2011", "Dec 25, 2011"
h.closed "Dec 28, 2011"
h.closed "Dec 28, 2011"
h.calculate_deadline(7*60*60, "Dec 24, 2011 1200")
