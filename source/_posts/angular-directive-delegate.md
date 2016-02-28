title: Angular中用代理服务实现控制器与指令之间的通信
tags:
- js
- angular
date: 2016-02-28 18:14:10
categories: angular
---

# 场景

一般来说，angular中，控制器与指令之间的通信可以通过共享作用域的方式来实现。这种处理方式可以满足大部分需求，但是比如说指令如果是独立作用域的话这种情况就玩不转了~在开发中就碰到这样一种尴尬的情况：控制器想要操作某个dom元素（滚动或者获取元素坐标），angular中是不提倡在控制器中直接操作dom而是在指令中。这个时候就可以通过一个代理服务来实现。

<!-- more -->

# 代理服务

这一段代理服务的代码短小精悍，从著名的[ionic](http://ionicframework.com/)中拷贝出来。
大致思路是通过`angular.DelegateService`来返回一个代理服务，指令将接口注册到代理服务，控制器调用代理服务中的接口即可操作指令从而操作dom元素。

## 扩展Angular属性
```
angular.DelegateService = function (methodNames) {
  //...
  return ['$log', function ($log) {
    //...
    return new DelegateService();
  }];
};
```
angular中最全局的全局变量当然就是`angular`了，在此之上添加函数，就可以在模块定义的时候使用。这个函数返回的是标准的声明service的数组，前面一个`$log`服务，后面一个实现函数。而这个服务本身就是新创建的`DelegateService`实例。
先来看看这个`methodNames`参数有什么用处。`methodNames`看名字就可以知道这是一个数组，包含了一些函数的名称（字符串）。
```
if (methodNames.indexOf('$getByHandle') > -1) {
  throw new Error("Method '$getByHandle' is implicitly added to each delegate service. Do not list it as a method.");
}
```
避免内置函数`$getByHandle`和自定义的函数冲突。
```
methodNames.forEach(function (methodName) {
  DelegateInstance.prototype[methodName] = instanceMethodCaller(methodName);
});
```
将所数组中的函数一个个复制到代理服务的原型`prototype`上。
再来看看如何调用实例函数。
```
function instanceMethodCaller(methodName) {
  return function caller() {
    var handle = this.handle,
      args = arguments,
      foundInstancesCount = 0,
      returnValue;
    this._instances.forEach(function (instance) {
      if ((!handle || handle === instance.$$delegateHandle) && instance.$$filterFn(instance)) {
        foundInstancesCount++;
        var ret = instance[methodName].apply(instance, args);
        if (foundInstancesCount === 1) {
          returnValue = ret;
        }
      }
    });
    if (!foundInstancesCount && handle) {
      return $log.warn('Delegate for handle "' + handle + '" could not find a ' + 'corresponding element with id/delegate="' + handle + '"! ' + methodName + '() was not called!\n' + 'Possible cause: If you are calling ' + methodName + '() immediately, and ' + 'your element with delegate-handle="' + handle + '" is a child of your ' + 'controller, then your element may not be compiled yet. Put a $timeout ' + 'around your call to ' + methodName + '() and try again.');
    }
    return returnValue;
  };
}
```
其实很简单，这里返回了一个`caller`函数，这个函数就是遍历_instances中的实例，然后匹配函数名称，调用并返回结果。默认返回第一个实例或者指定的实例。

下面来看看这个实例。

## 代理服务实例
```
function DelegateInstance(instances, handle) {
  this._instances = instances;
  this.handle = handle;
}
```
这是一个代理服务，自然会有很多实例，这里用`_instances`这个数组来保存实例。至于`handle`可以理解为实例id。
```
DelegateService.prototype = DelegateInstance.prototype;
```
这里首先将`DelegateInstance`的原型复制到`DelegateService`上。
```
function trueFn() {
  return true;
}
DelegateService.prototype._registerInstance = function (instance, handle, filterFn) {
  var instances = this._instances;
  instance.$$delegateHandle = handle;
  instance.$$filterFn = filterFn || trueFn;
  instances.push(instance);
  return function deregister() {
    var index = instances.indexOf(instance);
    if (index !== -1) {
      instances.splice(index, 1);
    }
  };
};
```
这里在代理服务`DelegateService`的原型上声明了一个函数`_registerInstance`用来注册服务。该函数将服务保存在代理服务中，同时返回一个注销服务的函数。`filterFn`实际上就是一个过滤函数，如果实例中拥有私有函数，可以通过自定义过滤函数，只暴露公有函数。
```
DelegateService.prototype.$getByHandle = function (handle) {
  return new DelegateInstance(this._instances, handle);
};
```
私有函数，通过`handle`这个id来获取实例。

# 使用实例

这里的例子是控制器通过代理服务来操作指令的例子

## 编写指令，注册服务
```
angular.module('directive', []).directive('keyboard', ['keyboardService', function (keyboardService) {
  return {
    replace: true,
    templateUrl: 'template/keyboard.html',
    link: function (scope, elm, attrs) {
      var instance = {
        toggle: function (flag) {
          window.console.log(flag);
        }
      };
      keyboardService._registerInstance(instance);
    }
  };
}]).service('keyboardService', angular.DelegateService(['toggle']));
```
## 控制器中通过服务调用指令
```
angular.module('app', ['directive']).controller('ctrl', ['$scope', 'keyboardService', function($scope, keyboardService){
  keyboardService.toggle(true);
  }]);
```

# 代理服务源码

https://github.com/driftyco/ionic/blob/master/js/utils/delegateService.js

*如果觉得阅读这篇文章有收获，不妨点个赞吧^_^*

- - -
博客：http://yalishizhude.github.io
作者：[亚里士朱德](http://yalishizhude.github.io/about/)
