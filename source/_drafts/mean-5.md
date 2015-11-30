title: 【译】基于MEAN的全栈开发实例教程5：实现编辑功能
tags:
tags:
  - node.js
  - mean
categories: node.js
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




*如果觉得阅读这篇文章有收获，不妨点个赞吧^_^*

- - - 
博客：http://yalishizhude.github.io
作者：[亚里士朱德](http://yalishizhude.github.io/about/)