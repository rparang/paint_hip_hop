module ApplicationHelper

	def to_dot_time(s)
		h = s / 3600
   		s -= h * 3600
		
		m = s / 60
		s -= m * 60

  		[h, m, s].join(":")
  	end
end
