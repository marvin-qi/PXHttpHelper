//
//  ViewController.m
//  PXNetHelper
//
//  Created by Charles on 2018/5/7.
//  Copyright © 2018年 pengxiang-qi. All rights reserved.
//

#import "ViewController.h"
#import "PXHttpHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //关闭打印
    [PXHttpHelper px_OpenLog:NO];
    //打开打印
    [PXHttpHelper px_OpenLog:YES];
    //监听网络
    [PXHttpHelper px_currentNetWorkStatus:^(PXNetWorkStatus status) {
        
    }];
    
    //无缓存GET请求
    [PXHttpHelper px_getWithURLString:@"" params:nil success:^(NSURLSessionTask *task,id responseObject) {
        //data转换json
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionTask *task,NSError *error) {

    }];

    //有缓存GET请求
    [PXHttpHelper px_getWithURLString:@"" params:@{@"key":@"value"} cache:^(id cacheObject) {

    } success:^(NSURLSessionTask *task,id responseObject) {

    } failure:^(NSURLSessionTask *task,NSError *error) {

    }];
    
    //无缓存POST请求
    [PXHttpHelper px_postWithURLString:@"http://vn.demo.joels.cc/app/login/gettoken" params:nil success:^(NSURLSessionTask *task,id responseObject) {
        [PXHttpHelper px_postWithURLString:@"http://vn.demo.joels.cc/app/Home/goodsList" params:@{@"id":@(0),@"token":@"A180AE068450CFE8FC3FC26E24226F5B"} success:^(NSURLSessionTask *task,id res) {
            NSLog(@"我的打印===%@",res);
        } failure:nil];
    } failure:^(NSURLSessionTask *task,NSError *error) {
        
    }];
    
    //有缓存POST请求
    [PXHttpHelper px_postWithURLString:@"" params:@{@"key":@"value"} cache:^(id cacheObject) {
        //缓存
    } success:^(NSURLSessionTask *task,id responseObject) {
        //
    } failure:^(NSURLSessionTask *task,NSError *error) {

    }];

    //上传图片
    [PXHttpHelper px_uploadWithURLString:@"" params:@{@"key":@"value"} keyName:@"" images:@[[UIImage imageNamed:@"res_img_poi_logo_default@2x"]] names:@[@"meituan"] progress:^(NSProgress *progress) {

    } success:^(NSURLSessionTask *task,id responseObject) {

    } failure:^(NSURLSessionTask *task,NSError *error) {

    }];
    
    //取消@""请求
    [PXHttpHelper px_cancelTask:@""];
    
    //取消全部请求
    [PXHttpHelper px_cancelTask:nil];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
