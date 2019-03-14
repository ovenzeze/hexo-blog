---
title: 浏览器的缓存管理
date: 2017-03-02 20:24:36
tags:
 - 浏览器缓存
categories: "基础知识"
---
昨天电话面试阿里云，面试官问到了有哪些控制缓存的方法，当时只答出来了一个通过设置过期时间（`Expires`），今天有空，正好整理一下。
# 浏览器端缓存分类
缓存主要分为`强缓存`和`协商缓存`。
`强缓存`：浏览器在加载资源时，先根据这个资源的一些`http header`判断它是否命中强缓存，强缓存如果命中，浏览器直接从自己的缓存中读取资源，不会发请求到服务器。
`协商缓存`：当强缓存没有命中的时候，浏览器一定会发送一个请求到服务器，通过服务器端依据资源的另外一些`http header`验证这个资源是否命中协商缓存，如果协商缓存命中，服务器会将这个请求返回（`304`），但是不会返回这个资源的数据，而是告诉客户端可以直接从缓存中加载这个资源，于是浏览器就又会从自己的缓存中去加载这个资源；若未命中请求，则将资源返回客户端，并更新本地缓存数据（`200`）。
强缓存不发送网络请求，协商缓存要发送网络请求。
<!--more-->

浏览器缓存使用流程图：

第一次请求：

![第一次请求](http://123.206.204.163:2333/media/first-request.png)
第二次请求：

![第二次请求](http://123.206.204.163:2333/media/second-request.png)
# 设置缓存的几种方式
1:Meta标签控制缓存（非HTTP协议定义）
```
<META HTTP-EQUIV="cache-control" CONTENT="no-cache">
```
上述代码的作用是告诉浏览器当前页面不被缓存，每次访问都需要去服务器拉取。这种方法使用上很简单，但只有部分浏览器可以支持，而且所有缓存代理服务器都不支持，因为代理不解析HTML内容本身。
2 HTTP头信息控制缓存
HTTP头信息控制缓存是通过`Expires`（强缓存）、`Cache-control`（强缓存）、`Last-Modified/If-Modified-Since`（协商缓存）、`Etag/If-None-Match`（协商缓存）实现。
# 强缓存
强缓存的设置方式主要是`Expires`和`Cache-control`。
`Expires`是`HTTP1.0`提出的一个表示资源过期时间的`header`，它描述的是一个绝对时间，由服务器返回，用`GMT`格式的字符串表示，
```
如：Expires:Thu, 31 Dec 2016 23:55:55 GMT
```
由于是绝对时间，那么存在跨时区、系统时间有误等各种情况可能出现误差。在`HTTP1.1`以后不再使用了。
`Cache-control`描述的是一个相对时间，在进行缓存命中的时候，都是利用客户端时间进行判断，所以相比较`Expires`，`Cache-Control`的缓存管理更有效，安全一些。
`Cache-Control`可以使用的值有`public`、`private`、`no-cache`、`no-store`、`no-transform`、`must-revalidate`、`proxy-revalidate`、`max-age`。

```
各个消息中的指令含义如下：
Public指示响应可被任何缓存区缓存。
Private指示对于单个用户的整个或部分响应消息，不能被共享缓存处理。这允许服务器仅仅描述当前用户的部分响应消息，此响应消息对于其他用户的请求无效。
no-cache指示请求或响应消息不能缓存，该选项并不是说可以设置'不缓存'，而是需要和服务器确认
no-store在请求消息中发送将使得请求和响应消息都不使用缓存，完全不存下來。
max-age指示客户机可以接收生存期不大于指定时间（以秒为单位）的响应。
上次缓存时间（客户端的）+max-age（64200s）<客户端当前时间
min-fresh指示客户机可以接收响应时间小于当前时间加上指定时间的响应。
max-stale指示客户机可以接收超出超时期间的响应消息。如果指定max-stale消息的值，那么客户机可以接收超出超时期指定值之内的响应消息。
```
> 注意：
1:这两个`header`可以只启用一个，也可以同时启用，当`response header`中，`Expires`和`Cache-Control`同时存在时，`Cache-Control`优先级高于`Expires`.

# 协商缓存
协商缓存主要由`Last-Modified/If-Modified-Since`和`Etag/If-None-Match`实现。
> `Last-Modified/If-Modified-Since`：`Last-Modified/If-Modified-Since`要配合`Cache-Control`使用。

`Last-Modified`：标示这个响应资源的最后修改时间。服务器在响应请求时，告诉浏览器资源的最后修改时间。(放在`响应头`里面)
`If-Modified-Since`：当资源过期时（强缓存失效），发现资源具有`Last-Modified`声明，则再次向服务器请求时带上头 `If-Modified-Since`，表示请求时间。服务器收到请求后发现有头`If-Modified-Since` 则与被请求资源的最后修改时间进行比对。若最后修改时间较新，说明资源又被改动过，则响应整片资源内容（写在响应消息包体内），`HTTP 200`；若最后修改时间较旧，说明资源无新修改，则响应`HTTP 304 `(无需包体，节省浏览)，告知浏览器继续使用所保存的`cache`。（资源过期时放在`请求头`里面）

`Etag/If-None-Match`：`Etag/If-None-Match`也要配合`Cache-Control`使用。
`Etag`：服务器响应请求时，告诉浏览器当前资源在服务器的唯一标识（生成规则由服务器决定）。
> `Apache`中，`ETag`的值，默认是对文件的索引节（INode），大小（Size）和最后修改时间（MTime）进行`Hash`后得到的。

`If-None-Match`：当资源过期时（使用`Cache-Control`标识的`max-age`），发现资源具有`Etag`声明，则再次向服务器请求时带上头`If-None-Match` （`Etag`的值）。服务器收到请求后发现有头`If-None-Match` 则与被请求资源的相应校验串进行比对，决定返回`200`或`304`。
`Etag`是服务器自动生成或者由开发者生成的对应资源在服务器端的唯一标识符，能够更加准确的控制缓存。
> `Last-Modified`与`ETag`一起使用时，服务器会优先验证`ETag`。

# 用户行为对缓存的影响
用户使用不同操作刷新网页，对浏览器使用的缓存策略也有影响。
|用户操作|Expires/Cache-control|Last_modified/Etag|
|----|----|------|
|地址栏输入网址|有效|有效|
|链接跳转|有效|有效|
|前进、后退|有效|有效|
|F5刷新|无效（设置max-age=0）|有效|
|Ctrl+F5刷新|无效（重置为no-cache）|无效（请求头丢弃）|
