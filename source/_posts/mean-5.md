title: 【译】基于MEAN的全栈开发实例教程5：实现编辑功能
tags:
  - node.js
  - mean
categories: node.js
date: 2015-11-30 22:43:00
---


>原文地址 https://blog.udemy.com/node-js-tutorial
>感谢来自Udemy的Samantha来信分享

# 编辑一个视频

在这一节中，你将看见另一个API端点，Angular视图，控制器和路由。

我们将以类似的方式从这一部分到最后一个部分。首先，我们将建立两个API端点：一个用于通过ID获取视频，另一个用于更新视频。然后，我们将添加一个链接到主页中的每个视频。当用户点击这个链接，他们将被重定向到一个由视频详情填充的表单。当他们点击保存，更改将被保存然后返回到主页。

<!-- more -->

## 第1步：创建API端点

下面这一步很熟悉，创建两个新的路由：

    GET /api/videos/{id}
    PUT /api/videos/{id}

然后打开 **routes>videos.js** 添加以下路由信息：

    router.get('/:id', function(req, res) {
        var collection = db.get('videos');
        collection.findOne({ _id: req.params.id }, function(err, video){
            if (err) throw err;
            res.json(video);
        });
    });

注意这里有一个路由参数，在一个冒号后面声明(:id)。你可以访问这个参数值通过 **req.params.id**。

除此之外，其余的这条路由配置是类似于你以前见过的。唯一的区别是，我们使用集合中的findOne方法来返回一个对象。对该方法的第一个参数是标准对象。因此，我们通过_id等于req.params.id来寻找一个文档。

创建另一个路由：

    router.put('/:id', function(req, res){
        var collection = db.get('videos');
        collection.update({
            _id: req.params.id
        },
        {
            title: req.body.title,
            description: req.body.description
        }, function(err, video){
            if (err) throw err;
            res.json(video);
        });
    });

注意我们通过 **router.put** 来定义这个路由。当这个端点上有HTTP PUT请求时这个处理器将会被调用。

通过集合中的 **update** 方法来更新一个文档。第一个参数是一个标准对象。只更新 **_id** 和 **req.params.id**
匹配的文档。第二个参数代表了需要更新的值。

这种rest接口其实非常简单。

## 第2步：创建一个编辑页面

首先我们需要为主页上的每个视频添加一个链接。打开 **partials>home.html** 如下改变LI标签。

    <li ng-repeat='video in videos'>
        <a href="/#/video/{{video._id}}">
            {{video.title}}
        </a>
    </li>

Angular绑定表达式通过视频ID来渲染动态URL。注意这个URL带有前缀`/#`来兼容老的浏览器。

现在我们需要通过一个带有表单的视图来编辑一个视频。现在我们已经有了一个带有表单的视图。所以我们我考虑重用它。

在 **vidzy.js** 中添加一个新的路由：

    .when('/video/:id', {
        templateUrl: 'partials/video-form.html'
    })

由于我们还没有创建控制器，所以在路由中还不能设置控制器。让我们来回顾一下我们的工作。

回到浏览器主页然后刷新页面。每个视频现在都由一个超链接替代。点击一个视频。你将看见一个空的表单。

下一步我们为表单添加行为：填充表单数据和处理点击保存按钮事件。

## 第3步：实现控制器

现在我们有了2个选择。我们可以创建一个新的控制器，如editvideoctrl，或使用现有的控制器（addvideoctrl）。你认为最好的解决办法是什么？答案是：没有最好的解决办法。需要看情况而定。如果2个案例（添加和编辑）有很多相似之处，则创建一个控制器来处理这两种情况。另一方面，如果两个场景有很大的不同，你会写很多丑陋的条件语句在一个控制器中。这种情况下，最好把它们分为2个不同的控制器。

在写这一步的教程之前，我开始重复使用相同的控制器但是我对最终结果感到不满意。所以，我决定把它们拆分成2个不同的控制器。

