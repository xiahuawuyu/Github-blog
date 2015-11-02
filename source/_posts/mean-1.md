title: 【译】基于MEAN的全栈开发实例教程1：前言
date: 2015-10-13 00:03:42
tags:
- node.js
- mean
categories: node.js
---

>原文地址 https://blog.udemy.com/node-js-tutorial
>感谢来自Udemy的Samantha来信分享


# 什么是node？
Node是一个开源，跨平台的用来执行javascript的运行环境。它建立在google的v8引擎上，而v8引擎正是google chrome浏览器的执行引擎，能够快速的将javascript代码转为原生的机器码。
在Node诞生之前，javascript只能在浏览器执行。在2009年，Ryan Dahl使用开源的google v8 javascript引擎来构建node，使它成为一个独立于浏览器之外的javascript运行环境。这使得javascript开发者能够在服务端使用javascript来构建大部分的web apis。

>题外话：我觉得有两个技术的普及让web前端的有了较大的发展。一是混合应用的出现，包括移动端的混合应用如phone gap、ionic等框架和PC端的混合应用如hex、酷狗音乐等，这一技术的诞生让前端工作从简单的类似制作ppt一般地展现页面效果的工作升级成了开发应用程序的级别；二是node.js的出现，让js可以运用于服务端开发，让前端工程师能低门槛地转成js全栈，通过node.js开发后端又可以与数据库连接，让js开发人员可以参与到web的前端、后端、数据库整个系统，从而为js工程师提供了一条晋升到web架构师的有利通道，为js工程师插上了一双翅膀。

<!-- more -->

# 就业市场
近年node非常地受欢迎并且很多大公司（例如IBM，微软，雅虎，LinkedIn，PayPal），已经开始采用它了。
正如你在下面来自于indeed.com的就业趋势图中所见，市场对于node.js开发者的需求正在快速增长。
{% asset_img job.png %}
虽然在数量方面，node开发者的市场需求量不如Ruby on Rails以及很多其它框架那样，但是我认为这种情况很快会改变。
2013年，从一些官方博客中得知，PayPal从Java转向了node.js，LinkedIn也从Rails转向了node。

# 我喜欢node的原因
我很早就采用了ASP.NET MVC框架，并且使用它进行了数年的web应用开发。关于ASP.NET MVC有一件事让我很不爽的就是，在语言的编程风格和习惯上，从服务端到客户端会有较大的转变。然而C#和javascript都是类似C语言风格的编程语言，当然用C#来编程还是和javascript有很大的不同。这就是为什么很多ASP.NETweb开发者通常只擅长两种语言中的一种而不是全部擅长，所以他们会将自己分类成“后端”或“前端”开发者。同样的情况发生在Ruby on Rails,PHP,Python 等开发者身上。
采用node的话，你可以在服务端和客户端同时使用javascript。这意味着更简洁和更一致的代码库以及更少的转换和映射。当然一个好的javascript开发者能同时编写服务端和客户端的代码将是也是非常牛叉的。

# 什么时候使用node
node不是一个银弹。它是专为I/O密集型操作和快速构建可扩展性的实时网络应用而设计的。比如说一些在线游戏，协作工具，聊天系统等。通过node，你可以用最少的系统资源来服务大量的客户端，这就是为什么它为高可扩展性而设计。
对于搭建在类似于MongoDB的文档数据库的API服务器，node也是一个非常不错的选择。你将文档数据以json对象的格式存储在mongo中，然后通过RESTful API的来操作它们。当从数据库读写数据时，并不需要将JSON和其它类型进行转换。在本教程中，我们将构建一个node 应用通过以上提到的这种方式。
根结node的结构特点，它应该避免用于CPU密集型操作。本教程中我将从实例开始介绍node而不是从架构深入讲解node以及为什么它不适用与CPU密集型应用。这些深入讲解的部分我将很快发布在Udemy上。如果你有兴趣，请提交到我的[邮箱](http://programmingwithmosh.com/node-js-course-coming-soon/)。

# mean全栈开发
构建node应用有很多选择，但mean全栈式框架最近变得非常流行。mean代表的是：
* MongoDB：我盟用来存储数据的数据库引擎。
* Express.js：服务器端用来构建web应用程序的框架，类似于ASP.NET MVC或Rails。
* Angular：用来构建web应用的前端框架
* Node.js：javascript运行环境。
通过mean，你可以将文档数据以json对象的格式存储在mongo中，然后通过基于node和express搭建的RESTful API服务器的来操作它们。通过Angular构建客户端来操作这些API并渲染视图给用户。这意味着你在你的代码中，你将使用单一的统一的语言（javascript），结果就是让代码更加具有一致性和可维护性。另外的好处就是，你将花费更少的时间来处理JSON和其它格式之间的转换。所有这些将导致更好的性能和更高的开发效率。
如果你从未使用过MongoDB或者Angular，完全不用担心。在本教程中我将将会你这些技术的基础知识。
好了，有了足够的理论支持。是时候用mean来始构建一个应用了。

- - - 
博客：http://yalishizhude.github.io
作者：[亚里士朱德](http://yalishizhude.github.io/about/)