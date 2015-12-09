title: Duang~简单实用的angular滚动列表特效(移动端)
date: 2015-12-02 23:22:11
tags:
  - js
  - angular
categories: angular
---

{% asset_img scrollpin.gif %}

<!-- more -->

# 故事起因

在微信端开发的一个答题页面，产品部突发奇想说要优化，做成滚动时固定，然后可以被下一个元素顶上去的效果（具体见上图，卡顿是录屏软件造成的，不是代码原因）。老大说jquery有个[pin的插件](http://www.bootcss.com/p/jquery.pin/)实现了类似效果，可以看一下。

打开网站一看，貌似是我要的效果，仔细一琢磨，原来是用浮动脱离了文档流，然后滚动时改为固定定位。浮动似魔鬼，而且也顶不起来，只能另辟蹊径了~

# 替代插件

优化需求一般对于功能需求来说优先级肯定是最后的，所以先实现功能：当题干太长时把题目与固定住。
为解燃眉之急，由于之前一直使用的也是angular-ui，所以采用了angular-ui下的轻量级指令scrollfix，一时翻不了墙，给不了网址。该插件类似jquery.pin的效果，能满足基本使用，不过就是实现不了“顶起”的效果。

# 重整思路

最近终于抽时间把页面性能、代码结构优化之后，剩下的就是这个特效的优化了。

整个操作思路还是比较简单的，当题目滚动出屏幕时题目描述继续钉在顶部而剩下的可以继续滚动，滚动到下一题题目与当前固定题目描述接触时上移，直到下一题题目描述固定在顶部。其中有两个核心问题：

**如何让题目描述平滑地固定在顶部？这里我想到了两种方法：一是用`position:fixed;`，但是这脱离了标准文档流，会导致后面元素的样式错乱，所以想到了另一个方法：伪固定，用`position:relative`，通过该表`top`值来实现“固定”效果，这是个好方法吗？显然不是，要实时计算多个元素的top值，消耗性能，容易出错。回到第一个方法，为了解决其它元素样式错乱的问题有个另外的解决方法：元素占位。**

**一开始就直接让题目描述脱离文档流，并遮住占位元素，然后用`fixed`固定和移出。**

**如何让下一题将当前题顶出？不管用`position:relative;`还是`position:fixed`，反正都是通过计算滚动位移、元素偏移值、元素高度来设置`top`值让当前题上移，出现“顶起”的效果。**

## 具体实现

部分代码如下：

html部分，pin样式让div脱离文档流，name样式div为占位元素，使用了自定义的scrollpin指令，属性值为元素高度。

    <div class="title" ng-repeat-start="sub in subjects">
        <!-- 滚动效果元素 -->
        <div class="pin" ng-bind="sub.name"></div>
        <!-- 占位元素，避免塌陷，scroll-child属性为当前元素高度-->
        <div class="name" ng-bind="sub.name" scrollpin="42"></div>
    </div>
    <div class="content" ng-repeat-end ng-bind="sub.content"></div>

指令的逻辑比较简单，绑定scroll事件之后判断滚动位移，动态改变`position`属性值和`top`值。

    .directive('scrollpin', function($window){
        return {
            link: function(scope, element, attrs){
                angular.element($window).on('scroll', onScroll);
                function onScroll(){
                    var offset = $window.pageYOffset;
                    var offsetTop = element[0].offsetTop;
                    var before = element[0].previousElementSibling;
                    if(offsetTop<offset) {
                        var move = parseInt(attrs.scrollpin||0)+offsetTop-offset;
                        before.style.position = 'fixed';
                        if(move<0&&-move<parseInt(attrs.scrollpin)){
                            before.style.top = move+'px';
                        } else {
                            before.style.top = '0';
                        }
                    } else {
                        before.style.position = 'absolute';
                        before.style.top = '';
                    }
                }
            }
        };
    })

完整代码：https://github.com/yalishizhude/angular-scrollpin
欢迎star和pull~

*如果觉得阅读这篇文章有收获，不妨点个赞吧^_^*

- - - 
博客：http://yalishizhude.github.io
作者：[亚里士朱德](http://yalishizhude.github.io/about/)