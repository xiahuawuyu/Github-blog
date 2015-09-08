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
`git pull origin master`

4. 拉取分支

`git checkout -b <branch_name>  本地建立 branch 並立即 checkout 切換過去`
`git branch -m <new_name>  修改分支名称`  
=======
title: git
tags:
