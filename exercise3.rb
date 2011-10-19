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
		p @diff_time
	end	
	
	def closed(*args)
		args.each do |day|
			@no_bissn_days[@no_bissn_days.length] = day
		end	
		p @no_bissn_days
	end
	
	def calculate_deadline(duration, day)
		meeting_possible = 1
		
		## COMMENT - Use DateTime.strptime
		mon_day_year = day.split(" ")
		
		m_date = mon_day_year[0] + " " + mon_day_year[1] + " " + mon_day_year[2]
		p m_date
		re = /\,/
		
		mon_day_year[1] = mon_day_year[1].sub(re, "")
		p mon_day_year[1]
		
		
		i = 0
		while i < 12
			if(mon_day_year[0] == @months[i])
				break
			end
			i += 1
		end
		
		
		m_month = i+1
		m_day = mon_day_year[1].to_i
		m_year = mon_day_year[2].to_i		
		
		meeting_date = Time.new(m_year, m_month, m_day)
		
		
		m_day_name = @weekdays[meeting_date.wday]
		
		@no_bissn_days.each do |hld| #checks if the meeting date is not a holiday
			if(m_day_name == hld || m_date == hld)
				puts "#{day} is a holiday, We can not schedule meeting in a Holiday"
				meeting_possible = 0
			end	
		end
		
		m_day_start_time = @start_everyday.to_i
		m_day_end_time = @end_everyday.to_i				
		m_time = mon_day_year[3].to_i
		@diff_time.each do |dt| # finds the starting and end time of the day
			if(dt[0] == m_date || dt[0] == m_day_name)
				m_day_start_time = dt[1].to_i
				m_day_end_time = dt[2].to_i
			end		
		end
		unless m_time > m_day_start_time && m_time < m_day_end_time
			puts "On #{m_date} timing of the office is only from #{m_day_start_time} to #{m_day_end_time}"
			meeting_possible = 0
		end
		
		## COMMENT - Use DateTime's inbuilt functions to convert 12 hour clock to 24 hour clock, comparing times
		
		if(meeting_possible == 1) #executes only if the meeting is possible
			day_end_hour = m_day_end_time/100 #variables which extracts the hours and minutes from the 24 hour time format
			day_end_min = m_day_end_time - (day_end_hour*100)
			m_start_hour = m_time/100
			m_start_min = m_time - (m_start_hour*100)	
			d_hour = duration/(60.0*60.0)
			
			## COMMENT - Use in-built Ruby fuctions for float, integer manipulation
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
				puts "#{m_day_name} #{mon_day_year[0]} #{mon_day_year[1]} #{m_end_hour}:#{m_end_min}:#{duration/(60*60*60)} #{mon_day_year[2]}"
			else
				while(true) #find the day when there is no holiday
					meeting_date = meeting_date + 24*60*60
					next_day = @months[meeting_date.month - 1] + " " + meeting_date.day.to_s + ", " + meeting_date.year.to_s
					h = false
					@no_bissn_days.each do |hld|
						if(@weekdays[meeting_date.wday] == hld || next_day == hld)
							h = true
						end	
					end
					
					#### COMMENT - Can be written as unless h
					if(h == false)
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
end
h = BusinessCenterHours.new("0900", "1500")
h.update "Jan 4, 2011", "0800", "1300"
h.update :sat, "1000", "1700"
h.closed :wed, :thr, "Dec 25, 2011"
# h.closed "Dec 28, 2011"
h.calculate_deadline(7*60*60, "Dec 24, 2011 1200")

