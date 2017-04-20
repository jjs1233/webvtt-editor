# webvtt-editor
Target
=========================
>作为rails第三方插件实现在线编辑webvtt字幕文件

Usage
---------------------------------------------
* 将文件夹放在rails的app目录下
* 引入插件
 ```
 require "webvtt"  
 ```
 
* 加载文件

 ```
 webvtt = WebVTT.read("filepath")
 ``` 
 
* 插入字幕

 ```
 webvtt.insert(start_time,end_time,subtitles)
 ``` 
 
* 删除字幕
 ```
 webvtt.delete(start_time,end_time)
 ```
 
* 字幕信息

 ```
 webvtt.cues do |cue|
   cue.start
   cue.end
   cue.text
 end
 ```  
