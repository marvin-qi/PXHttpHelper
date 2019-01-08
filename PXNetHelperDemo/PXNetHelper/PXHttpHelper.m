//
//  PXHttpHelper.m
//
//  Created by Charles on 2018/4/9.
//  Copyright © 2018年 pengxiang-qi. All rights reserved.
//

#import "PXHttpHelper.h"
#import "AFNetworking.h"
#import "PXCache.h"

#define DEBUGLOG
#ifdef DEBUGLOG
#      define PXNetLog(fmt, ...) NSLog((@"%s == %s == [Line %d] == " fmt), __PRETTY_FUNCTION__, __func__ , __LINE__, ##__VA_ARGS__);
#else
#      define PXNetLog(...)
#endif

@interface PXHttpHelper ()
@property (nonatomic,strong) AFHTTPSessionManager *manager;
@property (nonatomic,strong) PXCache *mCache;
@property (nonatomic,strong) NSMutableArray <NSURLSessionTask *>*mTaskSource;
@property (nonatomic,assign) BOOL isLog;
@end

@implementation PXHttpHelper

static PXHttpHelper *_helper;

+ (PXHttpHelper *)helper{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_helper) {
            _helper = [[super alloc] init];
        }
    });
    return _helper;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setupManager];
    }
    return self;
}

