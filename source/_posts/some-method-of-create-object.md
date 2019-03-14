---
title: JS中创建对象的几种方式
date: 2016-10-24 17:10:02
tags:
  - 对象
categories: "基础知识"
---
在JavaScript中，一切介对象，不论是JS内置的Array、Number、Boolean、String、Function、Date、regExp、Object等，还是自定义的对象，都是基于对象的。具有对象的基本特征。但是你会发现，创建对象的方式多种多样，看起来好像都差不多，最后都是创建了一个对象，但是它们的使用场景和创建方式是有很大区别的。
这篇博文，就带大家熟悉一下常用的几种创建对象的方式，同时梳理一下他们的适用场景。
<!--more-->
#### 1：常用的简易方式

#### 1.1：对象字面量
```
var clock={
  hour:12,
  minute:10,
  second:10,
  showTime:function(){
   alert(this.hour+":"+this.minute+":"+this.second);
  }
}
clock.showTime();//调用
```
#### 1.2：使用new Object创建实例
```
 var clock = new Object();
clock.hour=12;
clock.minute=10;
clock.showHour=function(){alert(clock.hour);};
clock.showHour();//调用
```
虽然使用Object构造函数或者使用对象字面量可以很方便的用来创建一个对象，但这种方式有一个明显的缺点：使用一个接口创建多个对象会产生很多冗余的代码。因此为了解决这个问题，人们开始使用以下几种模式来创建对象。
#### 2：使用模式创建对象
但是在复杂的情况下，我们需要创建具有很多属性和方法的复杂对象，使用以上的方式会产生很多冗余的代码，于是便有了以下这些创建复杂对象的常见模式。
##### 2.1：工厂模式
创建一个函数并在函数内部使用对象，添加属性和方法，并返回对象
```
 function createClock(hour,minute,second){
  var clock = new Object();
   clock.hour=hour;
   clock.minute=minute;
   clock.second=second;
   clock.showHour=function(){
   alert(this.hour+":"+this.minute+":"+this.second);
  };
  return clock;
};
var newClock = createClock(12,12,12);//实例化
newClock.showHour();//调用
```
特点：无法识别对象类型，每次实例化都会创建新的实例；
这种方式创建的对象，每次实例化都会在栈区产生新的引用，即每次都会有不同的实例产生，效率较低，一般不推荐。
##### 2.2：构造函数模式
创建一盒函数，但是函数的属性和方法使用this指定，当直接使用时相当于执行函数，当使用new创建函数时，相当于调用此构造函数产生新的实例；
```
 function clock(hour,minute,second){
  this.hour = hour;
  this.minute = minute;
  this.second = second;
  this.showTime = function(){
   alert(this.hour+":"+this.minute+":"+this.second);
  }
}
 var newClock =new  clock(12,12,12);
alert(newClock.hour);
```
特点：无需在函数内部创建对象，也不需要return对象，但是也会存在重复实例化对象的问题；

##### 2.3：原型模式
创建空函数，并在原型上创建方法和属性。
```
  function clock(hour,minute,second){
}
clock.prototype.hour=12;
clock.prototype.minute=12;
clock.prototype.second=12;
clock.prototype.showTime=function(){
  alert(this.hour+":"+this.minute+":"+this.second);
}
var newClock = new clock();
newClock.showTime();
```
特点：所有的实例共享原型的属性和方法。
缺点：省略了构造函数无法为为实例传递参数，由于所有的实例共享相同的属性和方法，当属性为引用类型时，更改一处逇属性值，所有的地方都会改变。
##### 2.4:构造原型模式（混合模式）
使用构造函数定义参数传递的属性，使用原型模式设置共享的属性和方法。
```
 function CPerson(name,sex,age) {//注意这里 构造函数首字母大写
         this.name = name;
         this.sex = sex;
         this.age = age;
         this.job=['前端','后端'];
     }
 
    CPerson.prototype={
        constructor:CPerson,//注意这里
        show : function () {
            console.log(this.name, this.age, this.sex);
        }
    }
 
    var p1 = new CPerson('谦龙','男',100);
    var p2 = new CPerson('雏田','女',20);
        p1.job.push('测试');
        console.log(p1.job);//["前端", "后端", "测试"]
        console.log(p2.job);//["前端", "后端"]
        console.log(p1.job == p2.job);//fasle
        console.log(p1.show == p2.show);//true
```
优点：每个实例都有自己一份实例属性的副本，但同时又共享着对方法的引用，最大限度节省内存。
缺点：没有明显的缺点。
> 这种方式是目前用的最多的一种创建自定义对象的方式，在没有特殊要求的情况下，一般会使用。
>

