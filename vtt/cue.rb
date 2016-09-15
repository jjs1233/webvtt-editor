module WebVTT
	class Cue
	    attr_accessor :identifier, :start, :end, :style, :text

	    def initialize(cue = nil)
	      @content = cue
	      @style = {}
	    end

	    #读取内容
	    def self.parse(cue)	    	
	      cue = Cue.new(cue)
	      cue.parse
	      return cue
	    end

	    #把文字内容写入
	    def to_webvtt
	      res = ""
	      if @identifier
	        res << "#{@identifier}\n"
	      end
	      res << "#{@content}".strip 
	      res
	    end

	    #时间戳转换成秒
	    def self.timestamp_in_sec(timestamp)
	      mres = timestamp.match(/([0-9]{2}):([0-9]{2}):([0-9]{2}\.[0-9]{3})/)
	      sec = mres[3].to_f # 秒
	      sec += mres[2].to_f * 60 #分
	      sec += mres[1].to_f * 60 * 60 #小时
	      return sec
	    end

	    #开始时间转换成fixnum类型
	    def start_in_sec
	      @start.to_f
	    end

	    #结束时间转换成fixnum类型
	    def end_in_sec
	      @end.to_f
	    end

	    #持续时间
	    def length
	      @end.to_f - @start.to_f
	    end

	   #时间添加
	    def offset_by( offset_secs )
	      @start += offset_secs
	      @end   += offset_secs
	    end

	    #切割文字内容 把文字内容二次加工
	    def parse
	      lines = @content.split("\n").map(&:strip)
	      return if lines[0] =~ /NOTE/

	      if !lines[0].include?("-->")
	        @identifier = lines[0]
	        lines.shift
	      end

	      if lines.empty?
	        return
	      end

	      if lines[0].match(/(([0-9]{2}:)?[0-9]{2}:[0-9]{2}\.[0-9]{3}) -+> (([0-9]{2}:)?[0-9]{2}:[0-9]{2}\.[0-9]{3})(.*)/)
	        @start = Timestamp.new $1
	        @end = Timestamp.new $3
	        @style = Hash[$5.strip.split(" ").map{|s| s.split(":").map(&:strip) }]
	      end
	      @text = lines[1..-1].join("\n")
	    end
	  end
end