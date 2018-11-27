# PXHttpHelper

一个基于AFNetWorking3.2封装的轻轻框架

你可以使用 pod 'PXHttpHelper' 来安装
也可以下载之后将PXNetHelperDemo的AFNetworking与PXNetHeler两个文件夹拖到自己的项目中使用

#import "PXHttpHelper.h"
即可轻松使用

使用样式说明可以在ViewController.m中查看

2018-6-9 升级 1.0.1
 更新内容为：
 > 1、直接将返回值设置为AFJSONResponseSerializer
   2、将请求值也使用了AFJSONRequestSerializer
   3、新增了可以为请求设置请求头
   4、修改了部分打印顺序，你可以在自己的请求体重不需要打印也可以看到具体的请求地址，请求参数，请求返回值
   
2018-11-27 升级1.0.2

> 1、请求返回值现在添加了NSURLSessionTask的返回值，现在可以自己在别的地方处理请求的取消了
