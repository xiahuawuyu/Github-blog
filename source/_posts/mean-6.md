title: 【译】基于MEAN的全栈开发实例教程6（完）
date: 2015-12-13 16:13:20
tags:
  - node.js
  - mean
categories: node.js
---

>原文地址 https://blog.udemy.com/node-js-tutorial
>感谢来自Udemy的Samantha来信分享

# 删除一个视频

在本节中，你将学习如何通过Monk删除文档。你也会再一次回顾你所学到的关于Express和Angular的知识。到这一节的结尾，所有的知识点都会像拼图一样放在一起。

<!-- more -->

我们将在后面几步中实现这一功能。从服务器开始，我们将建立一个用于删除视频文档的接口。然后，我们将在列表中为每个视频前面添加一个删除链接。当用户点击这个链接，他们将被重定向到一个页面，在那里他们可以看到视频的细节。我们将在该页上有一个确认删除按钮。一旦他们点击这个按钮，页面将调用API端点，跳转带回的视频列表。

但在我们实现功能之前，我有一个建议。我认为你所学的到目前为止，应该能够独自实现这一功能。我想让你花10~15分钟来实现这个功能，作为一个练习，以检验你所学到的。然后，你可以回顾你的解决方案与我的对比，看看是否有任何改进的空间。在你开始之前，请注意：

* 最好的方式是像我之前提到那样一步一步地完成。一旦你完成每一步，回到这里，回顾你的解决方案。
* 如果你忘记了Express的语法或者Angular的接口，不要担心。这是学习一个新的框架时的自然现象。只需要浏览源代码，查看我们早期的类似例子就好。
* 如果你被卡住了，谷歌一下。

## 第1步：构建一个API端点

打开 **routes>videos.js** 然后添加一个新的路由：

    router.delete('/:id', function(req, res){
        var collection = db.get('videos');
        collection.remove({ _id: req.params.id }, function(err, video){
            if (err) throw err;
            res.json(video);
        });
    });

这些代码和之前的差不多，唯一的区别是我们使用了 **router.delete** 来为HTTP DELETE请求注册一个路由处理器。

同时注意我们这里使用了视频文档对象的 **remove** 方法。第1个参数你可能已经猜到了，正是一个标准对象。

## 第2步：构建删除页面

回到 **partials > home.html**，在每一个视频链接前添加一个删除链接：

    <li ng-repeat='video in videos'>
        <a href="/#/video/{{video._id}}">
            {{video.title}}
        </a>
        <a href="/#/video/delete/{{video._id}}">
            <i class="glyphicon glyphicon-remove"></i>
        </a>
    </li>


在这里<i>用来渲染一个图标。glyphicon和glyphicon-remove都是Bootstrap用来绘制图标的类。Bootstrap包括几十个用来构建应用的现代图标。为了看到所有图标的列表，可以去[这里](http://getbootstrap.com/components/)。绘制一个图标，你需要使用两个CSS类。一是glyphicon（所有图标的基础类），另一个就是你使用的类（glyphicon-remove）。在Bootstrap文档中，你可以在每个图标下面看到这个CSS类。

点击图标页面将跳转到 **/#/video/delete/{{video._id}}**。让我们创建一个试图并为它注册一个路由。

在 **partials** 文件夹中添加一个叫做 **video-delete.html** 的新文件。文件中写下如下代码：

    <h1>Delete Video</h1>
    <p>
        Are you sure you want to delete this video?
    </p>
    <ul>
        <li>Title: {{video.title}}</li>
        <li>Description: {{video.description}}</li>
    </ul>
    <input type="button" value="Yes, Delete" class="btn btn-danger" ng-click="delete()" />
    <a class="btn btn-default" href="/#/">No, Go Back</a>

这里并没有什么特别的。用UL和LI来展示视频的不同属性。在真实的应用中，你可能需要一个更加复杂的标签来实现。

这里注意一下，我为删除按钮添加了一个 **btn-danger** 类来让它变成红色，为返回按钮添加了 **btn-default** 让它变成白色。

当我们完成这些步骤之后，页面看起来是这个样子的：

{% asset_img delte.png %}

接下来，我们需要为视图编写一个控制器。在控制器中，我们将调用API来获取视频的详细信息并加载到页面上。当用户点击删除按钮我们将调用API来删除这个视频。

打开 **Vidzy.js** 并创建这个控制器：

    app.controller('DeleteVideoCtrl', ['$scope', '$resource', '$location', '$routeParams',
        function($scope, $resource, $location, $routeParams){
            var Videos = $resource('/api/videos/:id');
            Videos.get({ id: $routeParams.id }, function(video){
                $scope.video = video;
            })
            $scope.delete = function(){
                Videos.delete({ id: $routeParams.id }, function(video){
                    $location.path('/');
                });
            }
        }]);

最后我们创建一个路由来注册视图和控制器。添加路由到应用的配置中：

    .when('/video/delete/:id', {
        templateUrl: 'partials/video-delete.html',
        controller: 'DeleteVideoCtrl'
    })

现在已经完成了。测试一下这个删除功能。回到浏览器并且刷新首页。点击删除图标。删除一个视频。这个视频将被删除然后调回首页。

# 总结

如果你按照教程做到这一步了，你已经证明了你对学习新事物充满热情。这非常不错~我希望你喜欢这个教程并且能学习到Node，Express，Angular和MongoDB的基础知识。

* 你使用了Node，Express，Angular和MongoDB成功地建立了一个完整的CRUD应用。
* 你使用了robomongo创建和填充数据库视频文档。
* 你使用了Monk在Mongo中来添加、更新、删除和查询视频文档。
* 你用Express创造了一个RESTful API：GET，POST，PUT，DELETE。
* 你了解了Node的模块系统，并使用了require方法。
* 你了解了Node的软件包管理器（NPM），用它来安装Node模块。
* 你用Angular度来构建一个单页应用程序。
* 你学到了关于Angular的依赖性管理。
* 你使用了Angular的内置服务，如$scope、$resource、$location和$routeparams。
* 你用Angular指令（ng-model, ng-click）将行为添加到DOM元素。
* 你熟悉了使用Bootstrap的类来给你的表单和按钮添加漂亮、流行的外观。

下一步是什么？Node不仅仅是你目前所学的这些，这就是为什么我计划创建一个全面的课程，来教你使用Node做许多令人惊奇的事情。我将重点教会你：

* 认证和授权
* 预防常见安全攻击
* 数据验证
* 缓存
* 实时应用
* 更多...

如果你很喜欢我的教学风格并且想从我这里学习更多，欢迎订阅我的[时事通讯](http://programmingwithmosh.com/node-js-course-coming-soon/)。一旦我的课程准备好了将发送通知给你。

# 源代码

教程中提到的代码已上传到github：
https://github.com/yalishizhude/Vidzy

*如果觉得阅读这篇文章有收获，不妨点个赞吧^_^*

- - - 
博客：http://yalishizhude.github.io
作者：[亚里士朱德](http://yalishizhude.github.io/about/)