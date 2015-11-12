title: 从JQuery到Angular的一次改版
tags:
  - JQuery
  - Angular
date: 2015-11-13 06:43:15
categories: Angular
---

# 前言

最近主要在对之前的流程进行改版优化，之前一直使用的JQuery来实现，因为考虑到Angular在可移植性、可维护性、耦合性方面都优于JQuery，缺点就是学习成本比较高，不过之前一直在微信端使用Angular，所以这一点也不成问题。于是探坑之旅就这样开始了...

<!-- more -->

# 代码量

## JQuery

体积：84.6k（html 20.2k，js 64.4k）
文件数：9（4个html，5个js）

## Angular

体积：95.1k（html 39.7k，js 55.4k）
文件：12（5个html，7个js）

这里只考虑业务逻辑，忽略第三方代码。
原有的业务逻辑由js动态生成dom，所以js部分会比较庞大。
在html插入指令和业务逻辑，所以html体积增大。

# 页面结构

整个业务流程分为3个步骤，每个步骤完成之后才能进入下个步骤，所有步骤完成之后才可以提交给后端。
最简单的实现方法是把每个步骤做成表单放在一个页面里面，所有表单完成后抽取整合放在ajax里进行提交。这样实现的话容易造成代码的耦合性提高从而可维护性降低，并不是最佳的实现方式。所以对于JQuery和Angular分别采取了不同的实现形式。

## JQuery

类似单页应用的加载方式，好处的就是不会刷新页面，数据不丢失，容易整合提交

### 路由

考虑到学习成本以及业务流程相对简单，没有使用backbone之类的第三方js管理路由，自己对hash值进行判断来管理路由。首先实现`onhashchange`函数来监控路由变化

    window.onhashchange = function(){...};

然后获取`location.hash`对其判断

    switch (location.hash) {
      case '#step-0':
        break;
        //此处省略几十行代码
    }

路由的跳转也是通过修改`location.hash`值来实现，这里url使用了underscore的template的函数，起作用可以理解为`replace`。

    var urlTemplate = _.template(location.pathname + location.search + '#<%=step%>');
    location.href = urlTemplate({step: 'step-2'});

### 分页

使用的JQuery的load函数,这个函数从服务端加载html，然后填充在所选dom中，加载完成后执行回调函数进行初始化操作。

        $('#view').load(url, function () {
          init();
        });

## Angular

用单页路由的形式也是可以实现的，不过我采用了指令的方式伪装成“分页”来实现。这样也达到了降低耦合性的效果。

### “分页”

前面说了，这里使用自定义的指令来做成单个分页，所以页面的切换就变成了控制指令的显示和隐藏，实现方式也很简单，使用`ng-show`通过改变`nowDirective`的值即可

    <div class="container" ng-controller="mainCtrl">
        <div projects ng-show="nowDirective=='1'"></div>
        <div checkin ng-show="nowDirective=='2'"></div>
        <div submit ng-show="nowDirective=='3'"></div>
    </div>


### “路由”

不过上面只是完成了html的加载，业务逻辑初始化需要借助Angular事件三基友：`$emit,$on,$broadcast`。当指令显示完成时`mainCtrl`用`$broadcast`发出广播给每个指令中的`controller`，指令的`controller`通过`$on`来接收事件并初始化。当前流程完成后用`$emit`向上冒泡通知父`controller`完成页面切换。

# require与Angular

Angular这个东西的神奇之处在于：它本身是一个完整的框架，基本实现了开发中所需的各种功能，同时和其它第三方js又不冲突，比如JQuery、require。
这里使用require来管理代码并不是最优的方式，只是因为项目一直使用require来启动和管理项目上的js逻辑。Angular本身可以通过module函数来实现模块化，在项目中我也是这么实现的。

比如我在定义service的时候是这么写的

    define(['Angular'], function (Angular) {
        'use strict';
        Angular.module('service', []).service('customService', function(){
            //此处省略几百行代码
        });
    });

在引用这个服务的时侯先引用对应的js文件，然后就和Angular的引用方式一样先module后service。

    define(['JQuery', 'Angular', 'underscore', './customService.js', 'iCheck'], function($, Angular, _){
        'use strict';
        Angular.module('directive', ['service']).directive('fold', function() {
            //此处省略几百行代码
        });
    });

这样就完成了模块化和解耦的工作。

# JQuery插件替换

以前的第三方插件大多是基于JQuery实现的，
以项目中的表格校验插件为例，JQuery下使用的是JQuery-validation插件，Angular下我使用Angular-validation。插件的替换分两块：样式和逻辑。逻辑放面按照官方文档进行替换即可，这里的配置文件我单独写了一个校验规则，内容不是很全，有兴趣的可以看一看 http://runjs.cn/code/lqzztwys。 样式修改就变得很手工了，直接抠图、重写css。

{% asset_img error.png %}

{% asset_img success.png %}

# 数据交互

主要方式分两类，一类是利用浏览器缓存，如localstorage、cookie，一类是利用Angular自身的通信方式。利用浏览器经常容易出现兼容性的问题，不考虑了，Angular的内部通信机制大致有3种：
* 写个service存储数据，最规范优雅
* 利用上面提到的事件三基友，中规中矩
* 利用父子controller之间共享$scope对象属性的特点，最简单粗暴
这里考虑到项目进度我做了一回粗鲁的人...囧

# 总结

* Angular由于其数据绑定的特性，在操作、动态生成dom的时候非常具有优势，从此妈妈再也不用担心我忘记刷新dom/数据了~
* Angular非常有利于模块化，同时模块内部注意html尽量写成directive，数据操作用service，业务逻辑用controller。因为service是对数据模型的高度抽象，所以复用性较好，这次试用的service都是从微信端直接拷贝过来使用的。

>如果觉得阅读这篇文章有收获，不妨点个赞吧^_^

- - - 
博客：http://yalishizhude.github.io
作者：[亚里士朱德](http://yalishizhude.github.io/about/)
