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
    
    //打开打印
    [PXHttpHelper px_OpenLog:YES];
    //关闭打印
    [PXHttpHelper px_OpenLog:NO];
    //监听网络
    [PXHttpHelper px_currentNetWorkStatus:^(PXNetWorkStatus status) {
        
    }];
    //无缓存GET请求
    [PXHttpHelper px_getWithURLString:@"" params:nil success:^(id responseObject) {
        //data转换json
        responseObject = responseObject?[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil]:nil;
        NSLog(@"%@",responseObject);
    } failure:^(NSError *error) {
        
    }];
    
    //有缓存GET请求
    [PXHttpHelper px_getWithURLString:@"" params:@{@"key":@"value"} cache:^(id cacheObject) {
        
    } success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
    //无缓存POST请求
    [PXHttpHelper px_postWithURLString:@"" params:@{@"key":@"value"} success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
    //有缓存POST请求
    [PXHttpHelper px_postWithURLString:@"" params:@{@"key":@"value"} cache:^(id cacheObject) {
        //缓存
    } success:^(id responseObject) {
        //
    } failure:^(NSError *error) {
        
    }];
    
    //上传图片
    [PXHttpHelper px_uploadWithURLString:@"" params:@{@"key":@"value"} keyName:@"" images:@[[UIImage imageNamed:@"res_img_poi_logo_default@2x"]] names:@[@"meituan"] progress:^(NSProgress *progress) {

    } success:^(id responseObject) {

    } failure:^(NSError *error) {

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
