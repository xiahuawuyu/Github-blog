title: 高端唯有定制，把sublime打造成专属的IDE
date: 2015-10-20 22:49:13
tags:
- sublime
- 前端工具
categories: 前端工具
---
# 前言
用过一些IDE，如eclipse、intelliJ，这些IDE是很智能，插件也不少，但个个都不是省油的灯————内存杀手。更受不了的是10G内存eclipse占了2G+之后还是卡。
不再做全栈开发之后开始使用轻量级的编辑器，用过的编辑器有Emacs（ctrl到死实在用不惯）、Vim（比较好用，但是速度上以及插件方便程度不如sublime）、ultraedit（据说是黑客必备编辑器，插件太少）、atom（github版的sublime，一直很看好，可惜速度慢我不能接受）、sublime（速度快，插件丰富，还支持vim操作）。最终选择了受众多人追捧的sublime。
本人平常开发主要语言是javascript（jquery、angular）、html、css（bootstrap），用到一些工具如gurnt、less、git、svn。除了命令行（其实sublime也有个terminal插件，不过窗口太丑，功能也不强大，所以不如直接`win+r`来得快），基本上都在sublime这个“IDE”上操作。主要用到了以下插件：
<!-- more -->
# 代码校验、提示、优化
## Alignment
美化对其"="、":"这些符号。
## BracketHighlight
代码块括号高亮工具，可以自定义括号颜色。
{% asset_img brack.png %}
## DocBlockr
在函数上一行输入`/**`然后回车，神奇的事情发生了，jsdoc就生成了。
## Emmet
以前叫zencoding，快速编写html的一个插件。
## HTML-CSS-JS Prettify
html、css、js文件一键优化，但貌似只会优化缩进
## AngularJS
编写Angular时给出智能提示
## JQuery
JQueryAPI的智能提示
## SublimeLinter
## SublimeLinter-jshint
配合使用，支持js语法规则校验，每个js编写者必备。


# 文件保存预览
## Local History
非常推荐，智能缓存编辑过的文件，有点像本地版本管理工具。
## Markdown Preview
## MarkdownEditing
写markdown的好搭档，用来显示预览md格式文件的效果。
## Minifier
手动版js文件压缩工具。

# 版本控制
## SVN
插件功能很像小乌龟TortoiseSVN，在侧边栏上右键操作即可。
## Git
右键可视化操作，同上。

# sublime自身优化
## Dracula Color Scheme
黑白灰，一个极简主题，适合低调的开发者。
{% asset_img theme.png %}
## AdvancedNewFile
可以直接用快捷键`ctrl+alt+n`在sublime的控制台创建文件（夹）


# 自动化工具
## Grunt
IDE都有一个神奇的功能，只要保存代码，就会自动编译发布，这一点可以利用Grunt的watch插件来实现。sublime的Grunt插件只是方便调用项目中已经配置的Gruntfile.js中的任务。用`ctrl+p`输入`grunt`即可使用，智能方便。

目前听说的自动化工具有3种：Grunt、Fis、Gulp。
Grunt是比较成熟的自动化管理工具，有丰富的插件，将代码自动化分解成一个一个的任务来执行。
Fis百度出的自动化工具，应该比较符合国人习惯，如果偷懒可以考虑使用。
Gulp比较推荐，类似node.js的流处理效率较高，插件也蛮丰富，据资料显示目前人气最高的自动化工具。

# 最后补充
## 改为vim模式
vim是一个脱离鼠标操作的古老编辑器，vim的操作方式意味着通过模式的切换来执行光标定位、移动、剪切等操作，大大提高编写速度。很高兴的是sublime可以配置成一个"伪vim"。
在菜单栏上依次点击
Preferences ——> setting-user 
添加一个属性：
"ignored_packages": ["Vintage"]
## 更多
sublime能够如此之火的原因在于插件非常丰富，在packagecontrol上查看top100的插件逐个筛查也是一种高效的查找方式。
https://packagecontrol.io/browse/popular

- - - 
博客：http://yalishizhude.github.io
作者：[亚里士朱德](http://yalishizhude.github.io/about/)