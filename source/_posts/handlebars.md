title: handlebars玩家指南
date: 2016-01-22 00:19:02
tags:
- html
categories: html
---


{% asset_img handlebars.png %}

>提示：文中 “{ {” 、“} }”，在实际使用中用双花括号，中间无空格。

写这篇文章也是因为当初我为了实现一个模板分页的某个功能（这个问题以及解决方法最后说），花了不少时间将官网看了几遍，试验了很久之后依然没有成功，然后凭着一股崛起继续钻研终于解决了这个问题。此时发现handlebars的东西基本上也了解得差不多了，所以干脆抽时间写篇文章整理一下。
<!-- more -->

# 为什么需要模板引擎

关于前端的模板引擎，我用一个公式来解释

                模板引擎 
    模板 + 数据 ========> html页面

模板引擎就像是html的解析生成器，将对应的模板填充完数据之后生成静态的html页面。它可以在浏览器端（比如angular中指令所用的模板）也可以在服务器端执行，不过一般用于服务器端。因为它的一个作用是抽象公共页面来重用，如果在服务端填充数据，可以减少回填数据给页面的ajax请求，从而提升浏览器端整体页面渲染速度。

# 那些年我用过的模板引擎

接触过的模板引擎不算多，最早应该是jsp，本质上也是一种模板引擎，再到功能稍微强大的freemarker，这两种都是属于java语系的。js语系的jade和ejs我都有所接触，不过不常用，jade那种类python的语法规则以及较低的解析效率都让我不敢兴趣，Express框架也只是早起将其作为模板引擎。后来换成了强大的ejs，无论是功能还是写法上都接近jsp了。直到最新的Express4发布，默认改为了弱逻辑的比较简洁的模板引擎handlebars。

我使用handlebars有以下几个原因：
* 这次新项目前端框架搭建基于Express4，模板引擎只能在ejs/jade/hogan/hbs中选择一个。
* 默认是handlebars，虽不知道原因，想必有其原因。
* 看过“去哪儿”的前端技术分享，他们就是在handlebars上进行封装的，证明已经有人填过坑了，可以一试。
* 开始比较看好ejs，但是官网文档被强了，相比之下handlebars的文档比较清晰，还有实例，虽然逻辑结构比较混乱，但是基本无障碍。

# 码解handlebars

