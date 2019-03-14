---
title: JS实现继承的几种方式及其优缺点分析
date: 2016-10-26 21:10:32
tags:
  - 继承
categories: "基础知识"
---
`JavaScript`是面向对象的语言，面向对象语言大多支持的接口继承和实现继承。接口继承继承方法签名，不继承实际操作内容，实现继承继承实际的方法。`JavaScript`中函数没有签名，所以无法实现接口继承，而且基于原型和构造函数实现的实现继承也和传统的面向对象语言有不少区别。所以产生了多种多样实现继承的方式。
`JavaScript`实现继承主要有两种方式，构造函数继承也叫类式继承和非构造函数继承也叫对象继承。但是由于`JavaScript`语言本身的灵活性，同时衍生出很多组合使用多种凡事的继承方法。
下面就是`JavaScript`实现继承的几种常用方式。
<!--more-->
## 1：借用构造函数实现继承
这种方式的原理很简单，就是在子类型的内部调用父类型（超类型）的构造函数。主要通过`call apply bind `来实现。
```
function SuperType(){
    this.colors=["red","blue","green"];
}
 
function SubType(){
//通过call实现继承SuperType
    SuperType.call(this);
}
```
优点：
* 通过使用`call`可以在调用的时候向父类型传递参数。
缺点：
* 仅仅借用构造函数，方法都在构造函数中定义，就无法实现函数复用；
* 通过借用构造函数，在父类型原型中定义的方法也无法通过原型链暴露给子类型；

## 2：原型链实现继承
大家肯定都知道通过原型链可以很方便的让一个子类型继承父类型的属性和方法。每个构造函数都有一个原型对象，而这个原型对象又有一个指回构造函数的指针，而每个构造函数构造出来的实例，都有一个内部指针指向构造函数的原型对象。如果我们让一个构造函数的原型对象等于另一个构造函数的实例，那么是不是这个构造函数的实例就能够指向另一个构造函数的原型对象，以此类推，原型链不就形成了，同理，这不就叫继承吗？
代码如下：
```
    function Parent(){ // Parent构造函数
        this.name = 'mike';
    }
    function Child(){
        this.age = 12;
    }
    Child.prototype = new Parent();//Child继承Parent，通过原型，形成链条 
    var test = new Child();
    alert(test.age);
    alert(test.name);//得到被继承的属性
    //继续原型链继承
    function Brother(){   // brother构造函数
        this.weight = 60;
    }
    Brother.prototype = new Child();// 继续原型链继承
    var brother = new Brother();
    alert(brother.name);// 继承了Parent和Child,弹出mike
    alert(brother.age);// 弹出12
```
在这里，`brother`指向他的构造函数的原型，`Brother.prototype`，而`Brother`的原型是由`Child`的实例生成的，所以`Brother`的原型拥有和`Child`的实例一样的指向，而`Child`的实例指向`Child`构造函数的原型，这里，再次`Child`构造函数的原型式`Parent`实例生成的，拥有和`Parent`实例一样的指向。到这里，我们定义的原型链就完成了，当然还有`Function、Object`之间的部分，这里我们就不讨论了。
优点：
* 非常简便的实现了多重继承的关系；
* 能够确定原型和实例之间的关系；
缺点：
* 创建子类型实例时，无法向父类型传递参数，尤其是多重继承时，弊端非常明显；
* 所有的实例会共享通过原型链继承的属性，在一个实例中改变了，会在另一个实例中反映出来；
* 不能使用字面量添加新方法，会使继承关系中断（会重写`constructor`属性）；
以上是两种较为单一的继承实现，但是实际使用中都是使用了多种方式的组合继承，主要由以下几种。
## 3：组合继承
组合继承就是将前面两种方法组合到一起，原理是通过原型链实现对原型属性和方法的继承，而通过构造函数实现对实例属性的继承。这样，既保证原型上定义的属性和方法可以共享，又保证每个实例都有自己的属性。
举个例子：
```javascript
function superType ( ){
this.name = name;
this.colors = ["red","blue","green"];
}
superType.prototype.sayName = function ( ){
console.log(this.name);
}
function subType (name,age){
//通过call继承superType
superType.call(this,name);
this.age = age;
}
subType.prototype = new SuperType( );
//将constructor重新指回subType
subType.protype.constructor = subType;
subType.prototype.sayAge = function( ){
console.log(this.age);
}
var instance1 = new subType("ovenzhang","21");
var instance2 = new subType("ovenzeze","22");
instance1.colors.push = "black";
console.log(instance1.colors);
// "red,blue,green,black"
console.log(instance1.sayAge);
//21
console.log(instance1.sayName);
//ovenzhang
console.log(instance2.colors);
// "red,blue,green,black"
console.log(instance2.sayAge);
//22
console.log(instance2.sayName);
//ovenzeze
```
在这个例子中，`superType`定义的属性和`superType`原型上定义的方法是所有实例共享的，`subType`中定义的属性是每一个实例都会有的拷贝，`subType`原型中定义的方法也是实例共享的，这样`subType`的两个实例，既可以拥有自己的属性，又可以拥有共享的属性和方法。
组合继承避免了原型继承和借用构造函数继承的缺点，融合了他们的优点，是目前最常用的继承方式。
## 4：原型式继承
通过借助原型基于已有的对象创建新对象，同时在创建的过程中加以修改，达到了继承原有属性和方法并可以添加新属性和方法的目的。
举个例子：
```
     function obj(o){
         function F(){}
         F.prototype = o;
         return new F();
     }
    var box = {
        name : 'trigkit4',
        arr : ['brother','sister','baba']
    };
    var b1 = obj(box);
    alert(b1.name);
    //trigkit4
    b1.name = 'mike';
    alert(b1.name);
    //mike
    alert(b1.arr); 
   //brother,sister,baba
    b1.arr.push('parents');
    alert(b1.arr);
   //brother,sister,baba,parents  
    var b2 = obj(box);
    alert(b2.name);
   //trigkit4
    alert(b2.arr);
   //brother,sister,baba,parents
```
可以看到，原型式继承最关键的就是已有的对象，通过使用`object`函数，把已有的对象重新引用了一次，相当于进行了一次浅复制，在新的通过已有对象生成的新对象上，具有原来的属性和方法，同时又可以增加新的属性和方法确不会影响到原来的对象。
缺点：
通过将原有对象的复制给新对象的原型实现了继承，但是如果原有对象包含有引用类型值，则会被所有实例共享；
通过这种方式使用原有对象的方法也无法传递参数。

