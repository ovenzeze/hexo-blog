---
title: 闭包和递归
date: 2016-11-13 20:52:25
tags:
  - 闭包
  - 递归
categories: "基础知识"
---
# 1：闭包
闭包是能够访问另一个函数作用域中的变量的函数。
通常创建闭包的方式就是在一个函数内使用另一个函数，并将函数作为返回值。
闭包是一种特殊的对象。它由两部分构成：函数，以及创建该函数的环境。环境由闭包创建时在作用域中的任何局部变量组成。
简单来说就是内部函数在定义它的外部函数之外被调用（要形成这种调用必须使用`return`），形成了闭包。
闭包的产生过程可以这样理解：
JavaScript允许函数嵌套，并且内部函数可以访问定义在外部函数中的所有变量和函数，以及外部函数能访问的所有变量和函数。但是，外部函数却不能够访问定义在内部函数中的变量和函数。这给内部函数的变量提供了一定的安全性。而且，当内部函数生存周期大于外部函数时，由于内部函数可以访问外部函数的作用域，定义在外部函数的变量和函数的生存周期就会大于外部函数本身。当内部函数以某一种方式被任何一个外部函数作用域访问时，一个闭包就产生了。
<!--more-->
## 1.1:闭包中的作用域链
举个例子：
```
function creatComparisonFunction(propertyName){
    return function(object1,object2){
        var value1=object1[propertyName];
        var value2=object2[propertyName];
        if(value1<value2){
            return -1;
        }else if(value1>value2){
            return 1;
        }else{
            return 0;
        }
    };
}
```
在函数内部的匿名函数使用了外部函数传入的`prototypeName`参数，但是内部函数被返回了，
在这个函数中，在其他地方被调用了,但它仍然可以访问变量`propertyName`.之所以还能够访问这个变量,是因为内部函数的作用域链中包含`creatComparisonFunction()`的作用域。
上面这个例子还不能很好地解释闭包的作用，我们来再看一个`MDN`上的例子：
```
function makeFunc() {
  var name = "Mozilla";
  function displayName() {
    alert(name);
  }
  return displayName;
}
 
var myFunc = makeFunc();
myFunc();//Mozilla
```
一般情况下，函数中的局部变量仅在函数的执行期间可用。一旦` makeFunc()` 执行过后，我们会很合理的认为 `name `变量将不再可用。虽然代码运行的没问题，但实际并不是这样的。
原因是`myFunc`变成了一个闭包，前面说过闭包能够访问内部的变量。怎么运行的呢？
函数`makeFunc`内部定义了一个内部函数`displayName`，然后在`makeFunc`内部返回`displayName`函数。在`makeFunc`中，它的内部函数能够访问外部的属性这很好理解，用作用域链就能很好地解释。关键是在最后`makeFunc`返回了`displayName`函数，通过`return`，`displayName`的作用域链就不在是函数作用域了，它转移到了全局作用域中，而`makeFunc`的内部变量`name`因为被`displayName`引用，所以它也无法被释放，所以他们就一起存在与全局作用域中，所以直接运行也能够正确输出`Mozilla`。

## 1.2：闭包的使用（一）
在这个例子中，闭包实现了一种继承的作用，使用相同的方法，但是具有不同的运行环境。
我们来看个例子：
```
function makeAdder(x) {
  return function(y) {
    return x + y;
  };
}
 
var add5 = makeAdder(5);
var add10 = makeAdder(10);
 
console.log(add5(2));  // 7
console.log(add10(2)); // 12
```
外部函数`makeAdder`传入一个参数，返回一个函数；
内部匿名函数，传入一个参数，返回两个参数的和；
第一个声明，将5作为参数，传入`makeAdder`，同时将返回值赋值给add5,同时由于前面说的闭包的特性，`makeAdder`的参数`x`,`function`函数都已经保存到了全局作用域，所以直接调用，再次传入参数2，相当于运行`return`语句的匿名函数，所以这次运行的返回值为7.同理，add10也是同样的。
这样大家应该都能发现，这里有点类似继承，两个不同的实例都拥有自己的运行空间，代码可复用，但是同时又能拥有不同属性。
add5 和 add10 都是闭包。它们共享相同的函数定义，但是保存了不同的环境。在 add5 的环境中，`x `为 5。而在 add10 中，`x` 则为 10。

## 1.2：闭包的使用（二）
> ES6之前JavaScript没有块级作用域
>

诸如 Java 在内的一些语言支持将方法声明为私有的，即它们只能被同一个类中的其它方法所调用。对此，`JavaScript `并不提供原生的支持，但是可以使用闭包模拟私有方法。实现私有作用域的作用。
私有方法不仅仅有利于限制对代码的访问：还提供了管理全局命名空间的强大能力，避免非核心的方法弄乱了代码的公共接口部分。
代码如下：
```
var Counter = (function( ){
var privateCounter = 0;
function changeBy(val){
privateCounter += val;
}
return {
increment:function( ){
changeBy(1);
},
decrement:function( ){
changeBy(-1);
}
value:function( ){
return privateCounter;
}

}
})( );

console.log(Counter.value()); /* logs 0 */
Counter.increment();
Counter.increment();
console.log(Counter.value()); /* logs 2 */
Counter.decrement();
console.log(Counter.value()); /* logs 1 */
```
> 上面的用法是声明一个匿名函数并将它保存在一个变量中，同时立即执行这个匿名函数.将函数声明包含在一对圆括号中，表示它实际上是一个函数表达式，而紧随其后的另一对圆括号表示立即执行这个函数表达式。
>