在 **vidzy.js**中，如下创建一个新的控制器：

    app.controller('EditVideoCtrl', ['$scope', '$resource', '$location', '$routeParams',
    function($scope, $resource, $location, $routeParams){   
        var Videos = $resource('/api/videos/:id', { id: '@_id' }, {
            update: { method: 'PUT' }
        });
        Videos.get({ id: $routeParams.id }, function(video){
            $scope.video = video;
        });
        $scope.save = function(){
            Videos.update($scope.video, function(){
                $location.path('/');
            });
        };
    }]);

让我解释一下这里发生了什么。

首先，这个控制器，并不像我们的 **AddVideoCtrl** 有4个依赖。这里我们有一个额外的依赖： **$routeParams** 用来访问路由参数。这种情况下，编辑中使用的视频ID将成为路由参数。

在这个控制器内，首先我们使用 **$resource** 服务来获取一个对象通过和API端点交互。但这一次，我们通过另一种方式来使用 **$resource**。

    var Videos = $resource('/api/videos/:id', { id: '@_id' }, {
         update: { method: 'PUT' }
    });

传输给端点的第一个参数是URL。这里我们有一个冒号声明的参数(:id)。因为我们在这一节中之前创建的端点都是带有路由参数的，所以我们使用参数化的路由。

    GET /api/videos/:id
    PUT /api/videos/:id

这个方法的第2个参数是1个对象，为路由参数 **:id** 提供默认值。

    { id: '@_id' }

这里 '@\_id' 告诉Angular在请求对象中查找一个叫做 \_id 的属性。所以当我们发送一个PUT请求 **/api/videos/:id**，Angular将使用视频对象的\_id属性来设置路由中的:id参数。

**$resource** 方法第3个参数用来扩展 **$resource** 服务。

    {
    update: { method: 'PUT' }
    }

只有Angular的开发者才知道，在某些情况下，默认你不能用$resource服务发送HTTP PUT请求，你需要扩展它通过一个使用HTTP UPT的 **update** 方法。

下面我们通过给定的ID使用 **Videos.get** 来获取这个视频。

    Videos.get({ id: $routeParams.id }, function(video){
        $scope.video = video;
    });

现在实现在页面加载的时候填充表单。**Videos.get** 方法的第一个参数为路由提供了第一个参数 **:id**。我们使用 **$routeParams.id** 来获取浏览器地址栏中的这个参数。还记得我们为编辑页面定义的路由吗？

    .when('/video/:id', {
        templateUrl: 'partials/video-form.html',
    })

这里我们使用一个路由参数（:id）。然后我们通过 **$routeParams** 来访问它。

在 **Videos.get** 的回调方法中，我们从服务端获得返回的视频然后将它存储在 **$scope** 中。同时通过Angular的双向数据绑定在后台运行，这个表格将会被我们的视屏对象自动填充。还记得 **ng-model** 吗？我们将输入域绑定到$scope对象的属性上。任何在输入域上发生的改变将会反射到$scope，反之亦然。

最后在控制器中，我们定义一个 **save** 方法，当保存按钮被点击时调用。

    $scope.save = function(){
        Videos.update($scope.video, function(){
            $location.path('/');
        });
    }

注意这里，我们用 **Videos.update** 来替代 **Videos.save**。这是我们早在扩展 **$resource** 服务的时候就定义的新方法。这里将发送一个HTTP PUT请求给我们的API端点。

到这里差不多完成了。新控制器已经写好了。我们只需要添加引用到路由配置中。如下改变路由配置：

    .when('/video/:id', {
        templateUrl: 'partials/video-form.html',
        controller: 'EditVideoCtrl'
    })

让我们测试这个新功能。返回到浏览器，刷新主页。选择一个视频。做一些修改，点击保存按钮。一切都应该工作。

在下一节中，我们将添加一个功能，来使我们的视频租赁商店的应用程序具有完整的增删改查功能。

*如果觉得阅读这篇文章有收获，不妨点个赞吧^_^*

- - - 
博客：http://yalishizhude.github.io
作者：[亚里士朱德](http://yalishizhude.github.io/about/)