//
//  PXHttpHelper.m
//
//  Created by Charles on 2018/4/9.
//  Copyright © 2018年 pengxiang-qi. All rights reserved.
//

#import "PXHttpHelper.h"
#import "AFNetworking.h"

#define DEBUGLOG
#ifdef DEBUGLOG
#      define PXNetLog(fmt, ...) NSLog((@"%s == %s == [Line %d] == " fmt), __PRETTY_FUNCTION__, __func__ , __LINE__, ##__VA_ARGS__);
#else
#      define PXNetLog(...)
#endif

@implementation PXHttpHelper

static BOOL isLog = YES;
static AFHTTPSessionManager *manager;
static NSMutableArray <NSURLSessionTask *> *mTaskSource;

#pragma mark =====================启动========================
+ (void)load{
    //开启网络监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark =====================初始化manager========================
+ (void)initialize{
    manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    // 打开状态栏的等待菊花
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

#pragma mark =====================获取当前网络环境========================
+ (void)px_currentNetWorkStatus:(networkStatus)netStatus{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        netStatus?netStatus(status):nil;
    }];
}

#pragma mark =====================是否打开日志打印========================
+ (void)px_OpenLog:(BOOL)Log{
    isLog = Log;
}

#pragma mark =====================设置超时时间========================
+ (void)px_changeTimeoutInterval:(NSTimeInterval)timeoutInterval{
    manager.requestSerializer.timeoutInterval = timeoutInterval;
}

#pragma mark =====================无缓存的post请求========================
+ (NSURLSessionTask *)px_postWithURLString:(NSString *)URLString params:(NSDictionary *)params success:(success)success failure:(failure)failure{
    return [self px_postWithURLString:URLString params:params cache:nil success:success failure:failure];
}

#pragma mark =====================无缓存的get请求========================
+ (NSURLSessionTask *)px_getWithURLString:(NSString *)URLString params:(NSDictionary *)params success:(success)success failure:(failure)failure{
    return [self px_getWithURLString:URLString params:params cache:nil success:success failure:failure];
}

