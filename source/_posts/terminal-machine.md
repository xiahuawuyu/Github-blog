title: 细数在自助终端机上开发混合应用的那些坑（前端）
date: 2015-07-16 17:13:37
tags:
- html
- css
- js
categories: 混合应用
---

## 需求

应客户要求开发部署在自助终端机（可理解为带触摸屏的电脑）上的程序，主要实现身份证识别、订单查询和打印功能。
---
<!-- more -->
## 开发环境
* windows XP
xp没什么好吐槽的，老系统了，还比较稳定。
* IE 8
不支持css3，不支持媒体查询，没有chrome的实时打印预览（虽然后面也没用到这个功能）。
好处就是支持actvieX插件，可以扩展浏览器功能，打破浏览器默认的一些限制。
* visual studio
开发程序外壳，生成可执行的exe，内嵌浏览器加载html。
性能一般，但是修改很方便。
---
## 前端技术选型
由于对jquery比较熟悉，ui考虑使用bootstrap一方面是因为其比较火，另外一方面是它跟jquery可以完美结合，觉得坑会少一些，事后证明其实作用并不大，自己写样式也差不多。尤其是bootstrap的栅格布局，在打印的时候就是一个大坑，而且在IE8下媒体查询也失效了，所以对本次开发的贡献度实在是低。。。
## 问题和解决方案
* 启动同步问题
*描述：*
由于是bs架构同时部署在一台机器上，两端同时由应用程序启动，所以正常的程序是tomcat启动完成后，再访问服务器加载页面。
*难度：*\**
*方案：*