---
title: 滑动视图
date: 2017-02-24 22:54:25
tags:
---
![CarouselView](http://ob9hppsg4.bkt.clouddn.com/CarouselView.gif)  

## 滑动视图  
想要自定一个滑动视图，根据标题长度自动计算Button宽度，通过滑动与点击均可控制视图，并且当点击事件动画未完成时，也可以正常交互，获得较好的用户体验，于是有了该demo。  

### Tips  
点击事件，UIScrollView设置ContentOffset时，如果在`UIView animateWithDuration:`中进行，中止动画后ContentOffset会直接跳转至设置的位置，而`setContentOffset: animated:`方法则能正确地停留在断点位置。  
UIView.layer.presentationLayer可以拿到UIView动画过程中的frame。