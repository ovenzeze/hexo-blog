# Use	
* Add new post	
> Master为生成的静态文件目录,Hexo文件保存在hexo分支	
```	
生成新的文章文件：hexo new post title	
编辑新文章就可以	
编辑完成使用hexo g -d就可以生成新文件并部署到服务器上	
再使用git add *	
git commit -m "msg"	
git push origin hexo:hexo	
就可以将源文件上传到github	
已配置travis自动部署
检测到PUSH后会自动生成文件并部署到腾讯云
具体部署的文件夹和命令请参考travis.yml
```	
* Hexo use	
```	
Hexo config: _config.yml	
Theme config: themes/next/_config.yml	
```	
* Use hexo-admin	
```	
访问{{host}}/admin使用admin编辑文章	
```	
# Transform to new devices	
* Clone Hexo Files	
>master分支为博客静态文件分支hexo分支为源码分支	
```	
git clone git@github.com:ovenzeze/ovenzeze.github.io.git	
checkout hexo	
npm install	
git clone https://github.com/theme-next/hexo-theme-next themes/next	
```	
* Overwrite Theme Config	
```	
use next_config.yml overwrite themes/next/_config.yml	
```	
* Start Hexo	
```	
hexo s	
```