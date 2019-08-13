---
title: 浅谈浏览器中的PreFlight请求
date: 2019-8-13 13:37:13
tags:
  - this
categories: "基础知识"
---
> 阅读提示:本文阅读时间约5到10分钟。
### PreFlight请求是什么
我们都知道浏览器常用的请求有`POST` `GET` `PUT` `DELETE`等，不知道大家有没有关注过还有个请求类型叫`OPTIONS`。一般来说`preflight`预检请求，指的就是`OPTIONS`请求。它会在浏览器认为`即将要执行的请求可能会对服务器造成不可预知的影响时`，由浏览器自动发出。通过预检请求，浏览器能够知道当前的服务器是否允许执行即将要进行的请求，只有获得了允许，浏览器才会真正执行接下来的请求。
通常`preflight`请求不需要用户自己去管理和干预，它的发出的响应都是由浏览器和服务器自动管理的。  
<!--more--> 
* 它的请求通常长这个样子:
```
Access-Control-Request-Headers: x-requested-with
Access-Control-Request-Method: POST
Origin: http://test.preflight.qq.com
```
这里面主要关心`origin` `Access-Control-Request-Method` `Access-Control-Request-Headers`这三个字段，依次代表访问来源、真实请求的方法和真实请求的请求头。
* 响应通常长这个样子:
```
Access-Control-Allow-Headers: Content-Type, Content-Length, Authorization, Accept, X-Requested-With
Access-Control-Allow-Origin: http://test.preflight.qq.com
Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE
Access-Control-Max-Age: 86400
```
相对应的，响应里我们需要关心的是`Access-Control-Allow-Origin` `Access-Control-Allow-Headers` `Access-Control-Allow-Methods` 这三个字段，依次代表当前请求支持的访问域、支持的自定义请求头、支持的请求方法，如果即将执行的请求的任意一项不在支持范围内，浏览器就会自动放弃执行真实请求。同时抛出`CORS`错误。最后一项`Access-Control-Max-Age`代表该预检请求的有效期，在有效期内浏览器不会再为同一请求执行预检操作。
那具体什么情况下，会触发`preflight`请求呢？请看下一节。
### 什么时候会触发PreFlight请求
`preflight`预检请求属于`CORS`规范的一部分，目前所有的现代浏览器都实现了此规范，但是部分浏览器对规范内容有扩充。MDN上指出，一共有五项必须条件需要满足，否则浏览器在执行真实请求之前会发出预检请求，以免在获得允许之前对服务器产生不可预知的影响。
以下五项条件只要有`任意一项不满足`即会发送预检请求:
* 1: 请求方法限制
> 只能够使用`GET` `POST` `HEAD`
* 2: 请求头限制
> 只能包含以下九种请求头 `Accept` `Accept-Language` `Content-Language` `Content-Type ` `DPR` `Downlink` `Save-Data` `Viewport-Width`  `Width`
* 3: Content-Type限制
> Content-Type只能包含以下三种类型 `text/plain` `multipart/form-data` `application/x-www-form-urlencoded`
* 4: XMLHttpRequestUpload对象限制
> `XMLHttpRequestUpload`对象没有注册任何事件监听器
* 5: ReadableStream对象限制
> 请求中不能使用`ReadableStream`对象

对于常规的开发来说，主要的限制在前三条。最常见的场景是设置了自定义请求头和`Content-Type`类型不在支持的范围以内。
### 为什么会有PreFlight请求
我们现在大概明白了`preflight`请求是什么和什么场景触发`preflight`请求。
那么设计`preflight`请求的目的是什么呢？它能够从哪些路径帮我们规避问题呢？谈到这里，其实就谈到`CORS`跨域资源共享了。因为`preflight`预检请求就是为`CORS`服务的，是`CORS`规范中的一部分。通过限制跨域访问，可以极大的提高网页的安全性。同时对于不支持`CORS`的旧服务器，通过`preflight`请求确认对`CORS`的支持情况，来决定下一步的访问是否要继续，以免对服务器的数据产生不可预知的影响。   
如果没有`CORS`，我们可以认为在没有特别指定和配置的情况下，所有网站的资源都是共享的，`A`网站可以通过代码访问到`B`网站的`Cookie`等隐私信息，反过来同样的`B`网站可以通过代码访问到`A`网站。而有了`CORS`这些访问默认都是不允许的，需要经过特别的配置才能够支持跨域访问。这就让那些对安全性有要求的网站，有了比较通用的途径去提高网站的安全性，同时又保证了一定的便利性。
具体的`CORS`的安全机制是比较复杂，这里不再详述，感兴趣的同学可以参考[MDN的文档](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Access_control_CORS)。
### 如何正确的支持PreFlight请求
对于服务端开发来说，如果自己的请求可能会遇到有`preflight`请求的情况，我们需要怎么配置来支持`preflight`请求呢？
通常来说，我们需要关注的还是最关键的三个字段，`Access-Control-Allow-Origin` `Access-Control-Allow-Headers` `Access-Control-Allow-Methods`。
* Access-Control-Allow-Origin
这个一般用于对跨域请求的支持，对于绝大多数请求来说，访问来源是固定的，这个字段配置为支持的访问来源即可。对于通用的公共接口，比如`图片上传`这种，可以配置为`*`。不过这样做的安全性会大大降低，通常不建议使用。
* Access-Control-Allow-Headers
这个是用于对允许的自定义请求头的配置，通常对于一个固定的服务，支持的自定义请求头是固定的，我们在请求的时候配置在这里即可。
* Access-Control-Allow-Methods
这个是用于对允许的请求方法的配置，通常对于一个固定的服务，支持的请求方法也是固定的，我们在请求的时候配置在这里即可。这里也不建议配置为`*`,，会大大降低服务的安全性。通常老说，在当前设计的方法之外，加上`OPTIONS` `HEAD`即可。    

建议的配置(以koa2为例):
```
  ctx.set("Access-Control-Allow-Origin", 支持访问的网站域)
  ctx.set("Access-Control-Allow-Credentials", true);
  ctx.set("Access-Control-Max-Age", 86400000);
  ctx.set("Access-Control-Allow-Methods", "OPTIONS, HEAD, 当前请求的实际方法");
  ctx.set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Authorization, Accept, X-Requested-With");
```
同时，特别的如果你使用`router.post()`这种简写的方式去开发后端服务，还需要显式的配置对`OPTIONS`请求的返回码，来使浏览器正确的处理`OPTIONS`请求。
通常建议使用`200(OK)`或者`204(No Content)`返回码，当然实际上所有2开头的合法返回码，都会被浏览器认为`OPTIONS`认为请求执行成功。
```
if (ctx.request.method == "OPTIONS") {
    ctx.response.status = 204
  }
```
### PreFlight请求和CORS的关系
从MDN的介绍来看，`preflight`请求是`CORS规范`的一部分，只有在跨域的前提下，才会触发`preflight`请求的条件，如果请求没有跨域，即使请求不符合`preflight`请求的五项限制条件，也不会触发。
总结来说就是，跨域不一定会触发`preflight`预检请求，发生`preflight`预检请求一定跨域了。
这个也很好理解，作为保证跨域请求的安全性的机制之一，只有在跨域的情况下，才会有条件的触发`preflight`预检请求的校验机制。因为对于同域下的情况，后端开发者和前端开发者通常都是在有足够的共识的情况下进行开发，对于接口的安全性有比较充分的了解和配合，`preflight`请求就显得多此一举了。这也是一个典型的在安全性和便利性上面做出取舍，而选择折中方案的例子。
