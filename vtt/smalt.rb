module WebVTT
	class Smalt
		attr_reader :header, :path, :filename,:cues,:new,:old
	    	attr_accessor :cue_parsed
		def initialize(f)
			@file = File.new(f,'a+')
			@path = f	
	      		@filename = File.basename(@path)
		  	parse
		end

		#初始化 读取文件信息 把文件内容写入cue 文件地址写入path 文件名写入filename
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
	    	end

	    	#删除字幕
		def delete(*args)
			if @cues.reject! do |cue|
					cue.start.to_f == args[0] && cue.end.to_f == args[1]
				end
			else
				raise ArgumentError.new("This time does not exist or The arguments you give wrong")
			end
			save
		end

		#插入字幕
		def insert(*args)
			@start = args[0]
			@end = args[1]
			if time_check.empty?
				@new = Cue.parse([time_fix,args[-1]].join("\n").strip)
				i = -1
				begin
					i += 1
				end while !@cues[i].nil?&&@new.start.to_f > @cues[i].start.to_f 
				modify(i)
				save
			else
				raise ArgumentError.new("The arguments you give wrong or This period of time in the file already exists")
			end
		end

		#文件输出 写入内容后输出文件
	    	def save(output=nil)
	      		output ||= @path.gsub(".srt", ".vtt")
	      		File.open(output, "w") do |f|
	        		f.write(to_webvtt)
	      		end
	      		return output
	    	end

	    	#整合把cue内容转换成文件需要的内容
	    	def to_webvtt
	     	 	[@header, @cues.map(&:to_webvtt)].flatten.join("\n\n") << "\n"
	    	end

	    	#结束时间
	    	def total_length
	      		@cues.last.end_in_sec
	    	end

	    	#字幕持续时间
	   	def actual_total_length
	      		@cues.last.end_in_sec - @cues.first.start_in_sec
	    	end

		#把时间经行加工 混合
		def time_fix
			@time = [@start,@end].map do |time|
				Timestamp.new(time).to_hms
			end
			@time.join(" --> ")
		end

		#判断时间格式是否正确
		def time_check
			if @end.to_f > @start.to_f 
				@cues.reject do|cue| 
					(cue.end.to_f >@start.to_f && cue.start.to_f > @end.to_f ) ||(cue.end.to_f < @start.to_f && cue.start.to_f < @end.to_f )
				end
			else
				raise ArgumentError.new("The arguments you give wrong or End time must be greater than the Start")
			end
		end

		#文件内容保存
		def file_puts
			@file.puts(@output)
			@file.close
		end

		#把新字幕写入cue
		def modify(a,b = 0)
			@cues[a,b] = @new
		end

	end
end