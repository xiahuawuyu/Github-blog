title: 聊聊前后端中的promise三板斧
tags: 
- Angular
- node.js
- JQuery
---

# 什么是promise
promise是对象，代表了一个函数最
终可能的返回值或者抛出的异常。在与远程对象打交道时，promise会非常有用，可以把它们看
作远程对象的一个代理。
习惯上，JavaScript使用闭包或者回调来响应非同步的有意义的数据，比如页面加载之后的
XHR请求。我们可以跟数据进行交互，就好像它已经返回了一样，而不需要依赖于回调函数的
触发。
回调已经被使用了很长时间，但开发人员用它时都会很痛苦。回调使得调用不一致，得不到
保证，当依赖于其他回调时，它们篡改代码的流程，通常会让调试变得非常难。每一步调用之后，
都需要显式处理错误。
在执行异步方法时触发一个函数，然后期待一个回调能运行起来。与之不同的是，promise
提供了另外一种抽象：这些函数返回promise对象。
# 使用场景
promise通常用来处理多个异步非阻塞函数，通常有两个场景：
* 场景1：将并行改为串行
* 场景2：等待所有异步函数加载完成后进行操作

# 通用解决方案：

    var f1 = 0;
    var f2 = 0;
    function fun1(){
        setTimeout(function(){
            f1 = 0;
        },1000);
    }
    function fun2(){
        setTimeout(function(){
            f2 = 2;
        }, 2000);
    }
    fun1();
    fun2();
    console.log(f1, f2);// 0 0

现在这里有两个异步函数fun1和fun2，假设运行fun1的返回结果1，fun2的返回结构2，先看场景1

    function fun1(){
        var def = q.defer();
        setTimeout(function(){
            def.resolve(1);
        },1000);
        return def.promise;
    }
    function fun2(){
        var def = q.defer();
        setTimeout(function(){
            def.resolve(2);
        }, 2000);
        return def.promise;
    }
    fun1().then(function(result){
        f1 = result;
        return fun2();
    }).then(function(result){
        f2 = result;
        console.log(f1,f2);// 1 2
    });
再看场景2，fun1和fun2的代码如上，调用方式改变一下：
    
    q.all([fun1(), fun2()]).then(function(result){
        f1 = result[0];
        f2 = result[1];
        console.log(f1, f2);//1 2
    })

# q
看看q的介绍

>If a function cannot return a value or throw an exception without blocking, it can return a promise instead. A promise is an object that represents the return value or the thrown exception that the function may eventually provide. A promise can also be used as a proxy for a remote object to overcome latency.

如果一个函数不能以阻塞的方式返回一个值或者抛出一个异常，那么可以返回一个promise来解决替代这种情况。一个promise是一个代表了函数最终返回的值或者异常的对象。一个promise也可以用来作为一个远程延迟加载的对象的代理。

# jquery 1.11

def.done(d,[d])
def.fail(failCallbacks)
def.reject(args)
def.rejectWith(c,[a])
def.resolve(args)
def.resolveWith(c,[a])
def.then(d[,f][,p])1.8*
def.promise([ty],[ta])
def.always(al,[al])
def.notify(args)1.7+
def.notifyWith(c,[a])1.7+
def.progress(proCal)1.7+
def.state()1.7+

# angular 1.3.9

