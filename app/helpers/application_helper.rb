module ApplicationHelper

	def to_dot_time(s)
		h = s / 3600
   		s -= h * 3600
		
		m = s / 60
		s -= m * 60

  		[h, m, s].join(":")
  	end

	def pageless(total_pages, url=nil, container=nil)
	    opts = {
	      :totalPages => total_pages,
	      :url        => url,
	      :loaderMsg  => 'Loading...'
	    }
	    
	    container && opts[:container] ||= container
	    
	    javascript_tag("$('#results').pageless(#{opts.to_json});")
	end


end
