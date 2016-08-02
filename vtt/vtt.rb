module WebVTT
	def self.read(f)
		if is_vtt? f
			Smalt.new(f)
		else
			raise MalformedFile, "Not a valid VTT file"
		end
	end

	def self.is_vtt?(path)
		return path[/\.[^\.]+$/] == ".vtt"
	end

end