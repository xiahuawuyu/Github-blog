title: 【译】基于MEAN的全栈开发实例教程4：实现新增功能
date: 2015-11-19 10:16:04
tags:
  - node.js
  - mean
categories: node.js
---

# 添加一个新视频

在这一部分中，你将学习更多关于在Express中创建API端点，利用Angular构建表单，用Monk在Mongo中存储文档。


类似于上一节，我们将在随后几步中将从前端到后端实现这一功能。首先，我们将创建一个添加视频的API。我们将使用Express路由创建此端点并用Monk存储视频文件在Mongo中。然后，我们将创建一个新的页面来添加一个视频并用Angular来构建这个页面。

让我们开始吧。

<!-- more -->

## 第1步：创建1个API端点
打开 **routes>videos.js** 然后在文件后面和 **module.exports** 前面新增路由（记住，module.exports 应该是模块中的最后一行）：

    router.post('/', function(req, res){
        var collection = db.get('videos');
        collection.insert({
            title: req.body.title,
            description: req.body.description
        }, function(err, video){
            if (err) throw err;
            res.json(video);
        });
    });

这些代码和之前有些类似。让我回顾一下重要的部分。首先，注意router.post方法的用法。在最后一节，我们使用router.get方法来处理一个HTTP GET请求。这里，我们使用REST约定中用来创建对象的 HTTP POST请求。

在路由处理器中，首先我们获得了一个 **videos** 集合的引用，然后使用 **insert**方法在Mongo中添加一个新的文档。

这个方法的第1个参数是一个JSON对象，它有两个属性： **title** 和 **description**。我们用 **req.body** 从这些属性中读取值。它代表数据将被提交到请求的body中。

最后，在回调方法中新增一个文档，如果我们没有获取任何错误，我们使用response（res）的 **json** 方法来返回一个新增的用JSON表示的视频文档。

## 第2步：创建一个表单

现在API已经准备好了。我们需要一个表单来新增一个视频。

在 **public > partials** 目录下创建一个新的视图 **video-form.html** 。在文件中输入以下代码：
    
    <h1>Add a Video</h1>
    <form>
        <div>
            <label>Title</label>        
            <input></input>
        </div>
        <div>
            <label>Description</label>
            <textarea></textarea>
        </div>
        <input type="button" value="Save"></input>  
    </form>

现在当用户跳转到 **/add-video** 时我们需要告诉Angular来展示这个视图。所以需要一个新的路由。

打开 **vidzy.js** 并且更新路由配置如下：

    app.config(['$routeProvider', function($routeProvider){
        $routeProvider
            .when('/', {
                templateUrl: 'partials/home.html',
                controller: 'HomeCtrl'
            })
            .when('/add-video', {
                templateUrl: 'partials/video-form.html'
            })
            .otherwise({
                redirectTo: '/'
            });
    }]);

注意这里我们还没有配置controller，因为我们还没有写controller，我们在下一步中设置。

视图和路由已经准备好了。最后，我们添加一个链接 **/add-video** 在首页中。打开 **partials>home.html** 在 **UL** 标签前面添加1个新的链接：

    <p>
        <a href="/#/add-video">Add a Video</a>
    </p>

注意在Angular应用中需要在链接前添加 **/#**。这是为了兼容老的不支持单页应用的浏览器。

让我们预览一下目前为止我们开发的页面。回到浏览器并刷新首页。你将看到添加一个视频的链接。点击链接可以看到添加视频的页面。

不得不说这个表单看起来真的很丑并且和真正应用的表单看起来差别很大。让我们给它一个漂亮、现代化的外观。

## 第3步：添加Bootstrap

我们将使用Bootstrap来为表单添加一些样式。如果你不熟悉Bootstrap，简单解释一下，它是一个用来构建现代和响应式web应用的前端CSS框架。在这个步骤中，我们将引用Bootstrap CSS文件，通过Bootstrap类来装饰我们的表单元素。

打开 **views > layout.jade**

