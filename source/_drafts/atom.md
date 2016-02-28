title: atom这个磨人的小妖精
tags:
---

我不想花时间精力去对比sublime和atom两者的区别，只是个人喜好而已。
atom的插件数量不算多，但是该有的基本都有了，一方面试热爱github的开源精神以及国际化品牌，另一方面，atom对于git的支持更友好、完善。
在某种程度上，atom算是山寨sublime的编辑器。所以学习成本比较低。

<!-- more -->

# 绿色软件
几乎所有的安装程序都喜欢落户系统盘这个宝地。atom和sublime都是如此，为了解救我珍贵的系统盘空间，我安装了系统盘还原软件（重启还原系统盘），所以如果再让atom留在系统盘就不合适了。还好1.3版本出了一个便携功能。就是可以将atom从c盘解放出来：
比如说我的用户名是yalis
1. `C:/Users/yalis/AppData/Local/atom` 整个文件夹剪切到`D:\Work`目录下。
2. 把atom的配置文件 `C:/Users/yalis/.atom`整个文件夹剪切到`D:\Work\atom`目录下，也就是atom程序的根目录。
3. 配置环境变量`ATOM_HOME=D:\Work\atom`，同时在Path中添加%ATOM_HOME%即可。

# 云同步
重装系统，或者工作电脑切换的情况经常碰到，如果每次都要手动重新配置太麻慢了。这里可以利用github同步配置文件。atom根目录下`git init`
