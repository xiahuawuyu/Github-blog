title: 【译】基于MEAN的全栈开发实例教程3：通过Angular展示数据
tags:
  - node.js
  - mean
date: 2015-11-02 21:36:35
categories: node.js
---

>原文地址 https://blog.udemy.com/node-js-tutorial
>感谢来自Udemy的Samantha来信分享

# 从数据库中查询所有视频
首先，我们来实现一个简单的功能：在首页上展示数据库中所有的视频。有几种方式来实现这个功能。我们可以从前端到后端开发，也可以反过来。这并没有什么对错，不过在本教程中，处于教学原因我推荐从后端开始开发。
我们将通过以下几个步骤来实现：
1. 我们将在Mongo中创建一个数据库并且构建一些视频文件。
2. 然后我们通过Express在数据库中创建一个API
3. 最后我们用Angular来调用API并显示这些数据
如果你对这些技术没有任何经验也并无大碍。在本章节中，将覆盖这些技术的基础知识。然而，学习起来可能会有一点曲折。请保持耐心，因为一旦我们实现了接下来这些功能，在你再次运用这些概念的时候将会变得得心应手。

<!-- more -->

## 第1步：构建数据库
我们怎么通过数据文件来构建MongoDB数据库？MongoDB有一个可以通过控制台访问的脚本，然而通过脚本访问并不是很友好，所以为了开发变得简单，我们将用到一个免费的工具——RboMongo。登陆到 http://robomongo.org 然后下载适合你操作系统的安装程序。
启动RoboMongo。你将看见一个用来连接MongoDB服务器的对话框
{% asset_img robomongo-1.png %}
点击顶部的 **Create**按钮。
将连接名称改为 **localhost**。注意连接地址指向的是**localhost:27017。默认情况下MongoDB将在27017端口上启动。
{% asset_img robomongo-2.png %}
如果你点击 **Test**按钮，你可能看到一个类似这样的错误“Authorization skipped by you”。不用担心，忽略这个错误连接你本地的MongoDB。
保存配置的连接。回到 **Connect**对话框。连接 **localhost**。
在 **View**菜单中，勾选 **Explorer**选项。现在你的RoboMongo看起来应该是这样：
{% asset_img robomongo-3.png %}
在 **Explorer**面板，右键 **localhost**选择 **Create Database**。命名数据库为 **vidzy**。展开 **vidzy**，右键 **Collections**然后点击
 **Create Collection**。在MongoDB中，一个集合就类似于关系型数据库中的一张表。将这个集合命名为 **videos**。然后这个集合就显示在了列表中。
 接下来右键 **videos** 集合然后选择 **Insert Document**。1个文档再MongoDB中类似关系型数据库中的1条记录。而MongoDB文档与之不同的是可以包含其它的文档。在Mongo中，我们使用JSON格式来展现文档。复制粘贴下面的代码到对话框中来新增一个视频文档：

    {
     "title" : "Terminator Genisys",
     "genre" : "SciFi",
     "description" : "When John Connor, leader of the human resistance, sends Sgt. Kyle Reese back to 1984 to protect Sarah Connor and safeguard the future, an unexpected turn of events creates a fractured timeline."
    }
注意：在粘贴这些代码之前请确保对话框中的内容已经清除，不然可能会得到一个非JSON对象。
重复上一步继续添加两个文档到videos集合：

    {
     "title" : "The Lord of the Rings",
     "genre" : "Fantasy",
     "description" : "A meek hobbit of the Shire and eight companions set out on a journey to Mount Doom to destroy the One Ring and the dark lord Sauron."
    }
    {
     "title" : "Apollo 13",
     "genre" : "Drama",
     "description" : "NASA must devise a strategy to return Apollo 13 to Earth safely after the spacecraft undergoes massive internal damage putting the lives of the three astronauts on board in jeopardy."
    }
现在右键videos集合并选择 **View Documents。你将在 **videos**集合中看见3个文档。
{% asset_img robomongo-4.png %}
注意到每个文档都有一个由MongoDB自动生成的ID。
大功告成！我们的数据库准备就绪。现在，让我们用Express创建一个API来获取这些视频文档。
## 第2步：通过Express创建1个API
在这个步骤中，你将学习到关于Node模块系统，Express路由和用Monk从MongoDB中获取数据。
用你最喜欢的代码编辑器在项目根目录中打开app.js。文件中第1部分包含了几个 **require**函数调用。 **require**方法是Node中内置方法之一，主要用来引用其它文件中定义的模块：

    var express = require('express');
    var path = require('path');
    var favicon = require('serve-favicon');
    var logger = require('morgan');
    var cookieParser = require('cookie-parser');
    var bodyParser = require('body-parser');
