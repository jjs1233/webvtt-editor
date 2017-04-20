"""
@author:   smalt(jjs1233@163.com)

webvtt.rb
~~~~~~~~~~~~~~~~
"""
# encoding: UTF-8
$LOAD_PATH.unshift(File.dirname(__FILE__))
if defined?(Encoding)
  Encoding.default_internal = Encoding.default_external = "UTF-8"
end


require "vtt/vtt"
require "vtt/cue"
require "vtt/timestamp"
require "vtt/smalt"	
