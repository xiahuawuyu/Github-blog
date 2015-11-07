title: WEB知识整理（持续更新）
date: 2015-09-16 23:04:58
tags: 
- html
- css
- js
categories: WEB
---

## 概念
### 对WEB标准以及W3C的理解与认识
W3C主张结构、样式、行为分离
分别对应html(xhtml)、css、ECMAScript

- - -
<!-- more -->

## html
### doctype类型
#### html5
<!DOCTYPE html>
不使用dtd

#### HTML 4.01 Strict
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
不包括展示性的和弃用的元素（比如 font）,不允许框架集（Framesets）。

#### HTML 4.01 Transitional
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
"http://www.w3.org/TR/html4/loose.dtd">
包括展示性的和弃用的元素（比如 font）,不允许框架集（Framesets）。

#### HTML 4.01 Frameset
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" 
"http://www.w3.org/TR/html4/frameset.dtd">
包括展示性的和弃用的元素（比如 font），允许框架集内容。

#### XHTML 1.0 Strict
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
不包括展示性的和弃用的元素（比如font）。不允许框架集（Framesets）。必须以格式正确的 XML 来编写标记。

#### XHTML 1.0 Transitional
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "
http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
包括展示性的和弃用的元素（比如font）。不允许框架集（Framesets）。必须以格式正确的 XML 来编写标记。

#### XHTML 1.0 Frameset
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
包括展示性的和弃用的元素（比如font），但允许框架集内容。必须以格式正确的 XML 来编写标记。

#### XHTML 1.1
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
不包括展示性的和弃用的元素（比如font）,不允许框架集（Framesets）,但允许添加模型（例如提供对东亚语系的 ruby 支持）。

## javascript

### 什么是原型和原型链

Javascript中，所有数据类型都有一个默认属性：`__proto__`，这个叫做原型。而该隐藏属性中又包含其它数据对象的`__proto__`，这种原型的嵌套包含就叫原型链。

### prototype属性有什么作用
本质上，js中的基本数据类型Functoin/Object/Number/Array/boolean都是函数。（用typeof 可以查看）而prototype是函数的专有属性，当该函数被实例化时，prototype属性可以被实例所继承，即

    var fun = function(){};
    var a = new fun();
    a.__proto__ === fun.prototype; //true

### 改变作用域的方法
#### apply
通过传入对象参数改变原函数作用域为参数作用域。
`fun.apply(obj, [a,b,c]);`
调用fun函数，作用域为obj，参数为a/b/c。
#### call
同上，不过为不定参数。
#### new
通过实例化，将构造函数this指针指向实例函数。
#### bind
传入参数可以改变做用域甚至绑定参数

### 判断数据类型的方法
+ toString.call 准确判断数据类型：Array、String、Object、RegExp、Number、Undefined、Null、Date、Boolean、Function
+ typeof 粗略判断数据类型：undefined、number、string、boolean、object、function
+ instanceOf 判断一个函数是否为另一个函数的实例。
+ Array.isArray ECMAScript 5 新增方法，用来判断参数是否为数组。
+ isFinite 判断是否为Infinity和null

### arguments是什么数据类型
函数内部自动创建的一个类似数组的获取函数实参的隐藏对象。

### caller和callee有什么区别
`caller`
函数原型函数，返回该函数的调用函数。当该函数为顶层调用时，返回null
`callee`
arguments的默认属性，`arguments.callee`用来指向函数本身，常用在匿名函数和递归函数中。`arguments.callee.length`可以用获取函数形参长度。

### == 和 === 有什么区别
+ '1' == 1 --> true
+ '1' === 1 --> false
+ null == undefined --> true
+ null === undefined --> false
+ NaN == NaN --> false
+ NaN === NaN --> false
+ var a = b = {}; a === b -->true 
+ var a = {}; var b = {}; a === b --> false
`==` 先将两边值转换为同一类型的对象再进行 `===`比较
`===` 只用于浅拷贝的对象进行比较，不进行对象内容进行比较。只要引用地址不一致，即使内容一致也比较不出来。可以用来比较函数、数组等复杂对象，只是实用性不大。

### 什么是变量提升
变量在一个范围内声明的时候，javascript引擎会将这个声明移到范围顶部。

    var v='Hello World'; 
    (function(){ 
        console.log(v); 
        var v='I love you'; 
    })();//undefined
这段代码等价于

    var v='Hello World'; 
    (function(){ 
        var v;
        console.log(v); 
        v='I love you'; 
    })();
同样，匿名函数也受命名提升的影响

    (function(){ 
        foo(); 
        function foo(){ 
            console.log("我来自 foo"); 
        } 
    })(); //我来自 foo

    (function(){ 
        foo(); 
        var foo = function(){ 
            console.log("我来自 foo"); 
        } 
    })();//TypeError: foo is not a function

js中有函数作用域但是没有块级作用域。

    var x = 1; 
    console.log(x); // 1 
    if (true) { 
        var x = 2; 
        console.log(x); //2 
    } 
    console.log(x);// 2 


[详细介绍](http://www.jb51.net/article/30719.htm)

## css

### 浏览器兼容性问题解决方法
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

### css3常用属性
#### border-radius
圆角属性 

#### box-shadow
用来制作阴影、模糊效果、以及内边框

#### background-size
设置背景图片大小

#### transition
制作简单动画，通过改变特定属性

#### transform 
样式变换，缩放、旋转、平移

### 清除浮动的方法
#### clear:both
浮动元素后建立空元素来清除浮动。非IE浏览器常用before和after伪类来实现。
#### overflow:auto
空标签元素清除浮动而不得不增加无意代码的弊端,,使用zoom:1用于兼容IE

### 隐藏标签的方法
* display:none 完全隐藏
* visibility:hidden 隐藏但保留占位空间


## 工具
### chrome调试工具
#### ctrl+shift+f 
搜索所有文件内容，速度很慢，不建议使用
#### ctrl+p 或 ctrl+o
按文件名全量搜索文件
#### ctrl+shift+p 或 ctrl+shift+o
在当前打开的js文件中搜索函数名称
#### ctrl+shift+o 或 ctrl+shift+o
在当前打开的css文件中按选择器搜索定义的样式



- - - 
博客：http://yalishizhude.github.io
作者：[亚里士朱德](http://yalishizhude.github.io/about/)