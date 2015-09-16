title: underscore源码经典
tags:
---

版本1.7

### 闭包
整个函数在一个闭包中，避免污染全局变量。通过传入this（其实就是window对象）来改变函数的作用域。和jquery的自执行函数其实是异曲同工之妙。这种传入全局变量的方式一方面有利于代码阅读，另一方面方便压缩。

underscore写法：

    (function(){
        ...
    }.call(this));

jquery写法：

    (function(window, undefined) {
        ...
    })(window);

### 原型赋值
    18 var ArrayProto = Array.prototype, ObjProto = Object.prototype, FuncProto = Function.prototype;

Array,Object,Function这些本质都是函数，获取函数原型属性prototype也是为了便于压缩。简单解释一下，如果代码中要扩展属性，可能这样写
    
    Object.prototype.xxx = ...

而这种代码是不可压缩的，`Object`,`prototype`这些名字改了浏览器就不认得了。

但是上面的代码中创建了`ObjProto`之后，源生代码经过压缩之后，`ObjProto`就可能命名成a变量，那么原来的代码就压缩成

    a.xxx = ...

一个小建议就是凡事一段代码被使用两次以上都建议定义变量(函数)，有利于修改和压缩代码。

### 格式

    29 var
    nativeIsArray      = Array.isArray,
    nativeKeys         = Object.keys,
    nativeBind         = FuncProto.bind,
    nativeCreate       = Object.create;

这种定义的方式省略了多余的var，格式也美观，让我想到了sublime中的一个插件alignment。
