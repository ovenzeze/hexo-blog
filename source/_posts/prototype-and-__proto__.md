---
title: 显式原型和隐式原型的关系
date: 2016-10-23 17:42:08
tags:
 - 原型
categories: "基础知识"
---
最近在看JS中继承和对象的知识。发现不论是继承还是对象，都不停的出现`prototype`和`__proto__`,即原型相关的知识。所以做了一些总结和整理。
在JS中没有类和继承的说法，但是有原型和原型链，能够实现同样的功能，只是叫法不一样，有很多人习惯了Java等语言的习惯，还是把这些叫做类和继承，其实是非常不合适的一种叫法，其实如果用JS的思想来理解的话，其实原型和原型链更好理解一些。
这里就是对原型的一些理解和知识整理。有了原型的知识，原型链就很好理解了。
<!--more-->
# 1：[[proto]]和prototype
准备知识：
1.在JS里，万物皆对象。方法`Function`是对象，方法的原型`Function.prototype`是对象。因此，它们都会具有对象共有的特点。
即：对象具有属性`__proto__`，可称为`隐式原型`，一个对象的`隐式原型`指向`构造该对象的构造函数的原型`，这也保证了实例能够访问在构造函数原型中定义的属性和方法。
> 访问构造函数原型的方法，`__proto__`,前后是两个英文状态下下划线，不要写错了。
>

## 1.1：显式原型
每一个函数在创建之后都会拥有一个名为`prototype`的属性，这个属性指向函数的原型对象。
> 通过Function.prototype.bind方法构造出来的函数是个例外，它没有prototype属性。
>

## 1.2：隐式原型
`JavaScript`中任意对象都有一个内置属性`[[prototype]]`，在ES5之前没有标准的方法访问这个内置属性，但是大多数浏览器都支持通过`__proto__`来访问。ES5中有了对于这个内置属性标准的Get方法`Object.getPrototypeOf().`
> `Object.prototype` 这个对象是个例外，它的`__proto__`值为null
>

二者的关系：
* 隐式原型指向创建这个对象的（构造函数）函数(`constructor`)的显式原型；
* 构造函数的`__proto__`指向构造构造函数的原型对象，对于函数来说就是`function.prototype`;
* 构造函数的原型对象也有`__proto__`,同理它指向构造原型对象的构造函数(即`function`)的原型对象，即`object.prototype`;

## 1.3：构造函数的隐式原型
既然是构造函数，是一个函数，所以它是`Function`的一个实例，所以他的隐式原型指向其构造函数`Function`的显式原型（`prototype`属性）。
```
Array._proto_ === Function.prototype
//true
//需要注意的是：
Object.__proto__ === Function.prototype
//true
Function.__proto__ === Function.prototype
//true
```
在这里，`Object`对象也是一个构造函数，所以它的隐式原型指向`Function`的显式原型。而`Function`也是一个构造函数（用来构造`Function`对象的构造函数），记住前面说过的，一个对象的隐式原型指向它的构造函数的显式原型，所以它的隐式原型指向构造`Function`的构造函数（这里还是`Function`）的显式原型。这里不是很好理解，如果不理解的话，大家可以把前面的内容好好看几遍。

## 1.4：构造函数的显式原型的隐式原型
前面说过，只要是对象都有隐式原型，那么作为构造函数的显式原型也是对象，它隐式原型是什么呢?

内建对象：
最常用的构造函数就是内建对象，如常用的`Array、String、Function、Number、Boolean、Object、regExp、Date`等，内建对象的显式原型的隐式原型指向的构造函数的显式原型即`Object.prototype`，因为所有的对象都是基于`Object`创建的。
```
Array.prototype.__proto__ === Object.prototype
//true
Date.prototype.__proto__ === Object.prototype
//true
```
自定义对象：
默认情况下:
```
function Foo(){}
var foo = new Foo()
Foo.prototype.__proto__ === Object.prototype //true 理由同上
```
其他情况：继承
```
Function Foo( ){ };
var bar.prototype = new Foo( );
bar.prototype.__proto__ === Foo.prototype;//true
```
其他情况：重写prototype
```
//我们不想让Foo继承谁，但是我们要自己重新定义Foo.prototype
Foo.prototype = {
  a:10,
  b:-10
}
//这种方式就是用了对象字面量的方式来创建一个对象，根据前文所述
Foo.prototype.__proto__ === Object.prototype//true
```
后两种方式都手动的改变的`Foo`的`prototype`属性，所以`Foo.prototype`的`constructor`属性也随之改变，于是不再指回原来的构造函数`Foo()`.
那么怎么判断一个方法是函数本身就有的，还是原型上的呢？
# 2：几个例子
我们有一个`hasOwnProperty()`方法可以检测一个属性是存在于实例中还是存在于原型中。这个方法是从`Object`上继承而来的。在给定的属性存在于对象实例中时，该方法会返回true。
举个栗子：
```
function person（）{
Person.prototype.name= “ovenzeze”;
}
var person1 = new Person();
console.log(person1.hasOwnProperty("name"));
//false
person1.name = "ovenzhang";
console.log(person1.hasOwnProperty("name"));
//true                                                                                                                                                                                                                       
```
通过使用`hasOwnProperty()`方法，就可以很方便的判断一个属性是属于原型还是属于实例。
同时，有了上面对原型和原型链知识的理解，就很好理解下面的例子了。大家也可以自己先试着理解一下，看看自己有没有真的理解部分内容。
```
Function instanceof Object // true
Object instanceof Function // true
Function instanceof Function //true
Object instanceof Object // true
Number instanceof Number //false
```
这里，`instanceof`操作符判断的是左边的对象是否是右边构造函数的实例。
有了上面原型的知识这里应该不难理解：
`Function`首先是个对象，所以它是对象的构造函数（`Object`）的一个实例，所以为`true`；
`Object`这个对象，是`Object`类型的构造函数，它是一个函数，所以他是函数的构造函数（`Function`）的实例，所以为`true`;
`Function`是`Function`类型的构造函数，它是一个函数，既然是函数，它肯定是函数的构造函数（`Function`）的实例，所以为`true`；
同理，下面的两个就很好理解了。
在这里，`instanceof`大的原理可以这样理解。
```
//设 L instanceof R
//通过判断
L.__proto__.__proto__ ..... === R.prototype ？
//最终返回true or false
```
如果你能理解，这几个例子，那么你对`[[proto]]`和`prototype`就理解的差不多，理解这个原型链就更好理解了。就是通过`[[proto]]`实现的一层一层的继承关系。
 