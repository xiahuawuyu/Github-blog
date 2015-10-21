title: 【译】基于MEAN的全栈开发实例教程3
tags:
---
# 从数据库中查询所有视频
首先，我们来实现一个简单的功能：在首页上展示数据库中所有的视频。有几种方式来实现这个功能。我们可以从前端到后端开发，也可以反过来。这并没有什么对错，不过在本教程中，处于教学原因我推荐从后端开始开发。
我们将通过以下几个步骤来实现：
1. 我们将在Mongo中创建一个数据库并且构建一些视频文件。
2. 然后我们通过Express在数据库中创建一个API
3. 最后我们用Angular来调用API并显示这些数据
如果你对这些技术没有任何经验也并无大碍。在本章节中，将覆盖这些技术的基础知识。然而，学习起来可能会有一点曲折。请保持耐心，因为一旦我们实现了接下来这些功能，在你再次运用这些概念的时候将会变得得心应手。
## 第1步：构建数据库
我们怎么通过数据文件来构建MongoDB数据库？MongoDB有一个可以通过控制台访问的脚本，然而通过脚本访问并不是很友好，所以为了开发变得简单，我们将用到一个免费的工具——RboMongo。登陆到http://robomong.org然后下载适合你操作系统的安装程序。
启动RoboMong。你将看见一个用来连接MongoDB服务器的对话框
{% asset_img robomongo-1.png %}
点击顶部的 **Create**按钮。
将连接名称改为 **localhost**。注意连接地址指向的是**localhost:27017。默认情况下MongoDB将在27017端口上启动。
{% asset_img robomongo-2.png %}
如果你点击 **Test**按钮，你可能看到一个类似这样的错误“Authorization skipped by you”。不用担心，忽略这个错误连接你本地的MongoDB。
保存配置的连接。回到 **Connect**对话框。连接 **localhost**。
在 **View**菜单中，勾选 **Explorer**选项。现在你的RoboMongo看起来应该是这样：
{% asset_img robomongo-3.png %}
在 **Explorer**面板，右键 **localhost**选择 **Create Database**。命名数据库为 **vidzy**。展开 **vidzy**，右键 **Collections**然后点击
 **Create Collection**。在MongoDB中，一个集合就类似于关系型数据库中的一张表。将这个连接命名为 **videos**。然后这个集合就显示在了列表中。
 接下来右键 **videos**集合然后选择 **Insert Document**。1个文档再MongoDB中类似关系型数据库中的1条记录。而MongoDB文档与之不同的是可以包含其它的文档。在Mongo中，我们使用JSON格式来展现文档。复制粘贴下面的代码到对话框中来新增一个视频文档：

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




- - - 
博客：http://yalishizhude.github.io
作者：[亚里士朱德](http://yalishizhude.github.io/about/)