- (void)setupManager{
    self.mCache = [PXCache cache];
    //开启网络监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    self.manager.requestSerializer.timeoutInterval = 10.f;
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    // 打开状态栏的等待菊花
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

+ (NSURLSessionTask *)post:(NSString *)url params:(NSDictionary *)params success:(requestSuccess)success failure:(requestFailure)failure{
    return [self post:url params:params cache:nil success:success failure:failure];
}

+ (NSURLSessionTask *)get:(NSString *)url params:(NSDictionary *)params success:(requestSuccess)success failure:(requestFailure)failure{
    return [self get:url params:params cache:nil success:success failure:failure];
}

+ (NSURLSessionTask *)post:(NSString *)url params:(NSDictionary *)params cache:(requestCache)cache success:(requestSuccess)success failure:(requestFailure)failure{
    PXHttpHelper *helper = [PXHttpHelper helper];
    NSString *cacheKey = [helper.mCache getCacheKey:url params:params];
    if (cache) {
        id cacheObj = [helper.mCache readObjectWithKey:cacheKey];
        cache(cacheObj);
        [helper log:url params:params obj:cacheObj];
    }
    __weak __typeof(helper)weakHelper = helper;
    NSURLSessionTask *request = [helper.manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong __typeof(weakHelper)strongHelper = weakHelper;
        [strongHelper.mTaskSource removeObject:task];
        [strongHelper log:url params:params obj:responseObject];
        if (cache) [strongHelper.mCache cacheObject:responseObject withKey:cacheKey];
        success?success(task, responseObject):nil;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong __typeof(weakHelper)strongHelper = weakHelper;
        [strongHelper.mTaskSource removeObject:task];
        [strongHelper log:url params:params obj:error];
        failure?failure(task, error):nil;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    helper.mTaskSource?[helper.mTaskSource addObject:request]:nil;
    return request;
}

+ (NSURLSessionTask *)get:(NSString *)url params:(NSDictionary *)params cache:(requestCache)cache success:(requestSuccess)success failure:(requestFailure)failure{
    PXHttpHelper *helper = [PXHttpHelper helper];
    NSString *cacheKey = [helper.mCache getCacheKey:url params:params];
    if (cache) {
        id cacheObj = [helper.mCache readObjectWithKey:cacheKey];
        cache(cacheObj);
        [helper log:url params:params obj:cacheObj];
    }
    __weak __typeof(helper)weakHelper = helper;
    NSURLSessionTask *request = [helper.manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong __typeof(weakHelper)strongHelper = weakHelper;
        [strongHelper.mTaskSource removeObject:task];
        [strongHelper log:url params:params obj:responseObject];
        if (cache) [strongHelper.mCache cacheObject:responseObject withKey:cacheKey];
        success?success(task, responseObject):nil;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong __typeof(weakHelper)strongHelper = weakHelper;
        [strongHelper.mTaskSource removeObject:task];
        [strongHelper log:url params:params obj:error];
        failure?failure(task, error):nil;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    helper.mTaskSource?[helper.mTaskSource addObject:request]:nil;
    return request;
}

+ (NSURLSessionTask *)upload:(NSString *)url
                      params:(NSDictionary *)params
                     keyName:(NSString *)keyName
                        hite:(CGFloat)hite
                      images:(NSArray<UIImage *> *)images
                       names:(NSArray<NSString *> *)names
                    progress:(requestProgress)progress
                     success:(requestSuccess)success
                     failure:(requestFailure)failure{
    PXHttpHelper *helper = [PXHttpHelper helper];
    __weak __typeof(helper)weakHelper = helper;
    hite = hite==0?.2:hite;
    NSURLSessionTask *request = [helper.manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSAssert(images.count>0, @"images 参数必传");
        for (int index = 0; index < images.count; index++) {
            NSString *fileName = [formatter stringFromDate:[NSDate date]];
            if (names.count == images.count) {
                fileName = [names objectAtIndex:index];
            }
            UIImage *image = [images objectAtIndex:index];
            NSData *imageData = UIImageJPEGRepresentation(image, hite);
            [formData appendPartWithFileData:imageData name:fileName fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong __typeof(weakHelper)strongHelper = weakHelper;
        [strongHelper.mTaskSource removeObject:task];
        [strongHelper log:url params:params obj:responseObject];
        success?success(task, responseObject):nil;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong __typeof(weakHelper)strongHelper = weakHelper;
        [strongHelper.mTaskSource removeObject:task];
        [strongHelper log:url params:params obj:error];
        failure?failure(task, error):nil;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    helper.mTaskSource?[helper.mTaskSource addObject:request]:nil;
    return request;
}

+ (void)openLog:(BOOL)open{
    [PXHttpHelper helper].isLog = open;
}

+ (void)currentNetStatus:(netStatusChange)status{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus netStatus) {
        status?status(netStatus):nil;
    }];
}

+ (void)changeTimeoutInterval:(NSTimeInterval)timeoutInterval{
    [PXHttpHelper helper].manager.requestSerializer.timeoutInterval = timeoutInterval;
}

+ (void)setHeadForRequest:(NSString *)key value:(NSString *)value{
    [[PXHttpHelper helper].manager.requestSerializer setValue:value forHTTPHeaderField:key];
}

+ (void)cancelTask:(NSString *)url{
    PXHttpHelper *helper = [PXHttpHelper helper];
    if (helper.mTaskSource.count<1)return;
    if (!url) {
        //取消全部请求
        @synchronized(helper){
            [helper.mTaskSource enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
                [task cancel];
            }];
            [helper.mTaskSource removeAllObjects];
        }
    }else{
        //取消单个请求
        @synchronized(helper){
            __weak __typeof(helper)weakHelper = helper;
            [helper.mTaskSource enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([task.currentRequest.URL.absoluteString hasPrefix:url]) {
                    [task cancel];
                    __strong __typeof(weakHelper)strongHelper = weakHelper;
                    [strongHelper.mTaskSource removeObject:task];
                    *stop = YES;
                }
            }];
        }
    }
}

- (void)log:(NSString *)url params:(NSDictionary *)params obj:(id)obj{
    if (self.isLog) {
        PXNetLog(@"\nurl === %@\nparams === %@\nobj === %@",url,params,obj);
    }
}

- (NSMutableArray<NSURLSessionTask *> *)mTaskSource{
    if (_mTaskSource) {
        _mTaskSource = [NSMutableArray new];
    }
    return _mTaskSource;
}

@end

