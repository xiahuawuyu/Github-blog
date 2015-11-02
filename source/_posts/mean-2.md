title: 【译】基于MEAN的全栈开发实例教程2：搭建开发环境
date: 2015-10-17 16:43:39
tags:
- node.js
- mean
categories: node.js
---


>原文地址 https://blog.udemy.com/node-js-tutorial
>感谢来自Udemy的Samantha来信分享

最近有些忙，更新可能不及时，如有兴趣希望大家去看原文网站。

<!-- more -->

# 搭建开发环境
在我们开始之前，为了开发MEAN应用你需要提前安装一些开发工具。安装这些工具需要15-20分钟。安装完成后，你就有了一个对于MEAN应用的开发环境，并且今后不需要再次安装。
所以请先安装我列举的这些工具。如果你已经安装了其中某些工具的话，可以跳过相关部分。

## 安装Sublime Text
Sublime Text 是一个轻量级而且功能强大的代码编辑器。你可以使用任何编辑器来构建node应用，但是如果你之前没有使用过sublime的话，我建议你尝试一下sublime。你可以在http://sublimetext.com网站上进行下载。
## 安装Mongo
登陆http://mongodb.org 然后点击 **Download MongoDB**。按照官网上提供的文档进行安装。安装过程很简单，不像SQL Server那样需要半个多小时，只需要一两分钟即可。
安装完Mongo，你需要按照下面的操作来运行它。你需要创建一个目录用来存储Mongo的数据库文件。这个目录对于当前用于必须有写权限。然后你需要启动MongoD(Mongo Daemon)，这是一个用来处理数据请求的后台进程。
默认情况下，MongoD将会把数据存储在系统盘的 **/data/db**目录下(如果提示错误不存在，请自行创建)。在本教程中我建议你保持默认设置。如果你希望修改这个路径，请参考官网上的指令进行修改。
接下来让我们在默认配置下启动Mongo
**对于windows用户**
用管理员权限打开命令行窗口

    > md \data\db
    > cd “C:\Program Files\MongoDB\Server\3.0\bin” (你的MongoDB安装目录)
    > mongod

注意你可以将MongoD设置为windows服务，这样的话你就不用每次从命令行来启动了。具体设置方法可以参考MongDB的官网。
然后你可以看到一个弹出窗口，显示 MongoD listening for network connections. Give access to MongoD.
**对于Mac用户**
打开终端

    $ sudo mkdir -p /data/dbmd 
    $ whoami
    moshfeghhamedani
    $ sudo chown moshfeghhamedani /data/db
    $ mongod
你将看见MongoD在命令行弹出窗口或者终端中执行正在等待连接。
{% asset_img mongod.png %}
如果你在启动MongoD时发现了任何问题，最好查看MongoDB的官网然后进行完整安装。

## 安装Node
登陆https://nodejs.org并且点击安装。不管是使用的是windows还是Mac，它将提供合适的装程序。

安装Node的时候会自动安装NPM（Node Package Manager）。NPM对于Node来说有点像Ruby Gems对于Ruby和NuGet对于.NET。我们通过NPM来下载和安装开源可复用的包/模块到应用中。

## 安装Express Generator
Express Generator是一个用来搭建应用的Node模块。为了安装Express Generator，我们需要打开另一个Mac的终端或者windows的命令提示窗口，
然后执行：
    
    npm install -g express-generator
`-g`参数代表全局安装。

## 搭建一个项目
所有的工具都已经安装完毕。现在让我用Express Generator搭建一个框架。我们将开发一个适用于录像租赁店的叫Vidzy的应用。打开终端窗口，选择一个合适的目录来创建项目：

    express Vidzy
Express Generator 将在Vidzy目录下搭建一个应用。
现在在你喜欢的代码编辑器中打开Vidzy文件夹。如果你使用的是Sublime，你可以把这个文件夹拖入Sublime。
下面是目录结构
    
    bin
        www
    public
        images
        javascripts
        stylesheets
    routes
        index.js
        users.js
    views
        error.jade
        index.jade
        layout.jade
    app.js
        package.son
