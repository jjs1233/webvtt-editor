module WebVTT
	class File
	    attr_reader :header, :path, :filename
	    attr_accessor :cues
	    def initialize(webvtt_file)
	      if !::File.exists?(webvtt_file)
	        raise InputError, "WebVTT file not found"
	      end

	      @path = webvtt_file
	      @filename = ::File.basename(@path)
	      @content = ::File.read(webvtt_file).gsub("\r\n", "\n") # normalizing new line character
	      parse
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

	      ::File.open(output, "w") do |f|
	        f.write(to_webvtt)
	      end
	      return output
	    end

	    def parse
	      # remove bom first
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
	end
end