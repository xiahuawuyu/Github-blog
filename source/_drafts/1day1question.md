title: 1day1question
tags:
---

1. 对WEB标准以及W3C的理解与认识

结构行为表现的分离；
标签闭合、标签小写、不乱嵌套、提高搜索机器人搜索几率
使用外链css和js脚本、

2. 什么是原型和原型链

Javascript中，所有数据类型都有一个默认属性：`__proto__`，这个叫做原型。而该隐藏属性中又包含其它数据对象的`__proto__`，这种原型的嵌套包含就叫原型链。

3. prototype属性有什么作用

本质上，js中的基本数据类型Functoin/Object/Number/Array/boolean都是函数。（用typeof 可以查看）而prototype是函数的专有属性，当该函数被实例化时，prototype属性可以被实例所继承，即

    var fun = function(){};
    var a = new fun();
    a.__proto__ === fun.prototype; //true