运行环境：Express4、hbs4
未接触Express或hbs的可以先看[这里](http://www.expressjs.com.cn/4x/api.html#res.render)

## 初级玩家：表达式

数据：

    { 
        title: 'Express', 
        obj:{
            version: 'v4.3', 
            category: 'node', 
            "date~": '2016'
        }
    }

模板：

    <p>{ {title} }</p>
    <p>{ {obj.version} }</p>
    <p>{ {obj/category} }</p>
    <p>{ {obj.date~} }</p>

html页面：

    Express
    v4.3
    node

handlebars中变量都添加双花括号来表示（类似Angular），对比ejs的"<%%>"来说看起来没什么区别，其实这是很人性化的，想一下你键盘上的位置，再考虑按这几个字符的难易程度你就懂了。
其中要访问变量的属性值时可以用类似json格式的"."，也可以用"/"。

*其中变量名不可包含以下字符。如果包含则不被解析，如上的"\{\{obj.date~\}\}"。*

    空格 ! " # % & ' ( ) * + , . / ; < = > @ [ \ ] ^ ` { | } ~

但可以用 **"** , **'** , **[]** 来转译这些特殊字符。

这一条规则意味着 **"&&","||","!"这类逻辑判断是不能出现在表达式中的！** （看着这一条是不是觉得弱爆了，要不然怎么叫若逻辑模板引擎呢~哈哈，不过当然有另外的解决办法）。

## 中级玩家：helper

英语水平有限，实在找不到一个恰当的词来翻译它了。可以理解为它是注入到模板中的一个函数，用来接收参数并进行逻辑处理。

### 默认helper
#### if else

```
  { {#if author} }
    <h1>{ {firstName} } { {lastName} }</h1>
  { {else} }
    <h1>Unknown Author</h1>
  { {/if} }
```

```
{ {#if isActive} }
  <img src="star.gif" alt="Active">
{ {else if isInactive} }
  <img src="cry.gif" alt="Inactive">
{ {/if} }
```

和一般的编程语言的 **if-else** 代码块是差不多的，不过再次重申由于上面提到的特殊字符，所以if条件中是不能有逻辑表达式的，只能是变量或者值。

#### unless

还是因为上面提到的那些字符，handlebars不支持逻辑非("!")，所以又有了一个与if相反的helper

```
  { {#unless license} }
  <h3 class="warning">WARNING: This entry does not have a license!</h3>
  { {/unless} }
```

上面这段代码就等价于

```
{ {#if license} }
{ {else} }
<h3 class="warning">WARNING: This entry does not have a license!</h3>
{ {/if} }
```

#### each

都知道each相当于for循环。不过有些地方需要注意：
* 可以用相对路径的方式来获取上一层的上下文。（上下文概念跟js中的上下文差不多，比如在each passage代码块内，每一次循环上下文一次是passage[0],passage[1]...）
* 一些默认变量，@first/@last 当该对象为数组中第一个/最后一个时返回真值。如果数组成员为值而非对象，@index表示当前索引值，可以用@key或者this获取当前值
* 可以用 `as |xxx|`的形式给变量起别名，循环中通过别名可以引用父级变量值。当然也可以通过相对路径的方式引用父级变量。
```
{ {#each passage} }
    { {#each paragraphs} }
      { {@../index} }:{ {@index} }:{ {this} }</p>
    { {else} }
      <p class="empty">No content</p>
    { {/each} }
{ {/each} }
```

```
{ {#each array as |value, key|} }
  { {#each child as |childValue, childKey|} }
    { {key} } - { {childKey} }. { {childValue} }
  { {/each} }
{ {/each} }
```

同时也可以用来遍历对象，这时@key表示属性名,this表示对应的值

```
{ {#each object} }
  { {@key} }: { {this} }
{ {/each} }
```

#### with

类似js中的with，可以配合分页使用，限定作用域。

```
{ {#with author as |myAuthor|} }
  <h2>By { {myAuthor.firstName} } { {myAuthor.lastName} }</h2>
{ {else} }
  <p class="empty">No content</p>
{ {/with} }
```

#### lookup

这个用于以下这种并列数组的情况，可以按照索引来找兄弟变量对应的值。理解起来有些困难，直接看代码

```
{
    groups: [
        {id: 1, title: "group1"},
        {id: 2, title: "group2"},
    ],
    users: [
        {id:1, login: "user1", groupId: 1},
        {id:2, login: "user2", groupId: 2},
        {id:3, login: "user3", groupId: 1}
    ],
    infos: [
        'a','b','c'
    ]
}
```


```
<table>
    { {#each users} }
        <tr data-id="{ {id} }">
            <td>{ {login} }</td>
            <td data-id="{ {groupId} }">{ {lookup ../infos @index} }</td>
        </tr>
    { {/each} }
</table>
```

```
user1   a
user2   b
user3   c
```

这里在users数组中按照索引值引用infos数组中对应的值，如果想引用groups中的groupId呢？很简单，用with。

```
<table>
    { {#each users} }
        <tr data-id="{ {id} }">
            <td>{ {login} }</td>
            <td data-id="{ {groupId} }">{ {#with (lookup ../groups @index)} }{ {title} }{ {/with} }</td>
        </tr>
    { {/each} }
</table>
```

### 自定义helper

内置的helper不够强大，所以通常需要写js代码自定义helper，先看一个简单的单行helper。

#### 行级helper

##### 传值

数值、字符串、布尔值这种常规数据可以直接传入，同时也可以传递JSON对象（但只能传一个），以key=value这种形式写在后面，最后就可以通过参数的hash属性来访问了。

模板

    { {agree_button "My Text" class="my-class" visible=true counter=4} }

代码

    hbs.registerHelper('agree_button', function() {
     console.log(arguments[0]);//==>"My Text"
     console.log(arguments[1].hash);//==>{class:"my-class",visible:true,conter:4}
    }

##### 传变量

传变量时可以用this指针来指代它访问属性，通过逻辑判断后可以返回一段html代码，不过太建议这样做。考虑以后的维护性，这种html代码和js代码混合起来的维护性是比较差的，如果要抽象层组件还是使用分页比较好。

模板：

    { {agree_button person} }

注册helper：

    hbs.registerHelper('agree_button', function(p) {
      console.log(p===this);//==> true
      var blog = hbs.handlebars.escapeExpression(this.person.blog),
          name = hbs.handlebars.escapeExpression(this.person.name);
    
      return new hbs.handlebars.SafeString(
        "<a href='"+blog+"'>"+ name + "</button>"
      );
    });

数据：

    var context = {
        person:{name: "亚里士朱德", blog: "https://yalishizhude.github.io"} };
    };

html页面：

      <a href="https://yalishizhude.github.io">亚里士朱德</a>

当内容只想做字符串解析的时候可以用 **escapeExpression** 和 **SafetString** 函数。

#### 块级helper

块级helper获取参数的方式跟之前差不多，只是最后多了一个参数，这个参数有两个函数`fn`和`revers`可以和`else`搭配使用。后面将会讲解。

模板：

```
{ {#list nav} }
  <a href="{ {url} }">{ {title} }</a>
{ {/list} }
```

注册helper：

```
Handlebars.registerHelper('list', function(context, options) {
  var ret = "<ul>";

  for(var i=0, j=context.length; i<j; i++) {
    ret = ret + "<li>" + options.fn(context[i]) + "</li>";
  }

  return ret + "</ul>";
});
```

数据：

```
{
  nav: [
    { url: "https://yalishihzude.github.io", title: "blog" },
    { url: "https://www.github.com/yalishizhude", title: "github" },
  ]
}
```

html页面：

```
<ul>
    <li>  <a href="https://yalishizhude.github.io">blog</a> </li>
    <li>  <a href="https://www.github.com/yalishizhude">github</a> </li>
</ul>
```

#### 自定义helper

each的index变量比较常用，但是它是从0开始的，往往不符合业务中的需求，这里写个helper来扩展一下。

注册helper：
```
hbs.registerHelper('eval', function(str, options){
    var reg = /\{\{.*?\}\}/g;
    var result = false;
    var variables = str.match(reg);
    var context = this;
    //如果是each
    if(options.data){
      context.first = context.first||options.data.first;
      context.last = context.last||options.data.last;
      context.index = context.index||options.data.index;
      context.key = context.key||options.data.key;
    }
    _.each(variables, function(v){
      var key = v.replace(/{ {|} }/g,"");
      var value = typeof context[key]==="string"?('"'+context[key]+'"'):context[key];
      str = str.replace(v, value);
    });
    try{
      result = eval(str);
      return new hbs.handlebars.SafeString(result);
    }catch(e){
      return new hbs.handlebars.SafeString('');
      console.log(str,'--Handlerbars Helper "eval" deal with wrong expression!');
    }
  });
```

模板：

```
{ {#each list} }
{ {eval '{ {index} }+1'} }
{ {/each} }
```

上面说到if不支持复杂的表达式，如果是“&&”操作还可以用子表达式来实现，更加复杂的就不好办了，这里我写了一个helper来实现。

注册helper：
```
hbs.registerHelper('ex', function(str, options) {
    var reg = /\{\{.*?\}\}/g;
    var result = false;
    var variables = str.match(reg);
    var context = this;
    _.each(variables, function(v){
      var key = v.replace(/{ {|} }/g,"");
      var value = typeof context[key]==="string"?('"'+context[key]+'"'):context[key];
      str = str.replace(v, value);
    });
    try{
      result = eval(str);
      if (result) {
        return options.fn(this);
      } else {
        return options.inverse(this);
      }
    }catch(e){
      console.log(str,'--Handlerbars Helper "ex" deal with wrong expression!');
      return options.inverse(this);
    }
  });
```

模板：

```
{ {#ex "{ {state} }==='submiting'"} }
<i class="icon cross-danger">1</i>
{ {else} }
<i class="icon cross-success">2</i>
{ {/ex} }
```

先将整个逻辑表达式作为一个字符串传入，然后替换其中的变量值，最后用eval函数来解析表达式，同时增加异常处理。

## 高级玩家：partial

比较推崇使用分页来实现组件化。分页跟helper一样需要先注册。在hbs模块中可以批量注册，比较简单。

`hbs.registerPartials(__dirname + '/views/partials');`

### 基础引用
用“>”来引用模板，这种情况一般用来处理页头页尾这种简单的分页。后面可以传入参数。
`{ {> myPartial param} }`

当使用块级表达式时，我们通常添加“#”，而分页是“>”，所以块级分页使用“#>”，这里表示如果layout分页不存在则显示块内的内容My Content。
```
{ {#> layout } }
  My Content
{ {/layout} }
```

### 动态分页

当然也可以用表达式来代替分页名称

`{ {> (whichPartial) } }`

当分页中一部分代码是固定的，另一部分是变化的时候，可以在分页中添加“@partial-block”，这时当引用这个分页时，在内部编写代码将会填充到这个位置。

partial.hbs：
```
亚里士朱德
{ {> @partial-block } }
```

模板：
```
{ {#>partial} }
https:yalishizhude.github.io
{ {/partial} }
```

html页面：
```
亚里士朱德
https:yalishizhude.github.io
```

### 内联分页

当有多段代码需要填充到分页时,可以用如下方法。分页中内嵌分页变量，模板中通过内联分页的方式传入。

模板：
```
{ {#> partial} }
  { {#*inline "nav"} }
    亚里士朱德
  { {/inline} }
  { {#*inline "content"} }
    https://yalishizhude.github.io
  { {/inline} }
{ {/partial} }
```

partial.hbs：
```
<div class="nav">
  { {> nav} }
</div>
<div class="content">
  { {> content} }
</div>
```

html页面：
```
<div class="nav">
    亚里士朱德
</div>
<div class="content">
    https://yalishizhude.github.io
</div>
```

## 大师级玩家：API

本文列举的只是handlebars中最重要和常用的功能，更多细碎的功能可以去查看
[官方API](http://handlebarsjs.com/reference.html)。


# 开头的问题

>我想将导航条写成一个分页(partial)，导航条左边的文字标题是可以通过参数传递的，但是右边的内容可能是文字、图片其它元素，需要具体业务自定义实现。我又不想把html代码写在js中，所以希望在模板中将这段未知的模板代码填充到分页中进行展现。我在官网文档中找到了 \{\{>@partial-block\}\}来实现此功能，但是本机实验一直解析报错。
解决过程：
    这个问题原因可能有两个，一是官方文档有错，二是本机环境的插件有问题（Express用hbs模块，该模块封装了handlebars引擎模块）。为了验证官方文档的正确性，我找到了一个在线handlebars解析器，输入文档中的代码时可以正确解析，那么只可能出现在hbs模块了。这时在github上找到hbs模块最新版本为4，查看本地版本为3，更新后果然可以正常解析了。

# 总结

handlebars让我们看到一个好的插件应该有的特征：
* 可识别性。接口简单，使用方便，容易上手。
* 高可用性。自带常用一些功能（helper），不求多而求精。
* 可扩展性。复杂的业务逻辑，开发人员可以自定义helper去扩展和实现。

- - -
>作者：亚里士朱德
>博客：http://yalishizhude.github.io