## 5：寄生式继承
前面的原型式继承具有单一方式的几个缺点，所以出现了和寄生构造函数和工厂模式思想类似的寄生式继承。原理是，创建一个仅用于封装继承过程的函数，该函数在内部一某种方式来增强对象，再返回对象。
举个栗子：
```
function rreateAnother( ){
//和原型式继承中用到的object功能一样
var clone = object(original);
//增强对象
clone.sayHi = function( ){
alert("hi!");
};
//返回对象
return clone;
}
```
这种方式实现的继承，不仅能够使用共享的属性和方法，还可以有自己的私有属性和方法。
缺点：
在多层继承时无法实现链式继承，后续添加的函数和方法无法复用；
## 6：寄生组合式继承
前面的组合式时继承其实已经是能够满足绝大多数场景的方案，但是在要求性能极度优化的环境下，组合式继承通过两次调用父类型构造函数就显得效率比较低下了。
而寄生组合式继承，就是借用构造函数来继承属性，通过原型链的混成方式来继承方法。这种方式就无需为了使用父类型的属性，而使用call调用父类型的构造函数。
基本实现代码如下：
```
//obj函数，实现寄生式继承的基础
    function obj(o){
        function F(){}
        F.prototype = o;
        return new F();
    }
   //create函数 实现组合寄生继承的核心
    function create(subType,superType){ 
       //创建对象，保存parent的原型到f上
        var f = obj(superType.prototype); 
       //增强对象，将f指回test函数
        f.constructor = subType;   
      //指定对象，将增强过的f赋给parent原型
        subType.prototype = f; 
    }
 //例子
    function Parent(name){
        this.name = name;
        this.arr = ['brother','sister','parents'];
    }
 
    Parent.prototype.run = function () {
        return this.name;
    };
 
    function Child(name,age){
        Parent.call(this,name);
        this.age =age;
    }
    //通过这里实现继承  
    create(Child,Parent);
    var test = new Child('ovenzhang',21);
    test.arr.push('nephew');
    alert(test.arr);  
    // "brother,sister,parents,nephew"
    alert(test.run); 
    //ovenzhang
```
这种方式通过`create`函数将父类的原型赋给子类的原型并不改变子类原型的`constructor`指向，相当于实现了继承父类原型上的方法和属性，但是不必再次调用父类的构造函数，提高了组合继承的效率。是目前认为引用类型实现继承的理想方式。

## 7：总结
一般情况下，使用组合继承就可以了，这也是目前使用最广泛，认同度最高的实现继承的方式。而当对性能要求非常高时，也可以使用组合寄生式继承，是结合了组合继承和寄生式继承的优点的方式，但是方法相对复杂一些。