第2部分引入了我们的路由模块。1个路由模块定义了1个或多个关联的端点以及对应的处理器。在这个由Express Generator生成的示例应用中，我们有两个路由模块： **index** 和 **users**：

    var routes = require('./routes/index');
    var users = require('./routes/users');
让我们看一看其中的一个路由模块，打开 **rutes>index.js**。你将看到以下代码：

    var express = require('express');
    var router = express.Router();

    /* GET home page. */
    router.get('/', function(req, res, next) {
     res.render('index', { title: 'Express' });
    });

    module.exports = router;
来分析一下这段代码。

在第1行，我们在当前模块引用了Express。当使用 **require**方法时，依赖于目标模块是怎样实现的， **require**方法可能返回1个方法或者对象。在这个例子中，这个 **express**变量是1个对象。它提供了一个叫做 **Router**的方法，我们在第2行就调用了这个方法。用来访问Express中的路由对象。我们用1个路由来定义我们应用中的端点。我们在这些端点中接收请求。每个端点将会被关联到1个路由处理器，处理器负责处理在端点中收到的请求。

现在看下一行中路由配置的示例。

    router.get('/', function(req, res, next) {
      res.render('index', { title: 'Express' });
    });
我们使用路由中定义的 **get**方法来定义1个路由和它的处理器。第1个参数是这个端点；在这里，'/'代表网站的根路径或者主页。第2个参数就是路由的处理器。

在Express中，所有的路由处理器都有一个同样的签名。第1个参数是请求对象，第2个参数是响应对象，第3个参数是当前链中的下一个处理器。Express使用的中间件函数采用链式调用的方式。当Express使用中间件时，有时候你可能需要在当前链中调用下一个中间件。你可以通过 **next** 变量实现。但是当我们在处理路由的时候，我们几乎不需要这个操作，所以这里你可以安全地删除 **next** 变量。

现在看一下这个函数体。 **res** 变量代表了响应对象。这个响应对象自带了一些有用的函数。

+ **render**：用来渲染视图
+ **send**：用来发送文本内容到客户端
+ **json**：发送json对象到客户端
+ **redirect**：重定向客户端到另一个地址

在这里，我们渲染index视图，这个视图在 **views>index.jade**中已经定义了。

这就是一个路由的基础结构。我们现在需要为我们的视频创建一个RESTful API。我们将在1个类似 **/api/videos**的端点中展示我们的视频。

在 **routes** 目录下创建1个新的路由模块叫做 **videos.js** ,然后在文件输入以下代码，之后我会对这段代码进行逐行讲解。

    var express = require('express');
    var router = express.Router();
    
    var monk = require('monk');
    var db = monk('localhost:27017/vidzy');
    
    router.get('/', function(req, res) {
        var collection = db.get('videos');
        collection.find({}, function(err, videos){
            if (err) throw err;
            res.json(videos);
        });
    });
    
    module.exports = router;

头两行和之前的一样，我们引入了Express然后获取路由对象。

然后我们引入了Monk，一个用来持久化MongoDB数据的模块。另一个叫做 ** Mongoose** 的模块也可以达到这个效果。但是在本教程中，我更倾向用Monk。

之前曾经提过， **require** 方法会根据模块的实现方式来返回一个对象或者方法。当我们引入Monk的时候得到的是一个方法而不是对象。所以 **monk** 变量是一个我们通过调用来访问数据库的方法。

    var db = monk('localhost:27017/vidzy');

现在来实现我们路由处理器的逻辑。

    function(req, res) {
        var collection = db.get('videos');
        collection.find({}, function(err, videos){
            if (err) throw err;
            res.json(videos);
        });
    }

首先我们调用 **db** 对象的 **get** 方法，传入集合的名称（**video**）。它将返回一个集合对象。这个集合对象提供了一个数字和一些方法来操作集合上的文档。

+ inser
+ find
+ findOne
+ update
+ remove

这里我们使用 **find** 方法来获取集合中的所有视频。这个方法的第1个参数是一个用来过滤的对象。由于我们需要查询所有视频，我们传入一个空对象。第2个参数是一个回调方法，从数据库返回结果之后调用。这个方法遵循Node回调函数的标准协议模式——“错误优先”。在这个模式中，回调函数的第1个参数是一个错误对象，第2个参数才是返回结果。当你开发更多的Node应用的时候，你将发现更多的这种回调模式。

