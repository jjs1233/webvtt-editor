module WebVTT
	class Smalt
		attr_reader :header, :path, :filename
	    	attr_accessor :cues
		def initialize(f)
			@file = File.new(f,'a+')
			@path = f	
	      		@filename = File.basename(@path)
		  	parse
		end

		def parse
			content = File.read(@path)
	      		if content.nil? ||content.empty? 
	      			@output =  "WEBVTT"
	      			file_puts
	      		end
		      @content = File.read(@path).gsub("\r\n", "\n")
		      @content.gsub!("\uFEFF", '')
		      cues = @content.split("\n\n")
		      @header = cues.shift
		      header_lines = @header.split("\n").map(&:strip)
		      if (header_lines[0] =~ /^WEBVTT/).nil?
		        raise MalformedFile, "Not a valid WebVTT file"
		      end

		      @cues = []
		      cues.each do |cue|
		        cue_parsed = Cue.parse(cue.strip)
		        if !cue_parsed.text.nil?
		          @cues << cue_parsed
		        end
		      end
		      @cues
	    	end

	    	def to_webvtt
	     	 	[@header, @cues.map(&:to_webvtt)].flatten.join("\n\n")
	    	end

	    	def total_length
	      		@cues.last.end_in_sec
	    	end

	   	def actual_total_length
	      		@cues.last.end_in_sec - @cues.first.start_in_sec
	    	end

	    	def save(output=nil)
	      		output ||= @path.gsub(".srt", ".vtt")
	      		File.open(output, "w") do |f|
	        		f.write(to_webvtt)
	      		end
	      		return output
	    	end

		def add(*args)

			@file = File.open(@file,"a+")
			@lines = @file.readlines
			clear_carriage @lines[-1]

			if args.length == 3
				if time_ok?(args[0..1]).empty?
					input = ['',time_fix(args[0..1]),args[-1]].join("\n")
				else
					raise ArgumentError.new("the time you give is crossover")
				end
			elsif  args.length == 4
				if time_ok?(args[1..2]).empty?
					input = ['',args[0],time_fix(args[1..2]),args[-1]].join("\n")
				else
					raise ArgumentError.new("the time you give is crossover")
				end
			else
				raise ArgumentError.new("given #{args.length}, expected 3 or 4")
			end

			@output = input
			file_puts

		end

		def modify(*args)
			if args.length == 3
				time_fix_initialize args[0..1]
				@crossover = time_ok?(args[0..1]).first
				modify_work
			elsif  args.length == 4
				time_fix_initialize args[1..2]
				@crossover = time_ok?(args[1..2]).first
				modify_work
			end
		end

		def modify_work
			old_start = Regexp.new('([0-9]{2}:)?' << Timestamp.new(@crossover.start.to_f).to_hms.gsub('.','\.') )
			old_end =   Regexp.new('([0-9]{2}:)?' << Timestamp.new(@crossover.end.to_f).to_hms.gsub('.','\.') )
			@content.gsub!(old_start,@time[0])
			@content.gsub!(old_end,@time[1])
			p @output
		end

		def time_fix_initialize(args)
			@time = args.map do |time|
				Timestamp.new(time).to_hms
			end
		end

		def time_fix(args)
			time_fix_initialize args
			@time.join(" --> ")
		end

		def time_ok? (args)
			cues.reject{|cue,index| (cue.end.to_f > args[0].to_f && cue.start.to_f >args[1].to_f ) ||(cue.end.to_f < args[0].to_f && cue.start.to_f <args[1].to_f )}
		end

		def clear_carriage(line)
			if carriage? line
				@file.pos -= (line.length||= 0 + 1)
				@lines.pop
				clear_carriage @lines[-1]
			end
		end

		def carriage?(test)
			test =~ /^\s*$/ || test.nil?||test.empty?
		end

		def file_puts
			@file.puts(@output)
			@file.close
		end

	end
end