而下面这种方式则会报错：
```
function ( ){ 
//块级作用域
}（）；

```
因为`JavaScript`将`function`关键词当做一个函数声明的开始，而函数声明后面不能跟圆括号。而，函数表达式后面可以跟圆括号。
前面几个例子，每一个闭包都有自己的环境，但是这里在一个环境里我们定义了三个函数，为三个函数所共享：`Counter.increment`，`Counter.decrement `和 `Counter.value`。
该共享环境创建于一个匿名函数体内，该函数一经定义立刻执行。环境中包含两个私有项：名为 `privateCounter` 的变量和名为 `changeBy` 的函数。 这两项都无法在匿名函数外部直接访问。必须通过匿名包装器返回的三个公共函数访问。
这三个公共函数是共享同一个环境的闭包。多亏 `JavaScript` 的词法范围的作用域，它们都可以访问 `privateCounter `变量和`changeBy` 函数。（词法作用域，可以在内层函数访问外层函数的变量和函数）
例子如下：
```
var makeCounter = function() {
  var privateCounter = 0;
  function changeBy(val) {
//根据传入-1或1来实现自增或自减
    privateCounter += val;
  }
  return {
    increment: function() {
      changeBy(1);
    },
    decrement: function() {
      changeBy(-1);
    },
    value: function() {
      return privateCounter;
    }
  } 
};
 //此时Counter1和Counter2成为了两个闭包，拥有相同的方法，但是有各自的运行环境。
var Counter1 = makeCounter();
var Counter2 = makeCounter();
console.log(Counter1.value()); /* logs 0 */
Counter1.increment();
Counter1.increment();
console.log(Counter1.value()); /* logs 2 */
Counter1.decrement();
console.log(Counter1.value()); /* logs 1 */
//Counter1和Counter2中的privateCounter互不影响
console.log(Counter2.value()); /* logs 0 */
```
通常来讲，在我们需要使用一些临时变量时，我们可以任何地方使用这种方式创建私有作用域。可以达到使用自定义的变量名也不会污染全局变量。而且，这种方式因为没有指向闭包的引用，只要函数执行完毕，就可以立即销毁其作用域链，不会产生内存占用问题。
如这个例子：
```
（function （）{
var now = new Date( );
if( now.getMonth( ) == 0 && now.getDate( ) == 1){
alert( "Happy new year!");
}
}）( );
```
## 1.3：使用闭包的常见错误
在循环中创建闭包
```
function createFunctions(){
    var result = new Array();
    for(var i=0;i<5;i++){
//通过调用可以知道，在createFunction()被调用时执行了5次
        console.log(i);
//result[i]的值是一个匿名函数对象，通过re[0]()调用，这里出现了闭包 
        result[i] = function(){
                return i;
        };
    }
        return result;
}
 
var re= createFunctions();
console.log(re);//返回包含5个匿名函数的数组
console.log(re[0]());//返回的是5,按照我们的思路应该是0
```
这里就是因为我们使用了闭包，`result`数组中一共保存了5个函数对象，但是他们共享同一个运行环境，所以最后他们中的`i`值都一样，都是5.
# 2：递归
递归函数就是会直接或者间接地调用自身的一种函数。递归是一种强大的编程技术，它把一问题分解为一组相似的子问题，每一个都用一个寻常解去解决。一般来说，一个递归函数调用自身去解决它的子问题。
通常来讲，递归的作用和循环类似，很多时候他们可以互换，但是具体的适用场景又有不同。递归更多是一种自顶层到底层的循环，而循环在未特意设定参数时通常都是一个自底层到顶层的过程。
递归的实现方法：
1： 通过函数名调用自身；
2： 使用`arguments.callee`，`arguments.callee`指向当前正在运行的函数；
3： 使用作用域下的一个变量名来指向函数，再进行调用；
举个例子：
```
var foo = function bar( ){
       // to do ...
}
```
在这里，`bar( )`,`arguments.callee( )`,`foo( )`是等价的，都指向正在运行的这个函数。
一般情况下，递归和循环可以相互转换，但是通常人们都不会这么做。因为适用语递归的函数用循环实现会变得异常复杂。
举个例子：
```
// 递归算法最常用就是获取树结构中的所有节点
function walkTree(node) {
  if (node == null) //
    return;
  // do something with node
  for (var i = 0; i < node.childNodes.length; i++) {
    walkTree(node.childNodes[i]);
  }
}
```
这里，每运行一次递归，树结构就深入一层，如果使用循环的话，就需要多次嵌套，效率较递归更低。 
# 3：总结一下
其实闭包和递归之间没有什么直接的联系，但是最近一起学了这两个知识点，就把他们写到一起了。
什么时候使用闭包？
* 需要借助闭包创建私有作用域；
* 需要在外部访问函数内部的变量；
* 需要保护某些变量和方法，要求只能被特定的方法访问和修改；

什么时候使用递归呢？
* 需要解决的问题是类似循环的方式；
* 需要解决的问题具有明显的层级关系；

通常来讲，能够使用循环很方便的解决的问题，不推荐使用递归，只有问题用循环解决很繁琐和复杂时，才使用递归解决。
最近比较忙，更新博客比较慢了。