在这种回调中，我们首先检查 **err** 对象是否被设置。如果在查询视频文档中没有出现错误， **err** 的值是 **null**；否则它将被设置。我们抛出 **err** 来中断程序的执行并且告知用户。如果没有错误，就通过调用 **res.json** 简单地返回一个JSON对象。

看最后一行

    module.exports = router;

这一行定义了一个对象返回值，当别的模块引用这个模块时我们将返回这个对象。在这种情况下我们返回路由对象给Express。这个模块的主要功能就是获取路由并注册一些路由配置并返回。

现在还剩下一个小步骤。虽然写了一个模块来为我们的新API配置路由信息，但是我们并没有调用它。再次打开 **app.js** 然后靠近顶部查找以下代码：

    var routes = require('./routes/index');
    var users = require('./routes/users');

通过以下代码将我们的路由模块引入到应用程序模块。添加下面这行代码。

    var videos = require('./routes/videos');

将新模块复制给 **videos**变量供之后使用。将 **app.js** 往下滚动一点然后找到下面代码：

    app.use('/', routes);
    app.use('/users', users);

添加一行代码：

    app.use('/api/videos', videos);

这一行代码的作用就是让 **videos** 模块给任何以 **/api/vides**开头的路由使用。

现在来测试一下我们的API。打开浏览器输入地址  http://localhost:3000/api/videos  。你将看到以下JSON对象

{% asset_img json.png %}

我使用了 **JSONView** Chrome插件来高亮显示JSON对象。

接下来几步我们将使用Angular来构建前端代码展示这些视频。

## 第3步：添加Angular

在这一步中，你将学习到Angular的基础知识。如果你已经熟悉Angular，可以跳过这些描述，但是请拷贝这些代码到项目中。

Angular是一个用来构建单页应用（SPA）的非常流行的前端框架。它提供了路由，依赖注入，测试和MVC的结构实现的代码解耦。如果这些听起来太极客了，也不用担心。这一章将带你了解这些特性。

首先，需要添加Angular脚本到应用中。打开 **views>layout.jad** 添加以下3个脚本文件引用在 **head**的末尾（一般考虑性能会放在body标签的末端）。

    script(src='https://cdnjs.cloudflare.com/ajax/libs/angular.js/1.4.5/angular.js')
    script(src='https://cdnjs.cloudflare.com/ajax/libs/angular.js/1.4.5/angular-resource.js')
    script(src='https://cdnjs.cloudflare.com/ajax/libs/angular.js/1.4.5/angular-route.js')

确保他们的缩进空格数相等，因为jad对缩进空格非常敏感。Express Generator生成Jade视图的时候将会把两个空格当做缩进。所以你需要遵循同样的缩进并且不能省略。否则将会报错。

这些是什么脚本？第1个是Angular框架的主脚本，第2个是用来调用RESTful APIs，第3个是用来管理路由的。通过路由来定义应用导航对应展示的页面。

下一步，在 **public>javascripts** 路径下创建一个名为 **vidzy.js**的文件，在里面编写javascript代码。

在Angular脚本之后，添加 **vidzy.js** 引用

     script(src='/javascripts/vidzy.js')

请再次确保缩进空格数一致。

现在主要脚本已经引入，可以添加Angular到我们的应用了。添加Angular包括两步：

* 第1步，在HTML元素上添加 **ng-app** 属性。当Angular脚本加载完时，它将在DOM中找到这个属性然后挂载应用程序。
* 第2步，为应用创建一个Angular模块。Angular应用通常由1个或者多个模块构成。这个简单的应用，你只需要一个 **app** 模块。但是随着应用的扩展，为了提升代码结构和可维护性，你可能需要划分不同的功能到不同的模块。

打开 **layout.jade** 添加 **ng-app** 到html元素。

    doctype html
    html(ng-app='Vidzy')

在Jade中，我们使用括号来为HTML标签添加属性。当该行被Jade模板引擎渲染时，我们将获取以下HTML元素

    <html ng-app=’Vidzy’>

我们给ng-app设置的值就是应用的名称。现在我们需要创建这个模块。

打开 vidzy.js输入以下代码：

    var app = angular.module('Vidzy', []);

**Angular**现在是一个全局可用的对象， **module** 方法可以用来定义一个新的模块或者获取已有模块的引用。第1个参数和我们之前在 **ng-app** 中定义的值一致。第2个参数是一个依赖数组。这里传入一个空数组来声明当前模块不依赖任何其他模块。

