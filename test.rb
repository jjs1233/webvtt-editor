# encoding: UTF-8
$LOAD_PATH.unshift(File.dirname(__FILE__))
if defined?(Encoding)
  Encoding.default_internal = Encoding.default_external = "UTF-8"
end


require "vtt/vtt.rb"
require "vtt/cue.rb"
require "vtt/timestamp.rb"
require "vtt/smalt.rb"


webvtt = WebVTT.read("../test1.vtt")
webvtt.modify(100,126.2,"hah")