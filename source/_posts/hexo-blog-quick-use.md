---
title: 在Github搭建基于Hexo的博客（一）
date: "2016-9-6 10:55:35"
tags:
  - github
  - hexo
categories: "其他教程"
---
## 1: 写在前面
----
这是一篇使用[*Github*](www.github.com)搭建基于[Hexo](hexo.io)的个人博客教程。接下来几天，我会在博客连载如何从零开始使用Github Pages提供的免费空间和二级域名建设一个属于你的个人博客。
通过这个系列教程，你可以学会目前最流行的版本控制工具Git、代码托管网站Github、基本的MarkDown语法的使用。
当然，这只是一个最基础的博客，并没有使用独立域名，也不涉及到自己购买和配置云服务器。实际上，在搭建博客的前期我也不推荐这么做，Github提供的服务已经能够很好的为我们服务。
<!-- more -->
## 2：知识准备
----
虽然上只会用到这些工具中最基本的一些功能，但是建议你先简单了解一下。
* 版本控制工具：[Git](http://baike.baidu.com/link?url=_fzvt5dLfjM3wl2honQJ4AU0-5c9zCXjv0dhDw1zjDCL2LZ8-p6f7VfrqQt1nlJAGXGFmsNBC3p_c5fPjLndRYKnXg2g6CLmPj079gMF3Ou)
* 代码托管网站： [Github](http://www.github.com/)
* Github提供的网站服务： [Github Pages](https://pages.github.com/)
* 博客引擎：[Hexo](http://hexo.io/)
* 通用文本标记语言：[MarkDown](http://sspai.com/25137)

## 3：具体配置
---
### 3.1：注册Github账号并创建博客仓库
GitHub Pages目前有两种类型：**User Pages** 和 **Project Pages**。

**User Pages与 Project Pages的区别是：**
1: **User Pages**是用来展示用户自定义内容的,而**Project Pages**更多是用来展示项目的Demo或者介绍项目,可以理解为项目官网。
2: 用于存放**User Pages**的仓库必须使用**username.github.io**的命名规则，而**Project Pages**则没有特殊的要求。
3: **User Pages**将使用仓库的**master**分支，而**Project Pages**将使用**gh-pages**分支。
4: **User Pages**通过**username.github.io**进行访问,而**Projects Pages通过username.github.io/projectname**进行访问。
**很显然，User Pages更适合用于搭建个人博客，所以我们这里介绍的是User Pages搭建博客的教程。[当然如果你确实青睐于Project Pages，基本流程也没有什么大的区别]**
接下来就是在自己的**Github**账号下创建新的仓库，如上文所述，命名为**username.github.io（username是你的账号名)**。
至此，第一步就已经完成了,下面是我的master分支截图。**Github**只会把你的master分支作为网页提供给其他用户访问，所以你的网页文件只有在master分支下才可以生效。
{% img [class names] /img/hexo-master.png%}
----

### 3.2：安装并配置Git
----
#### 3.2.1：安装Git
**在Windows下安装Git**
因为Windows对Git的支持不好，纯净安装需要自己配置环境变量之类的东西。
*我们这里推荐使用msysGit*,是一个windows下集成的Git环境，安装完即可以使用，不需要任何配置。
下载地址为：[http://msysgit.github.io/](http://msysgit.github.io/)。
当然你也可以使用官方Github for windows的安装程序来安装：
该安装程序包含图形化和命令行版本的 Git。 它也能支持 Powershell，提供了稳定的凭证缓存和健全的 CRLF 设置。 稍后我们会对这方面有更多了解，现在只要一句话就够了，这些都是你所需要的。 你可以在 GitHub for Windows 网站下载，网址为 http://windows.github.com。
**在Linux下安装Git**
**Linux**对**Git**的支持非常友好，所以安装非常容易。
Debain和Ubuntu下安装
```bash
$ sudo apt-get install git-core //系统会自动帮你安装好所有依赖
$ git --version  //安装完成查看Git版本
  git version 1.8.1.2  //显示Git版本
```
**在Mac下安装Git**
在 Mac 平台上安装 Git 最容易的当属使用图形化的 Git 安装工具。下载地址为：[http://sourceforge.net/projects/git-osx-installer/](http://sourceforge.net/projects/git-osx-installer/)。
Git安装相关资料：
* [起步 - 安装 Git](https://git-scm.com/book/zh/v2/%E8%B5%B7%E6%AD%A5-%E5%AE%89%E8%A3%85-Git)
* [Git安装-菜鸟教程](http://www.runoob.com/git/git-install-setup.html)

#### 3.2.2：配置Git
当安装完Git应该做的第一件事情就是设置用户名称和邮件地址。这样做很重要，因为每一个Git的提交都会使用这些信息，并且它会写入你的每一次提交中，不可更改。但是这个用户名和邮箱和你在Github的账户是没有关系的，它只是作为一个标记标识提交者的信息，当然你要设置的和Github的账户邮箱一样，也不是不可以，但通常我们不推荐这么做。
设置用户昵称和邮箱：
```bash
$ git config --global user.name "username"
$ git config --global user.email "username@example.com"
```
#### 3.2.3：与Github仓库建立联系
现在你已经在你的机器上安装并配置了Git、同时也有了远程的Github仓库，接下来就是把它们联系起来，是你本地的内容可以推送到远程的仓库上去。
连接到Github的方式有很多种，这里我们推荐使用SSH的方式连接，SSH隧道连接是一种安全性高、速度快、跨平台的加密连接。
1 ：检查电脑是否已有SSH Keys：
```bash
$ ls -al ~/.ssh  //列出电脑上的SSH文件夹，如果存在的话
```
默认情况下，public keys的文件名是以下的格式之一：id_dsa.pub、id_ecdsa.pub、id_ed25519.pub、id_rsa.pub。因此，如果列出的文件有public和private钥匙对（例如id_ras.pub和id_rsa），证明已存在SSH keys。
如果存在SSH Keys的话，你可以删除C盘用户名文件夹下的.ssh隐藏文件夹。当然如果是已经连接到你的Github账户的电脑你可以直接跳过这一步。
2：生成新的SSH Keys
```bash
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com" 
//生成基于此用户名的SSH Keys
```
之后，回车确认即可。
3：添加SSH Keys内容到Github账户
这时候你在C盘的用户名文件夹下应该能看到隐藏文件夹.ssh，打开此文件夹下的id_rsa.pub[可使用Nodepad++或sublime打开]文件，复制全部内容。
然后，在GitHub右上方点击头像，选择”Settings”，在右边的”Personal settings”侧边栏选择”SSH Keys”。接着粘贴key，输入Keys的名字（可以随便输入，是为了让你有多个Keys时能够分辨），点击”Add key”按钮。
界面如下：
{% img /img/git-ssh.png%}
4: 接着测试是否能够成功连接到你的Github账户
```bash
$ ssh -T git@github.com
//通过SSH Keys连接到Github
```
如果你看到下面的提示内容：
```bash
The authenticity of host 'github.com (207.97.227.239)' can't be established.
RSA key fingerprint is 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48.
Are you sure you want to continue connecting (yes/no)?
```
键入yes并回车：
```bash
Hi username! You've successfully authenticated, but GitHub does not
provide shell access.
```
看到这段文字说明你已经成功通过SSH连接到Github。
### 3.3：安装并配置Hexo
----
#### 3.3.1：安装Node.js和Hexo
* 下载并安装Node.js
在官网下载Node.js安装包，windows系统可以安装MSI格式安装包，安装完成会自动配置环境变量。下载地址为：[http://nodejs.org/download/](http://nodejs.org/download/)。
* 检测Node.js是否安装成功
在windows下打开CMD:
```bash
$ node -v
v 0.10.11  //这里返回你安装的Node.js版本
```
* 由于新版Node已经集成了NPM，所有NPM也一并安装好了。同样的：
```bash
$ npm -v
v 0.10.11  //这里返回你安装的NPM版本
```
* 安装Hexo(前提是安装好Node.js和NPM)
```bash
$ npm install -g hexo-cli
```
#### 3.3.2: 配置Hexo并生成本地博客
* 接下来在你想要建立博客的文件夹内右键选择使用Git Bash打开，在此处建立初始仓库
```bash
$ hexo init //初始化本地Git仓库
$ npm install  // 安装Hexo所需的依赖包
```
* 接下来，我们就要生成并测试我们的博客
```bash
$ hexo generate
$ hexo server
```
* 现在，你就可以在浏览器地址栏输入localhost:4000来访问我们的第一个博客了。当然，现在我们的博客只是本地的，只有服务启动并且在本地才可以访问。下面我们就一步一步把它托管到我们的Github远程仓库上去吧。

#### 3.3.3: 使用自定义的主题
* 网上有很多精美的Hexo主题，大家可以在Hexo的Github主页找到主题网站的链接，[https://github.com/hexojs/hexo/wiki/Themes](https://github.com/hexojs/hexo/wiki/Themes)。找到了之后进入主题的Github主页，找到主题的Github地址。
进入Hexo的目录，（只要是Hexo的目录均可，会自动将主题文件放到Theme目录下）右键使用Git Bash：
* 接下来，还要修改站点配置文件，告诉hexo我们需要使用哪个主题，找到并打开Hexo根目录下的_config.yml文件，编辑theme字段：
```bash
# Extensions 这里配置站点所用主题和插件
## Plugins: https://github.com/tommy351/hexo/wiki/Plugins
## Themes: https://github.com/tommy351/hexo/wiki/Themes
theme:  你要使用的主题名称
```
* 接下来我们就可以重新生成页面并启动服务，查看修改效果，如果没问题的话就可以推送到Github上。

----
### 3.4: 发布网站到Github Pages
* 编辑Hexo文件夹下的_config.yml(可以使用NotePad++编辑)
找到文件内的Deployment字段，修改如下：
```bash
deploy:
  type: git
  repo: 对应仓库的SSH地址（可以在GitHub对应的仓库中复制）
  branch: 分支（User Pages为master，Project Pages为gh-pages）
```
* 安装部署插件
最新的版本没有集成部署插件，需要我们手动安装
```bash
$ npm install hexo-deployer-git --save
```
* 部署我们的静态博客到Github Pages
```bash
$ hexo generate //生成静态文件
$ hexo deploy   //部署博客到Github
```
完成之后，我们就可以用我们之前设置的**username.github.io**访问我们的博客了，可能要稍等几分钟才可以访问到。

### 3.5：写在后面
这期教程教会大家怎么搭建一个可用的**Github**博客，但是博客上存储的都是静态的网页，如果我换了工作环境，电脑怎么办呢？如何更新和优化博客上的内容呢？下期博文将会写一下怎么优化部署和管理自己的**Github**博客，为大家解决这些些问题。