我们做这些就是为了将Angular挂载到我们的应用上。接下来我们将重构首页，使用Angular来展示数据库中所有的视频。

## 第4步：用Angular重构首页

Express Generator生成的默认项目使用了Jade做为视图引擎。这些Jade视图在服务端被解析和渲染成HTML然后返回给客户端。这就是很多网页框架如何工作的。但是在本应用中，我们将使用一种不同的构建风格。我们将返回JSON给客户端（Angular）来渲染视图来替代返回HTML。下面说一说这样做的原因。

开始的时候，在本章关于“什么时候使用Node”中，我提到一种通用的场景：Node擅长在文档数据库上构建基于RESTful APIs的应用。通过这种架构，我们不必把时间花在数据转换上。我们存储JSON对象在Mongo中，通过RESTful API导出它们并且直接在客户端进行展示（通过Angular）。JSON就是Javascript和MongoDB的原生对像。所以用它来贯穿整个技术栈，我们就减少了匹配和转换数据的工作。通过从API返回JSON对象然后在客户端渲染视图，来提高性能和可扩展性。因为服务器的CPU将不会被浪费在为大量并发用户渲染视图上。另外，我们可以重用同样的API去构建另一个客户端，例如Iphone和Android app。

在这一步中，我们将用Angular视图来取代首页上默认的Jade视图。

在 **public** 下创建一个新的叫做 **partials** 的文件夹用来存储视图文件。在这个文件夹下创建一个新的文件 **home.html**，在文件中输入

    <h1>Home Page</h1>

现在，我们需要告诉Angular当跳转到这个首页时渲染这个视图。我们通过Angular路由来实现这个功能。

在 **vidzy.js** 中，改变 **app** 模块的声明如下：

    var app = angular.module('Vidzy', ['ngRoute']);

在依赖数组中我添加了一个 **ngRoute** 的引用。 **ngRoute** 是构建Angular模块中用来配置路由的。

在 **app** 模块声明中写下如下代码：

    app.config(['$routeProvider', function($routeProvider){
    $routeProvider
        .when('/', {
            templateUrl: 'partials/home.html'
        })
        .otherwise({
            redirectTo: '/'
        });
    }]);

让我来为你讲解一下。我们使用 **app** 模块的 **config** 方法来为我们的应用提供配置。这个代码将在Angular检测到 **ng-app** 并且视图启动的时候执行。 **config** 方法的参数是一个数组：

    app.config([]);

这个数组可以有0个或更多的依赖以及一个函数来实现配置逻辑。这里我们有一个依赖 **$routeProvider**，这是一个在 **ngRoute** 中国定义的模块。这就是我们修改app模块声明来依赖 **ngRoute** 的原因。配置函数接收 **$routeProvider** 作为一个参数

    app.config(['$routeProvider', function($routeProvider){
    }]);

在我们的配置函数中，我们使用 **$routeProvider** 的 **when** 方法来配置路由。

    $routeProvider
        .when('/', {
            templateUrl: 'partials/home.html'
        })

第1个参数('/')是相对路径。第2个参数是一个对象，定义了路径对应的视图(通过 **templateUrl**)。我们可以多次调用 **when** 方法，每次定义个不同的路由。最后，我们使用 **otherwise** 方法来声明如果用户浏览其他URLs，将被重定向到根路径('/')。

现在还差一点点。我们只需要做一些小小的改动来时使Jade视图映射到首页。打开 **views>index.jade** 然后改变文件的内容：
    
    extends layout
    
    block content
      div(ng-view)

我溢出了视图中之前的内容(Welcom to Express)添加了一个带有 **ng-view** 的 **div**。这个属性告诉Angular在当前dom下渲染视图。通过这个设置，用户首次进入主页时，Jade视图将会在服务端渲染并且返回给客户端。在实际项目中，站点视图将有基础的模板（）例如导航条，logo等）。它也有一个内容区（通过 **ng-view** 声明）由Angular来渲染视图。当用户通过应用来访问页面时，Angular将用不同的Angular视图来替换内容区域。这样避免了整个页面的刷新从而带来了更好的效果。这就是我们称这些应用为单页应用的原因：从本质上说只有一个页面被完整地从服务器下载，然后其他子页面只是简单的用来替换内容区。

注意：我必须再一次强调Jade对空格符非常敏感。在同一个视图中你不能混淆空格和tab键的缩进。Express Genrator默认生成的Jade视图用两个空格键来缩进。确保添加两个空格在 **div(ng-view)** 前面，否则你运行时将报错。

