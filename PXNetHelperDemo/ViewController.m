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
    [PXHttpHelper openLog:NO];
    //打开打印
    [PXHttpHelper openLog:YES];
    //监听网络
    [PXHttpHelper currentNetStatus:^(PXNetWorkStatus status) {
        
    }];
    
    //无缓存GET请求
    [PXHttpHelper get:@"" params:nil success:^(NSURLSessionTask *task, id responseObject) {
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        
    }];

    //有缓存GET请求
    [PXHttpHelper get:@"" params:@{@"key":@"value"} cache:^(id cacheObject) {
        
    } success:^(NSURLSessionTask *task, id responseObject) {
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        
    }];
    
    //无缓存POST请求
    [PXHttpHelper post:@"http://vn.demo.joels.cc/app/login/gettoken" params:nil success:^(NSURLSessionTask *task, id responseObject) {
        [PXHttpHelper post:@"http://vn.demo.joels.cc/app/Home/goodsList" params:@{@"id":@(0),@"token":@"A180AE068450CFE8FC3FC26E24226F5B"} success:^(NSURLSessionTask *task, id res) {
            NSLog(@"我的打印===%@",res);
        } failure:nil];
    } failure:^(NSURLSessionTask *task, NSError *error) {
        
    }];
    
    //有缓存POST请求
    [PXHttpHelper post:@"" params:@{@"key":@"value"} cache:nil success:nil failure:nil];

    //上传图片
    [PXHttpHelper upload:@"" params:nil keyName:@"" hite:.3 images:@[[UIImage imageNamed:@"res_img_poi_logo_default@2x"]] names:@[@""] progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionTask *task, id responseObject) {
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        
    }];
    
    //取消@""请求
    [PXHttpHelper cancelTask:@""];
    
    //取消全部请求
    [PXHttpHelper cancelTask:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