#pragma mark =====================有缓存的post请求========================
+ (NSURLSessionTask *)px_postWithURLString:(NSString *)URLString params:(NSDictionary *)params cache:(cache)cache success:(success)success failure:(failure)failure{
    NSString *key = [self getCacheKeyWithURLString:URLString params:params];
    if (cache) {
        id cacheObject = [[PXCache getInstance] px_readObjectWithKey:key];
        cache(cacheObject);
        if (isLog) PXNetLog(@"URLString = %@ \nparams = %@ \nresponse = %@",URLString,params,cacheObject);
    }
    NSURLSessionTask *sessionTask = [manager POST:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [mTaskSource removeObject:task];
        if (isLog) PXNetLog(@"URLString = %@ \nparams = %@ \nresponse = %@",URLString,params,responseObject);
        if (cache) [[PXCache getInstance] px_cacheObject:responseObject withKey:key];
        success?success(task,responseObject):nil;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [mTaskSource removeObject:task];
        if (isLog) PXNetLog(@"URLString = %@ \nparams = %@ \nerror = %@",URLString,params,error);
        failure?failure(task,error):nil;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    mTaskSource?[mTaskSource addObject:sessionTask]:nil;
    return sessionTask;
}

#pragma mark =====================有缓存的get请求========================
+ (NSURLSessionTask *)px_getWithURLString:(NSString *)URLString params:(NSDictionary *)params cache:(cache)cache success:(success)success failure:(failure)failure{
    NSString *key = [self getCacheKeyWithURLString:URLString params:params];
    if (cache) {
        id cacheObject = [[PXCache getInstance] px_readObjectWithKey:key];
        cache(cacheObject);
        if (isLog) PXNetLog(@"URLString = %@ \nparams = %@ \nresponse = %@",URLString,params,cacheObject);
    }
    NSURLSessionTask *sessionTask = [manager GET:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [mTaskSource removeObject:task];
        if (isLog) PXNetLog(@"URLString = %@ \nparams = %@ \nresponse = %@",URLString,params,responseObject);
        if (cache) [[PXCache getInstance] px_cacheObject:responseObject withKey:key];
        success?success(task,responseObject):nil;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [mTaskSource removeObject:task];
        if (isLog) PXNetLog(@"URLString = %@ \nparams = %@ \nerror = %@",URLString,params,error);
        failure?failure(task,error):nil;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    mTaskSource?[mTaskSource addObject:sessionTask]:nil;
    return sessionTask;
}

#pragma mark =====================上传一组图片========================
+ (NSURLSessionTask *)px_uploadWithURLString:(NSString *)URLString
                                      params:(NSDictionary *)params
                                     keyName:(NSString *)keyName
                                      images:(NSArray<UIImage *> *)images
                                       names:(NSArray<NSString *> *)names
                                    progress:(void (^)(NSProgress *))progress
                                     success:(success)success
                                     failure:(failure)failure{
    NSURLSessionTask *sessionTask = [manager POST:URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传文件
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat            = @"yyyyMMddHHmmss";
        for (NSInteger index = 0; index < images.count;index ++) {
            NSString *str                   = [formatter stringFromDate:[NSDate date]];
            NSString *fileName              = [NSString stringWithFormat:@"%@.jpg", str];
            UIImage *image = [images objectAtIndex:index];
            if (index < names.count) {
                fileName = [names objectAtIndex:index];
                fileName = [fileName stringByAppendingString:@".jpg"];
            }
            NSData *imageData = UIImageJPEGRepresentation(image, .2);
            [formData appendPartWithFileData:imageData name:keyName fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [mTaskSource removeObject:task];
        responseObject = responseObject?[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]:nil;
        if (isLog) PXNetLog(@"URLString = %@ \nparams = %@ \nresponse = %@",URLString,params,responseObject);
        success?success(task,responseObject):nil;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [mTaskSource removeObject:task];
        if (isLog) PXNetLog(@"URLString = %@ \nparams = %@ \nerror = %@",URLString,params,error);
        failure?failure(task,error):nil;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    mTaskSource?[mTaskSource addObject:sessionTask]:nil;
    return sessionTask;
}

#pragma mark =====================获取缓存的关键字========================
+ (NSString *)getCacheKeyWithURLString:(NSString *)URLString params:(NSDictionary *)params{
    return [[PXCache getInstance] px_getCacheKey:URLString params:params];
}

#pragma mark =====================取消某个请求，URLString=nil取消全部请求========================
+ (void)px_cancelTask:(NSString *)URLString{
    if ([self mTaskSource].count<1)return;
    if (!URLString) {
        //取消全部请求
        @synchronized(self){
            [[self mTaskSource] enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
                [task cancel];
            }];
            [[self mTaskSource] removeAllObjects];
        }
    }else{
        //取消单个请求
        @synchronized(self){
            [[self mTaskSource] enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([task.currentRequest.URL.absoluteString hasPrefix:URLString]) {
                    [task cancel];
                    [[self mTaskSource] removeObject:task];
                    *stop = YES;
                }
            }];
        }
    }
}

#pragma mark =====================设置请求头========================
+ (void)px_setHeadForRequest:(NSString *)key value:(NSString *)value{
    [manager.requestSerializer setValue:value forHTTPHeaderField:key];
}

+ (NSMutableArray *)mTaskSource{
    if (!mTaskSource) {
        mTaskSource = [NSMutableArray new];
    }
    return mTaskSource;
}

@end

#pragma mark =====================NSDictionary,NSArray的分类========================

#ifdef DEBUG
@implementation NSArray (PXHttpHelper)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    [strM appendString:@")"];
    return strM;
}

@end

@implementation NSDictionary (PXHttpHelper)

- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    [strM appendString:@"}\n"];
    return strM;
}
@end
#endif
