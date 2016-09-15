module WebVTT
	#读取文件
	def self.read(f)
		if is_vtt? f
			Smalt.new(f)
		else
			raise MalformedFile, "Not a valid VTT file"
		end
	end

	#判断文件是否是vtt文件
	def self.is_vtt?(path)
		return path[/\.[^\.]+$/] == ".vtt"
	end

end