**public** 我们将存储一些公共资源到这个目录下，例如javascript文件、样式文件、图片等。
**routes** 包括一系列的javascript文件，每一个文件都为该应用的给定模块定义了一些路由以及业务逻辑。
**views** 包括了应用中的视图文件。Express支持很多常见的模板引擎例如：Jade，Haml，EJS，Handlebars等。Jade是默认的模板引擎。
**app.js**程序的主入口。包括一些程序配置和声明。
**package.json**每个Node应用都有一个这样的文件。这个文件用来描述当前应用的信息和依赖的插件。
我们打开pakcage.json，可能看到如下信息：

    {
      "name": "Vidzy",
      "version": "0.0.0",
      "private": true,
      "scripts": {
        "start": "node ./bin/www"
      },
      "dependencies": {
        "body-parser": "~1.13.2",
        "cookie-parser": "~1.3.5",
        "debug": "~2.2.0",
        "express": "~4.13.1",
        "jade": "~1.11.0",
        "morgan": "~1.6.1",
        "serve-favicon": "~2.3.0"
      }
    } 
在文件中，我们定义了程序的名称和版本以及依赖模块。所有这些依赖模块都是用Node编写的模块。

## 安装依赖模块
当你通过Express Generator生成一个应用时，这些依赖模块并没有被安装。它们只是在package.json文件中进行了配置。你需要单独安装这些依赖。
来安装这些依赖，首先返回到控制台并且输入命令：
    
    cd Vidzy
    npm install
安装需要花费一些时间。NPM将参照 **package.json** 文件中定义的依赖。然后它将从NPM仓库中下载这些依赖到一个叫做 **node_modules** 的目录中。让我们看看这些模块吧。
在 **Vidzy** 文件夹中，进入 **node_modules/express**，注意这个目录下有另一个 **package.json**用来定义Express.js的依赖模块。所以，这里也有另一个 **node_modules**目录来存储依赖模块。这就是一个Node应用的常见目录结构。每一个模块都有一个 **package.json**文件和一个 **node_modules** 文件夹。

## 安装Nodemon
当你启动Node应用的时候，一个用来接收请求的最基本的web服务器就在3000端口上启动了。如果你修改了代码，这些改变将不会生效直到你重启了服务器。频繁的重启服务器来使代码生效是一件蛋疼的事情。为了解决这个问题，我们使用 **Nodemon**，这个模块在检测到源文件修改时自动重启web服务器。
安装Nodemon：

    npm install nodemon -g

## 安装Monk
Monk是一个用来读写MongoDB的Node模块。
安装monk：

    npm install monk --save
`--save`参数告诉NPM将这个依赖加入到package.json文件中。这样做的好处就是你将代码提交到版本库，别人将代码签出，所有的依赖模块都可以从就package.json中读取出来。（也就是说我们不需要保存这些第三方模块，任何时候我们搭建项目只需要读取这个package.json文件即可安装，减少了项目的维护代码）。然后只需要简单的执行 **npm install**，然后自动安装这些引用模块。这就是我们搭建应用框架的时候需要做的事情。

## 运行应用
太棒了！我们已经安装了所有需要的工具。现在是时候来运行应用了。从控制台进入Vidzy目录输入以下命令：

    nodemon
Nodemon将在3000端口上启动你的web服务器。你可能会看到一个弹出窗口显示Node正在侦听连接。
现在启动你的浏览器跳转到 

http://localhost:3000

这就是你的第一个express应用。

{% asset_img express.png %}
接下来的几个章节，我们将为这个录像租赁店应用开发各种功能。

- - - 
博客：http://yalishizhude.github.io
作者：[亚里士朱德](http://yalishizhude.github.io/about/)