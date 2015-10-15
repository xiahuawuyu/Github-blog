title: underscore-source-3
tags:
---

这一部分专门对数组操作进行解析。

    456  _.initial = function(array, n, guard) {
        return slice.call(array, 0, Math.max(0, array.length - (n == null || guard ? 1 : n)));
      };
这个guard参数说是保证默认返回第一个值，不过我看了很久觉得意义不大，猜测可能是以前的接口。这里的`slice = Array.prototype.slice`。这里有两个地方比较好，一是用Array的原型函数来处理array参数，这样可以避免判断array是否数组，二是用max来避免超出数组长度。

    671 _.range = function(start, stop, step) {
        if (arguments.length <= 1) {
          stop = start || 0;
          start = 0;
        }
        step = step || 1;
        
        var length = Math.max(Math.ceil((stop - start) / step), 0);
        var range = Array(length);
        
        for (var idx = 0; idx < length; idx++, start += step) {
          range[idx] = start;
        }
        
        return range;
      };
这个函数本什没有什么特别的，只不过我在调用的时候将step赋值为小数，就出现了javascript著名的精度问题。网上应该有不少的解决方案，这里提供一种目前我在项目中用到的解决方法：将数字转为字符串在去小数点之后转为整数进行计算，计算完成后转字符串加上小数点再转成小数，举个例子

    1.11 ==> "1.11" ==> "111" ==> 111
    2.2 ==> "2.2" ==> "220" ==> 220
    111+220 ==> 331 ==> "331" ==> "3.31" ==> 3.31

