title: MEAN杂谈
date: 2015-12-24 21:08:47
tags: 
- mean
- node.js
categories: node.js
---

# 前言
公司要求组织一次培训，面向所有技术人员，所以讲的东西比较杂浅，高手请绕道~

<!-- more -->

# 初识
乍看之下以为这是一个js插件/框架，点进[github首页](https://github.com/meanjs/mean)一看吓了一跳，什么？4种技术融合在一起，了解它之前还得先学其它的，如此高的学习成本只能望而却步了~

# 偶见
直到有一天一位国外的工程师发邮件告诉我说其有一个[不错node.js教程](https://blog.udemy.com/node-js-tutorial/)希望通过我的博客介绍给大家。打开一看，天啊~一个教程写了一个长长的页面。。。怀着浮躁的心扫了一眼，觉得摘一下关键点翻译一下就算了。可正当我开始查找关键点的时候，发现教程讲的不仅仅是node.js，而是基于node.js的全栈开发技术，而且教程超级详细，图文结合，于是发了个愿，全文翻译了下来~

# why
为什么mean.js引起我的强烈关注？原因如下：
* **前后端一种开发语言javascript。**这对前端的同学是有利的，大大降低了学习成本。较之前的jsp、php前后端都是用的不同语言。
* **前后端用一种数据类型JSON。**前端json数据一般到后端都需要进行转译后，再通过sql到数据库。而mean从浏览器到数据库都是用的json格式的数据，即存即取即用，无需转化和复杂的sql语句。
这两种主要的特性就好比嬴政建立秦朝之后统一货币、度量单位，重要性可见一斑。
* **可替换性。**mean的核心是node.js，在使用node.js的前提下，expressjs可以被thinkjs、koajs替换，angularjs可以被vuejs、avalonjs替换，mongodb可以被mysql替换（不过JSON数据格式优势就没有了）。

当然，世上没有银弹，每种技术都有自己的缺陷：mongodb不适于事务性较强的系统，angular框架较重不适合密集的dom操作...

# 另类的mongodb

和数据库打交道的往往是后端工程师和DBA，对于前端工程师来说，接触得就比较少了。虽然笔者有jsp开发经验，也是基于传统的mysql、oracle等关系型数据库，mongodb还是个新鲜玩意。所以结合官网文档以及个人写的demo来看，有以下几个印象：

* 面向文档。关系数据库是由几个范式来定义的，把数据都转换成二维的结构，规定表中不可以有表。提升数据原子操作的同时牺牲了查询性能（查询一些数据的时候需要多表关联）。而mongodb是nosql数据库中的一种，用BSON(Binary JSON)的格式让数据可以嵌套，属于反范式设计。通过增加数据冗余性来提升查询性能，随之也带来了冗余数据的同步更新问题。
据一些资料显示，mongodb的查询性能适用于大数据，所以最近比较火。当然我觉得其取消了sql，使用JSON数据格式使得简化了操作，也是有一定优势的。

# 简捷的express

    node i express -g
    express [option] [dirctory]
两条命令创建一个web应用，是不是很geek？第一个特点：快速

{% asset_img express-middleware.png %}

npm上随便一搜，20000+的模块。流行程度和插件支撑都是首屈一指。第二个特点：开放

{% asset_img express-project.png %}

再看工程结构，十几个文件，清晰小巧。第三个特点：简单

最近有个框架听说也比较火——thinkjs。下载试用了一下，可以用ES6开发，好处是号称解决了回调问题，坏处是学习成本和时间...顺便跟express对比了一下，总的来说，两边的框架结构差不多，主要都是路由、视图、中间件。thinkjs是比较崇拜模块化的，模块化之间耦合度很低，可以独立定义视图引擎等，这种设计在大型应用开发部署上可能会有优势吧。但是它有个短板啊~出生时间短，插件少得可怜，所以还是不敢轻易尝试。

# 开放的node

如果要我主观地评价一下node.js，我只能说它就是前端工程师的翅膀，而npm为这双翅膀插上了丰富的羽毛。

它把传统的基于任务/请求的等待模式变成了事件驱动的非阻塞模式，大大提升了并发能力和吞吐量。说着说着想到了nginx，当然现在一些大企业看他们的架构都是nginx架设在node.js之上，真是强强结合。

当然node.js也有问题：单线程易崩溃（cluster利用多核、pm2部署）、回调可读性差（promise模式，q或async插件，ES6下更是自带promise）。只是瑕不掩瑜，如果配合外壳，亦可以开发混合桌面应用，例如hex。无需多说，看看cnode社区的热闹程度就知道了~

# 强势的angular

[angular介绍](http://yalishizhude.github.io/2015/09/10/angular-introduction/)

看2015js调查中，angular使用者还不少，当然这种重框架也经常受人诟病，所以也有替代方案。轻量级的有vue.js（可惜不支持IE8），avalon.js（可惜社区不活跃，插件不多），还有基于jquery的数据绑定插件。可见MV*这种结构还是很受欢迎的。

# 演示材料
基于express.js做的ppt
[MEAN技术分享](https://github.com/yalishizhude/mean-representation)

- - - 
博客：http://yalishizhude.github.io
作者：[亚里士朱德](http://yalishizhude.github.io/about/)