title: git新手指南
tags:
---

### 从另一个远程分支上获取某个文件（夹）到当前分支

1. 查看所有分支，包括本地建立的分支和远程服务器上的分支

`git branch -a`

2. 签出/切换分支或分支指定文件

`git checkout <branch> [file] [-f]{强制更新，以branch版本的代码为主}`

3. 切换分支后提交代码出现冲突

`hint: Updates were rejected because the tip of your current branch is behind`
`hint: its remote counterpart. Integrate the remote changes (e.g.`
`hint: 'git pull ...') before pushing again.`
`hint: See the 'Note about fast-forwards' in 'git push --help' for details.`
先切换分支，然后拉取分支上最新的代码覆盖到本地
`git pull`
添加或者提交代码，解决冲突之后
`git push`
    
4. 拉取分支

`git checkout -b <branch_name>  本地建立 branch 並立即 checkout 切換過去`
`git branch -m <new_name>  修改分支名称`  

title: git
tags:

5. 本地分支与远程分支建立关联关系

`git branch -t <remote branch>`

6. 从远程仓库拉取代码到本地仓库

`git clone http://xxx.git`
或者
`get clone git@xxx.git`

然后
`git checkout -b <本地新分支名> <对应的远程分支名>`


## 指令大全
### reset
`git reset [file]` 
取消暂存 

###
`git checkout -- [file]` 
恢复文件

`git checkout -b [branchname] [tagname]`
在特定的版本上创建一个新的分支并切换到此分支

### remote 
查看远程仓库名 

`git remote -v` 
查看远程仓库url

`git remote add <basename> <url>`
新增远程仓库

`git remote show <basename>`
查看远程仓库详细信息

`git remote rename <old basename> <new basename>`
重命名远程仓库

### push
`git push [remote_branch] [local_branch]`
推送本地仓库代码到远程仓库，相当于svn的commit

`git push <remote base> [tag name]`
推送本地标签到远程仓库

`git push <remote base> <remote branch>:<local branch>`
将本地分支推送到指定的远程分支

### tag
查看标签（用来标记标志性的稳定版本信息）

`git tag -l '[expression]'`
查看那符合正则表达式的

`git tag -a <tag name> -m <comment>`
添加带注释的标签

`git tag -a <tag name> <md5>`
对某个版本打标签

`git tag [tag name]` 
如果没有标签名，则为查看所有标签。带标签名则为新建标签

### merge
`git merge <branch name>`
将其他分支合并到本分支

### branch
`git branch`
查看本地仓库分支

`git branch -v`
查看本地仓库分支最后一次提交情况

`git branch <branch name>`
新建分支

`git branch -d <branch name>`
删除分支

`git branch [--merged | --no-merged]`
查看已合并|未合并的本地仓库分支


## 进阶

## 设置别名

## 设置缓存
`git config --global credential.helper wincred`
开启windows缓存

6. 跳过暂存的方法

`git commit -a -m 'xx'`