在最后一步之前让我们快速测试一下。回到你的浏览器，输入http://localhost:3000.你将看见我们通过Angular构建的新首页

{% asset_img home.png %}

## 第5步：实现控制器

首页已经被正确地挂载了。现在需要从服务端获取视频并渲染到首页。在Angular或其他MVC中，这是控制器的主要职责。视图只负责展现响应的数据，控制器负责为视图获取数据或者处理视图中发生的事件。

现在为我们的首页视图创建一个控制器。打开 **vidzy.js** 并且改变 **app** 模块的声明：

    var app = angular.module('Vidzy', ['ngResource', 'ngRoute']);

现在我们依赖两个模块：ngResource，用来调用RESTful APIs和ngRoute来管理路由。

接下来在文件末尾输入以下代码来创建一个控制器：
    
    app.controller('HomeCtrl', ['$scope', '$resource', 
        function($scope, $resource){
    }]);

这里我们使用 **app** 模块提供的 **controller** 方法来定义一个新的控制器。

第1个参数是1个字符串，用来定义控制器的名称。按照管理，我们通常在Angular控制器名末尾添加 **Ctrl**。

第2个参数是数组。这个数组可以引用0个或更多的字符串，每个代表了1个控制器的依赖。这里定义了依赖 **$scope** 和 **resource**。这些都是Angular的内部服务，所以她们都有一个前缀"$"。**$scope**用来传递数据给视图，**$resource**用来调用RESTful API。数组中最后一个对象是函数，这个函数就是控制器的主体。在这个例子中，我们的函数获取了两个参数 **$scope** 和 **$resource** 。因为我们依赖了 **$scope** 和 **$resource** 在函数声明之前。

让我们实现控制器的主体部分。在控制器函数内部，输入以下代码

    app.controller('HomeCtrl', ['$scope', '$resource', 
    function($scope, $resource){
        var Videos = $resource('/api/videos');
        Videos.query(function(videos){
            $scope.videos = videos;
        });
    }]);

这里我们调用 **$resouce** 方法通过给定的API端点（/api/videos）来获取一个资源对象。这个对象将提供一些方法来访问我们的 **API**。我们用 **query** 方法来获取所有视频。 **query** 方法在查询结果就绪后将得到一个回调函数。这个函数将获得我们从服务端获取的视频。最后我们将视频存储到 **$scope**对象中然后渲染到视图中。记住 **$scope** 就是视图和控制器之间的胶水。

现在我们需要改变视图来渲染视图中的列表。打开 **partials>home.html** 然后输入代码：

    <ul>
        <li ng-repeat='video in videos' ng-bind="video.title"></li>
    </ul>

我们用ul和li来渲染视频列表。li标签有一个Angular定义的属性叫做 **ng-repeat**。这些属性在Angular中叫做指令，用来为HTML元素添加一些行为。**ng-repeat**属性的值是一个类似js中foreach的表达式。**videos**变量是我们之前在 **$scope**中定义的属性。**video in videos**表示一次从数组中获取一个video。所以li元素将会被数组中的video对象重复渲染。我们用双花括号来编写表达式。这里我们简单的渲染video对象中的title属性在li标签中。

最后我们需要将这个控制器注册到路由上。回到 **vidzy.js**，改变路由配置

    .when('/', {
        templateUrl: 'partials/home.html',
        controller: 'HomeCtrl'
    })

完成了这些步骤，当用户进入网站根路径时，Angular将展示 **partials/home.html** 并且为它添加 **HomeCtrl** 控制器。

回到浏览器并刷新首页。你将看到视频列表。

{% asset_img list.png %}

如果你是一个Angular新手并且还有些困惑，没关系，在接下来的章节中我们将继续使用更多的Angular控制器，视图和路由。

总结下，本章节中，为我们的应用添加了第一个功能。我们开始用RoboMongo来连接MongoDB。我们创建了一个数据库然后填充了一些视频文档。然后我们创建了一个API用Express来导出视频列表。最后，我们添加Angular到应用中来调用API渲染视频列表。

在下一节中，我们将添加另一个功能到应用中。 

>这一部分的内容很多，翻译花费了很多时间。原文作者写教程的时候确实是很用心的，这也是我答应作者翻译这篇教程的一个原因。如果想看更多教程可以去作者的官网，如果觉得这篇教程不错，还请点个赞~3q~

- - - 
博客：http://yalishizhude.github.io
作者：[亚里士朱德](http://yalishizhude.github.io/about/)