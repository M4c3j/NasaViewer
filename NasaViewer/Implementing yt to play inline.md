# Implementing yt to play inline

<!--@START_MENU_TOKEN@-->Summary<!--@END_MENU_TOKEN@-->

## Overview

<!--@START_MENU_TOKEN@-->Text<!--@END_MENU_TOKEN@-->

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->

To implement a link from YouTube to play video in UIKit, you can use the UIWebView class to embed a web view in your app and load the YouTube video URL. Here are the steps you can follow:

Add a UIWebView to your view controller's view.
swift
Copy code
let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
view.addSubview(webView)
Load the YouTube video URL in the web view.
swift
Copy code
let videoID = "VIDEO_ID" // Replace VIDEO_ID with the actual ID of the YouTube video
let urlString = "https://www.youtube.com/watch?v=\(videoID)"
let url = URL(string: urlString)!
let request = URLRequest(url: url)
webView.loadRequest(request)
Note: You can obtain the VIDEO_ID from the YouTube video URL. It is the string of characters that follows the v= parameter in the URL.

Set the allowsInlineMediaPlayback property of the web view to true to enable inline video playback.
swift
Copy code
webView.allowsInlineMediaPlayback = true
If you want to play the video automatically when the web view is loaded, you can add the following JavaScript code to the web view's content:
javascript
Copy code
let playVideoJS = "document.querySelector('video').play();"
webView.stringByEvaluatingJavaScript(from: playVideoJS)
This JavaScript code finds the first video element in the web page (which should be the YouTube video) and calls its play method to start playback.

That's it! When you run your app and navigate to the view controller that contains the web view, the YouTube video should be loaded and ready to play inline.
