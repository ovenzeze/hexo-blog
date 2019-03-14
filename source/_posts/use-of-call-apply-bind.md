---
title: call,apply,bind用法和意义
date: 2016-10-26 21:31:13
tags:
  - this
categories: "基础知识"
---
最近看继承相关的知识时，有几种方法都用到了`call`,于是了解了一下。顺带发现了`apply`和`bind`。但是网上的教程大多写的不是非常清楚。所以自己总结了一下。
`JavaScript`是动态编程语言，存在创建时上下文、运行时上下文，并且这些上下文都是可以动态改变的。而`call`、`apply`和`bind`的作用就是动态的改变上下文。
call,apply的作用是完全一样的，只是用法不一样。都是改变this的指向,而bind基本作用也一样，但是和他们有一点不同，待会我们把它分开来解释。
<!--more-->
# 1：call、apply的用法和意义

`call, apply`都属于`Function.prototype`的一个方法,它是`JavaScript`引擎内在实现的,因为属于`Function.prototype`,所以每个`Function`对象实例,也就是每个方法都有`call, apply`属性.
基本用法：
```
obj.call(thisObj, arg1, arg2, ...);
obj.apply(thisObj, [arg1, arg2, ...]);
```
将`obj`的属性和方法绑定到`thisObj`上，即将`obj`的运行时上下文指向`thisObj`,或者说此时`thisObj`继承了`obj`的属性和方法。

一个常用的场景，我们使用使用`getElementsByTagName`或者`getElementsByClassName`得到的是一个类数组，具有数组的`length`使用下标访问等特性，但是没有数组的增删改查、排序等方法。我们就可以使用`call`或`apply`使其使用这些方法：
```
let eleNodes = document.getElementsByTagName("a");
Array.prototype.slice.call(eleNodes);
//通过调用数组原型上的slice方法将类数组转换成数组，就具有了数组的所有方法
```
常用的一些用法：
1：合并几个数组
```
var array1 = [12 , "foo" , {name "Joe"} , -2458];
var array2 = ["Doe" , 555 , 100];
Array.prototype.push.apply(array1, array2);
/* array1 值为  [12 , "foo" , {name "Joe"} , -2458 , "Doe" , 555 , 100] */
```
2：找出数组中的最大最小值
```
var  numbers = [5, 458 , 120 , -215 ];
var maxInNumbers = Math.max.apply(Math, numbers),   //458
    maxInNumbers = Math.max.call(Math,5, 458 , 120 , -215); //458
```
3：验证是否是数组(要求没有重写toString方法)
```
functionisArray(obj){
    return Object.prototype.toString.call(obj) === '[object Array]' ;
}
```
区别：
唯一区别是`apply`接受的是数组参数，`call`接受的是连续参数。所以当传入的参数数目不确定时，多使用`apply`。
例子：定义log代理console.log方法
```
function log(msg)　{
  console.log(msg);
}
log(1);    
//1
log(1,2);   
//1
```
但是有个缺点，只能输出一个参数，如果有多个参数怎么办呢？
使用`call`或`apply`就可以很好地解决：
```
function log(){
  console.log.apply(console, arguments);
};
log(1);    //1
log(1,2);    //1 2
```
如果，继续希望每个输出之前带有特定前缀或后缀怎么办呢？
```
function log(){
  var args = Array.prototype.slice.call(arguments);
  args.unshift('(app)');
 
  console.log.apply(console, args);
}
```
通过使用`Array`原型上的`slice`方法将类数组`arguments`转换成数组，再使用数组的`unshift`方法就可以达到。
# 2：bind的用法和意义
`bind`和`call,apply`的作用很类似，都是改变`this`的指向，但是又不完全相同。
我们看一下MDN的解释：
> 
bind()方法会创建一个新函数，当这个新函数被调用时，它的this值是传递给bind()的第一个参数, 它的参数是bind()的其他参数和其原本的参数.
>

语法：
```
fun.bind(thisArg[, arg1[, arg2[, ...]]])
```
在一般的情况下，我们通常会使用一个变量来保存当前环境的`this`指向避免函数调用对象发生改变时，无法使用我们想要使用的`this`上下文环境。
比如这种情况：创建绑定情况
```
this.x = 9;
var module = {
  x: 81,
  getX: function() { return this.x; }
};
 
module.getX(); 
// 返回 81
 
var retrieveX = module.getX;
retrieveX(); 
// 返回 9, 在这种情况下，"this"指向全局作用域
 
// 创建一个新函数，将"this"绑定到module对象
// 新手可能会被全局的x变量和module里的属性x所迷惑
var boundGetX = retrieveX.bind(module);
boundGetX(); // 返回 81
```
当使用`bind`时，就可以更优雅的使用这种情况：
```
var foo = {
    bar : 1,
    eventBind: function(){
        $('.someClass').on('click',function(event) {
            console.log(this.bar);      
         //1
        }.bind(this));
    }
}
```
`bind()` 创建了一个函数，当这个click事件绑定在被调用的时候，它的 this 关键词会被设置成被传入的值（这里指调用`bind()`时传入的参数）。因此，这里我们传入想要的上下文` this`(其实就是` foo `)，到` bind() `函数中。然后，当回调函数被执行的时候，` this `便指向` foo `对象。
下面一个例子是配合`setTimeout`使用：
```
function LateBloomer() {
  this.petalCount = Math.ceil(Math.random() * 12) + 1;
}
 
// Declare bloom after a delay of 1 second
LateBloomer.prototype.bloom = function() {
  window.setTimeout(this.declare.bind(this), 1000);
};
 
LateBloomer.prototype.declare = function() {
  console.log('I am a beautiful flower with ' +
    this.petalCount + ' petals!');
};
 
var flower = new LateBloomer();
flower.bloom();  // 一秒钟后, 调用'declare'方法
```
在默认情况下，使用` window.setTimeout() `时，`this `关键字会指向 `window `（或全局）对象。当使用类的方法时，需要 `this `引用类的实例，你可能需要显式地把 this 绑定到回调函数以便继续使用实例.
快捷调用的例子：
在你想要为一个需要特定的 `this` 值的函数创建一个捷径的时候，比如你想要随时可以在`arguments`上使用`Array`的`slice`方法。
```
var unboundSlice = Array.prototype.slice;
var slice = Function.prototype.call.bind(unboundSlice);

slice(arguments);
```
# 3：call apply bind三者的区别
来看这个例子：
```
var obj = {
    x: 81,
};
 
var foo = {
    getX: function() {
        return this.x;
    }
}
 
console.log(foo.getX.bind(obj)());  
//81
console.log(foo.getX.call(obj));    
//81
console.log(foo.getX.apply(obj));   
//81
```
三个输出的都是81，但是注意看使用 `bind() `方法的，他后面多了对括号。
 也就是说，区别是，当你希望改变上下文环境之后并非立即执行，而是回调执行的时候，使用 `bind()` 方法。而 `apply/call` 则会立即执行函数。也就是说bind绑定的是函数的引用，而`call`和`apply`是绑定并立即执行，并且执行完就会销毁。
# 4：总结
总结一下就是：
* `apply 、 call 、bind `三者都是用来改变函数的this对象的指向的；
*` apply 、 call 、bind` 三者第一个参数都是this要指向的对象，也就是想指定的上下文；
* `apply 、 call 、bind` 三者都可以利用后续参数传参；
* `bind` 是返回对应函数的引用，便于稍后调用；
* `apply 、call` 则是立即调用 。