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


require "vtt/vtt.rb"
require "vtt/cue.rb"
require "vtt/timestamp.rb"
require "vtt/smalt.rb"


a = WebVTT.read('test.vtt')
# a.delete(7,8)
a.insert(2,3,'text')