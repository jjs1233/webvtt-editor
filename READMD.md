Target
=========================
>realize the admission of read and edit webvtt file
Usage
---------------------------------------------
* put webvtt folder under the app directory (rails)
* add code under the controller
 ```require "webvtt"' ```
* load file
 ```webvtt = WebVTT.read("filepath")``` 
* insert subtitles
 ```webvtt.insert(start_time,end_time,subtitles)```
* delete subtitles
 ```webvtt.delete(start_time,end_time)```
* the content of the subtitles file
```webvtt.cues do |cue|
  cue.start
  cue.end
  cue.text
end```  