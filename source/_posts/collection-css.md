title: css基础知识
date: 2015-09-16 23:04:58
tags: 
- css
categories: css
---

<!-- more -->

# 浏览器兼容性问题解决方法
css hack
样式文件
>通用 height: 100px; 
>IE6 ： _height: 100px; 
>IE7 ： *+height: 100px; 
>IE6、IE7 ： *height: 100px; 
>IE7、FF ： height: 100px !important; 

引用注释
><!--[if !IE]><!--> 除IE外都可识别 <!--<![endif]--> 
><!--[if IE]> 所有的IE可识别 <![endif]--> 
><!--[if IE 5]> 仅IE5.0与IE5.5可以识别 <![endif]--> 
><!--[if gt IE 5.0]> IE5.0以及IE5.0以上版本都可以识别 <![endif]--> 
><!--[if gte IE 6]> IE6以及IE6以上版本可识别 <![endif]--> 
><!--[if lt IE 7]> IE7以及IE7以下版本可识别 <![endif]--> 

# css3常用属性
## border-radius
圆角属性 

## box-shadow
用来制作阴影、模糊效果、以及内边框

## background-size
设置背景图片大小

## transition
制作简单动画，通过改变特定属性

## transform 
样式变换，缩放、旋转、平移

# 清除浮动的方法
## clear:both
浮动元素后建立空元素来清除浮动。非IE浏览器常用before和after伪类来实现。
## overflow:auto
空标签元素清除浮动而不得不增加无意代码的弊端,,使用zoom:1用于兼容IE

# 隐藏标签的方法
* display:none 完全隐藏
* visibility:hidden 隐藏但保留占位空间

- - - 
博客：http://yalishizhude.github.io
作者：[亚里士朱德](http://yalishizhude.github.io/about/)