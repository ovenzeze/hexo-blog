# use 
* Add new post
```
生成新的文章文件：hexo new post title
编辑新文章就可以
编辑完成使用hexo g -d就可以生成新文件并部署到服务器上
再使用git add *
git commit -m "msg"
git push origin master:hexo
就可以将源文件上传到github
```
* Use hexo-admin
```
访问{{host}}/admin使用admin编辑文章
```
* Transform to new devices
```
# master分支为博客静态文件分支 hexo分支为源码分支
全局安装git、npm、hexo使用hexo init初始化博客
git clone原来的博客文件
复制原来的
package.json
_config.yml(Hexo Config)
themes/next/_config.yml(Theme Config)
scaffolds(Post Models)
source(Articles)
文件夹覆盖新的博客目录
使用hexo g -d 生成并部署新的博客
会自动同时部署到Github和Coding的Pages服务上
```