在 **head** 标签的最后一行添加

    link(rel='stylesheet', href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css')

确认它和上一行有同样的缩进空格数

现在回到 **partials > video-form.html**。添加下面的类到HTML元素：

    <h1>Add a Video</h1>
    
    <form>
        <div class="form-group">
            <label>Title</label>        
            <input class="form-control"></input>
        </div>
        <div class="form-group">
            <label>Description</label>
            <textarea class="form-control"></textarea>
        </div>
        <input type="button" class="btn btn-primary" value="Save"></input>  
    </form>

这些都是标准的Bootstrap用来创建表单的类。更多关于怎样用Bootstrap创建现代表单的例子，请查看[Bootstrap 文档](http://getbootstrap.com/)

回到浏览器并刷新页面。

{% asset_img add.png %}

现在看起来好多了。

这个表单还没有行为。如果你点击保存按钮的话什么也不会发生，这就是我们下一步将要添加的功能。

## 第4步：实现控制器

正如我之前所说，在MVC框架中，一个控制器主要处理视图中的事件。我们将创建一个Angular控制器来处理保存按钮的点击事件。

打开 **vidzy.js** 并在文件末尾输入下列代码

    app.controller('AddVideoCtrl', ['$scope', '$resource', '$location',
        function($scope, $resource, $location){
            $scope.save = function(){
                var Videos = $resource('/api/videos');
                Videos.save($scope.video, function(){
                    $location.path('/');
                });
            };
        }]);

这个控制器有3个依赖：**$scope**是控制器和视图之间的胶水，**$resource**用来调用RESTful API，**$location**用来改变浏览器地址栏的URL。所有这些已经在Angular服务中构建。

在控制器中，我们在 **$scope** 上定义 **save** 方法。这个方法将在用户点击保存按钮时被调用。稍后将它挂载在视图上，先来看看方法中的逻辑。

首先，我们调用 **$resource** 方法来传递API中的地址（**/api/videos**），返回一个对象来与API交互。在最后一节中，我们使用 **query** 方法来获取所有的视频。这里，我们使用 **save** 方法来提交一个视频给API。

**videos.save** 方法需要两个参数：用来提交的对象和回调函数（当异步调用执行完成时调用）。在回调函数中，我们使用 **$location** 服务来修改浏览器地址到网站的根路径。Angular知道根URL是绑定到home视图的。它将展示home页面给用户。

打开 **partials > videos-form.html** 如下修改input域

    <div class="form-group">
        <label>Title</label>        
        <input class="form-control" ng-model="video.title"></input>
    </div>
    <div class="form-group">
        <label>Description</label>
        <textarea class="form-control" ng-model="video.description"></textarea>
    </div>

**ng-model**属性是另一个用来绑定数据的指令。通过它，我们告诉Angular如果用户点击这个按钮，它将自动更新引用$scope的属性。在第一个例子中，当文本框的值改变时，Angular将自动修改 **$scope.video.title**。

接下来修改按钮的声明如下：

    <input type="button" class="btn btn-primary" value="Save" ng-click="save()"></input>

**ng-click**属性也是Angular的另一个用来处理HTML元素点击事件的指令。通过这个指令，我们告诉Angular如果用户点击这个按钮，它将执行 **$scope**上的 **save**方法。

最后在路由中注册一个新的控制器

    .when('/add-video', {
            templateUrl: 'partials/video-form.html',
            controller: 'AddVideoCtrl'
        })

现在已经完成了，测试一下这个应用。回到浏览器，填写并提交表单。你将在列表中看到一个新的视频。

快速总结一下这一节中学到的知识。我们用Express创建了一个新的API端点然后使用Monk来存储一个视频文档到Mongo。然后，我们创建了一个Angular视图并通过表单添加一个视频。我们通过使用Bootstrap来美化了表单。最后，我们创建控制器来处理视图中的点击事件。在处理点击事件中，我们使用 **$resource**服务来提交数据给服务端。

在下一节中，我们将添加一个编辑功能。

- - - 
博客：http://yalishizhude.github.io
作者：[亚里士朱德](http://yalishizhude.github.io/about/)