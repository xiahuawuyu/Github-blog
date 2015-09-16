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

## javascript

### 什么是原型和原型链

Javascript中，所有数据类型都有一个默认属性：`__proto__`，这个叫做原型。而该隐藏属性中又包含其它数据对象的`__proto__`，这种原型的嵌套包含就叫原型链。

### prototype属性有什么作用

本质上，js中的基本数据类型Functoin/Object/Number/Array/boolean都是函数。（用typeof 可以查看）而prototype是函数的专有属性，当该函数被实例化时，prototype属性可以被实例所继承，即

    var fun = function(){};
    var a = new fun();
    a.__proto__ === fun.prototype; //true

### 改变作用域的方法

>apply
通过传入对象参数改变原函数作用域为参数作用域。
`fun.apply(obj, [a,b,c]);`
调用fun函数，作用域为obj，参数为a/b/c。
`call`
同上，不过为不定参数。
`new`
通过实例化，将构造函数this指针指向实例函数。

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
1. <!--[if !IE]><!--> 除IE外都可识别 <!--<![endif]--> 
2. <!--[if IE]> 所有的IE可识别 <![endif]--> 
4. <!--[if IE 5]> 仅IE5.0与IE5.5可以识别 <![endif]--> 
5. <!--[if gt IE 5.0]> IE5.0以及IE5.0以上版本都可以识别 <![endif]--> 
8. <!--[if gte IE 6]> IE6以及IE6以上版本可识别 <![endif]--> 
10. <!--[if lt IE 7]> IE7以及IE7以下版本可识别 <![endif]--> 

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