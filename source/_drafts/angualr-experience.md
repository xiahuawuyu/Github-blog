title: angualr开发小结
tags:
---


## 优化

优化前

    for(var i=0;i<document.querySelectorAll('[mask4me]').length;i++){
          var element = document.querySelectorAll('[mask4me]')[i];
          if(id){
            mask.style.display = '';
            document.body.style.overflow = 'hidden';
            if(element.getAttribute('mask4me')===id) {
              element.style.zIndex = 100;
            }
          } else {
            if('100'===element.style.zIndex){
              if(element.children[1].innerText) { //被选中，添加选中样式
                if(element.className.indexOf('ans-option-select')<0)element.className = element.className.replace('ans-option', 'ans-option-select');
                var e = angular.element(element);
                for(var j=0;j<e.parent().children().length;j++){
                  if((e.parent().children()[j].getAttribute('choice')||'').indexOf('1')>=0){
                    var className = e.parent().children()[j].className;
                    e.parent().children()[j].className = className.replace('ans-option-select', 'ans-option');
                  }
                }
              } else { //未被选中
                element.className = element.className.replace('ans-option-select', 'ans-option');
              }
            }
            mask.style.display = 'none';
            document.body.style.overflow = 'auto';
            element.style.zIndex = 0;
          }
        }
    }

for循环操作dom消耗时间，querySelectorAll查询后循环也非常消耗时间

    console.time('arr');
    var arr = document.querySelectorAll('[mask4me]');
    for(var i=0;i<arr.length;i++){}
    console.timeEnd('arr');
1~2ms

    console.time('query');
    for(var i=0;i<document.querySelectorAll('[mask4me]').length;i++){
        var arr = document.querySelectorAll('[mask4me]')[i];
    }
    console.timeEnd('query');
80~90ms

使用ng-class和`class={{v}}`这种写法渲染有时候有问题