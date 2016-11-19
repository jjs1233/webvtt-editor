"""
@author:   smalt(jjs1233@163.com)

timestamp.rb
~~~~~~~~~~~~~~~~
"""
module WebVTT
	class Timestamp
	    #时间戳转换成秒
	    def self.parse_seconds( timestamp )
	      if mres = timestamp.match(/\A([0-9]{2}):([0-9]{2}):([0-9]{2}\.[0-9]{3})\z/)
	        sec = mres[3].to_f 
	        sec += mres[2].to_f * 60 
	        sec += mres[1].to_f * 60 * 60 
	      elsif mres = timestamp.match(/\A([0-9]{2}):([0-9]{2}\.[0-9]{3})\z/)
	        sec = mres[2].to_f 
	        sec += mres[1].to_f * 60
	      else
	        raise ArgumentError.new("Invalid WebVTT timestamp format: #{timestamp.inspect}")
	      end
	      return sec
	    end

	    def initialize( time )
	      if time.to_s =~ /^\d+([.]\d*)?$/
	        @timestamp = time
	      elsif time.is_a? String
	        @timestamp = Timestamp.parse_seconds( time )
	      else
	        raise ArgumentError.new("time not Fixnum nor a string")
	      end
	    end

	    #输出类型转换城string
	    def to_s
	      @timestamp.to_s
	    end

	    #小时分秒转换
	    def to_hms
	      hms_start
	      @hms = @round.reduce( [ @timestamp ] ) { |m,o|m.unshift(m.shift.divmod(o)).flatten }
	      @hms << (@timestamp.divmod(1).last * 1000).round
	      hms_result
	    end

	    #小时判断
	    def hms_start
	    	if @timestamp > 3600
			@round = Array.new 2,60
		else
			@round = Array.new 1,60
		end
	    end

	    #小时结果输出
	    def hms_result
	    	if @timestamp > 3600
			 sprintf("%02d:%02d:%02d.%03d", *@hms)
		else
			 sprintf("%02d:%02d.%03d", *@hms)
		end
	    end

	    #秒类型转换fixnum
	    def to_f
	      @timestamp.to_f
	    end

	    #秒向前滚动
	    def +(other)
	      Timestamp.new self.to_f + other.to_f
	    end

	end
end