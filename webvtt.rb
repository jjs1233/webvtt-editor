# encoding: UTF-8
$LOAD_PATH.unshift(File.dirname(__FILE__))
if defined?(Encoding)
  Encoding.default_internal = Encoding.default_external = "UTF-8"
end


require "vtt/vtt.rb"
require "vtt/cue.rb"
require "vtt/timestamp.rb"
require "vtt/smalt.rb"
