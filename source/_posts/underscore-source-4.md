title: js高手进阶之路：underscore源码经典（完）
date: 2015-10-21 22:37:08
tags:
- js
- underscore
categories: js
---


# 对象
    921 _.keys = function(obj) {
        if (!_.isObject(obj)) return [];
        if (nativeKeys) return nativeKeys(obj);
        var keys = [];
        for (var key in obj) if (_.has(obj, key)) keys.push(key);
        // Ahem, IE < 9.
        if (hasEnumBug) collectNonEnumProps(obj, keys);
        return keys;
      };
    
      // Retrieve all the property names of an object.
      _.allKeys = function(obj) {
        if (!_.isObject(obj)) return [];
        var keys = [];
        for (var key in obj) keys.push(key);
        // Ahem, IE < 9.
        if (hasEnumBug) collectNonEnumProps(obj, keys);
        return keys;
      };
`keys`和`allKeys`这两个函数很有对比意义。
前者是该对象的枚举属性，先用默认函数处理，再考虑循环遍历，最后考虑老版本浏览器的时候返回默认属性解决方案。
后者是该对象的枚举属性以及继承的属性，直接进行深度遍历，然后考虑老版本浏览器的时候直接返回默认属性解决方案。

<!-- more -->

    31 nativeKeys         = Object.keys,
`Object`自带的这个`keys`函数来判断对象的枚举属性很方便，不过也是ECMAScript5新增的函数。

    1260 _.has = function(obj, key) {
        return obj != null && hasOwnProperty.call(obj, key);
      };
`hasOwnProperty`函数可以有效的判断枚举属性。

# 函数
    758 _.delay = function(func, wait) {
        var args = slice.call(arguments, 2);
        return setTimeout(function(){
          return func.apply(null, args);
        }, wait);
      };
一个闭包的好例子，把参数缓存起来供延迟函数加载。

    870 _.after = function(times, func) {
        return function() {
          if (--times < 1) {
            return func.apply(this, arguments);
          }
        };
      };
这个代码没有太多新意，不过这个函数的使用方法很有意思。但用于多个异步请求的时候非常有用。例如这个例子：

    function render(){//...}
    var renderNotes = _.after(notes.length, render);
    _.each(notes, function(note) {
      note.asyncSave({success: renderNotes});
    });

# 总结
underscore之所以经典，一方面它是一个JavaScript实用库，提供了很多工具函数，可以有效地减少我们的代码量，尤其是在对数组和对象的操作上；另一方面是其体现了JavaScript函数式编程的特点，源码中随处可见函数的嵌套。像函数式编程的无状态、高阶编程这些特点和闭包都有着紧密的联系，所以下一阶段希望能透过JavaScript闭包特性的学习一探函数式编程的精妙。
