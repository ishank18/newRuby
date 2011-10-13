class BusinessCenterHours
	def initialize(s, e)
		@start_everyday = s
		@end_everyday = e
		@diff_time = Array.new
		@no_bissn_days = Array.new
		@meetings = Array.new
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
	def meeting(day, s_time, duration)
		meeting_details = [day, s_time, duration]
		@meetings[@meetings.length] = meeting_details
	end
	def view
		p @diff_time
		p @no_bissn_days
		p @meetings
	end	
end
h = BusinessCenterHours.new("0900", "1500")
h.update "Jan 4, 2011", "0800", "1300"
h.update :sat, "1000", "1700"
h.meeting "Dec 25, 2011", "1200", "600"
h.meeting "Dec 28, 2011", "1200", "600"
h.closed :wed, :thu, "Dec 25, 2011"
h.closed "Dec 28, 2011"

h.view


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