##### 2.5：动态原型模式
动态原型模式将所有的信息都封装在了函数中，而通过构造函数中初始化原型，保持了同时使用构造函数和原型的优点
```
        function CPerson(name,sex,age) {//注意这里 构造函数首字母大写
            this.name = name;
            this.sex = sex;
            this.age = age;
            this.job=['前端','后端'];
            if(typeof this.show !='function'){ //注意这里
                console.log('just one');
                CPerson.prototype.show=function(){
                    console.log(this.name, this.age, this.sex);
                }
            }
        }
        var p1 = new CPerson('谦龙','男',100); //just one
        var p2 = new CPerson('雏田','女',20);//没有输出
```
特点：满足某些开发人员，无法看到独立的构造函数和原型时，感到不解。本质上和混合模式没有什么不同。
注意这里的判断语句，在第一次使用new操作符实例化该对象时，this.show方法时不存在的，所以判断会返回true,于是会输出just one,并且会在原型上创建该方法。
所以在第二次使用时，此方法已存在，所以会返回false,不会执行。
此方法只是在构造原型模式的基础上，加了一个判断语句，其实本质上并没有什么区别。只是为了满足某些开发人员，无法看到独立的构造函数和原型时，感到不解。
#### 2.6：寄生构造函数模式
该方式的基本思想是创建一个函数，用来封装创建对象的代码，然后再返回新创建的对象。构造函数在不返回值的情况下，默认会返回新对象的实例，而通过return语句可以修改调用构造函数时的返回值。
这个模式的构造函数写法其实和工厂模式是一摸一样的，只是在使用的时候使用了new操作符来实例化，而工厂模式不用使用。
那么，这种模式的用处在哪里呢？
这个模式可以在特殊的情况下为对象创建构造函数，比如我们想在Array上添加一些新的方法，但是希望同时能够保留Array的原始方法，就可以使用这种模式来创建对象。
```
 function MyOwnArray(){
        var arr=new Array();//创建新对象
            arr.push.apply(arr,arguments);//使用Array的push方法使用传入的参数初始化arr的值
            arr.show=function(){
                console.log(this.join('|'));
            }
        return arr;
    }
 
    var arr1 = new MyOwnArray('ovenzeze','male',100);
        arr1.show();//'ovenzhang|male|100'
```
我们再Array上添加了原来没有的show方法。
特点：当我们想创建一个具有额外方法的数组而又不能修改Array构造函数的情况下，可以使用这种模式.
##### 2.7：稳妥构造函数模式
稳妥对象即没有公共属性，方法也不引用this对象，稳妥对象最适合在一些安全的环境中（例如禁止使用this和new）或者防止数据被其他应用程序修改的时候使用。
```
  function CPerson(name,sex,age){
        var obj = new Object();
          
        var myOwnName='ovenzhang';     // private members
        obj.showOwnName=function(){    //只有通过该方法才能访问myOwnName 私有属性
            console.log(myOwnName);
        }
        obj.show=function(){
            console.log(name,sex,age);
        }
        return obj;
    }
 
    var p1=CPerson('谦龙','男','100');
        p1.show();
        p1.showOwnName();
```
特点：除了通过调用对应的方法来访问其数据成员，没有别的方法可以访问到原始添加的数据，其提供的这种安全机制适合在例如ADsafe等的环境下使用。
#### 3:总结
* 以上就是目前创建对象的几种方式，在一般只是需要创建具有属性的对象时，直接使用对象字面量的方式即可。
* 在需要创建复杂的、可复用的对象时，一般使用构造原型模式，即混合模式。
* 在需要拓展某个原生对象的功能但是希望能够复用，可以使用寄生构造模式。
* 在对安全性要求非常高的情况下，无法使用this和new时，一般使用稳妥构造模式。
* 当然如果你习惯了可以一眼看到构造函数和原型的方式，使用动态原型模式也未尝不可。