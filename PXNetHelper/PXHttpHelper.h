//
//  PXHttpHelper.h
//
//  Created by Charles on 2018/4/9.
//  Copyright © 2018年 pengxiang-qi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,PXNetWorkStatus) {
    PXNetWorkStatusUnknow = -1,/** 未知网络*/
    PXNetworkStatusNoNet  = 0, /** 无网络 */
    PXNetWorkStatusWifi   = 1, /** WIFI */
    PXNetworkStatusPhone  = 2  /** 手机网络 */
};

typedef void(^requestCache)(id cacheObj);
typedef void(^netStatusChange)(PXNetWorkStatus status);
typedef void(^requestSuccess)(NSURLSessionTask *task ,id responseObject);
typedef void(^requestFailure)(NSURLSessionTask *task ,NSError *error);
typedef void(^requestProgress)(NSProgress *progress);

@interface PXHttpHelper : NSObject


/**
 无缓存POST请求

 @param url 请求地址
 @param params 请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
 */
+ (NSURLSessionTask *)post:(nonnull NSString *)url
                    params:(nullable NSDictionary *)params
                   success:(nullable requestSuccess)success
                   failure:(nullable requestFailure)failure;

/**
 无缓存GET请求

 @param url 请求地址
 @param params 请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
 */
+ (NSURLSessionTask *)get:(nonnull NSString *)url
                   params:(nullable NSDictionary *)params
                  success:(nullable requestSuccess)success
                  failure:(nullable requestFailure)failure;

/**
 有缓存POST请求

 @param url 请求地址
 @param params 请求参数
 @param cache 缓存回调
 @param success 请求成功回调
 @param failure 请求失败回调
 */
+ (NSURLSessionTask *)post:(nonnull NSString *)url
                    params:(nullable NSDictionary *)params
                     cache:(nullable requestCache)cache
                   success:(nullable requestSuccess)success
                   failure:(nullable requestFailure)failure;

/**
 有缓存GET请求

 @param url 请求地址
 @param params 请求参数
 @param cache 缓存回调
 @param success 请求成功回调
 @param failure 请求失败回调
 */
+ (NSURLSessionTask *)get:(nonnull NSString *)url
                   params:(nullable NSDictionary *)params
                    cache:(nullable requestCache)cache
                  success:(nullable requestSuccess)success
                  failure:(nullable requestFailure)failure;

/**
 上传图片

 @param url 上传路径
 @param params 请求参数
 @param keyName 关键字
 @param hite 压缩比
 @param images 图片数组
 @param names 图片名字数组
 @param progress 上传进度
 @param success 上传成功回调
 @param failure 上传失败回调
 */
+ (NSURLSessionTask *)upload:(nonnull NSString *)url
                      params:(nullable NSDictionary *)params
                     keyName:(nullable NSString *)keyName
                        hite:(CGFloat)hite
                      images:(nonnull NSArray<UIImage *>*)images
                       names:(nullable NSArray<NSString *>*)names
                    progress:(nullable requestProgress)progress
                     success:(nullable requestSuccess)success
                     failure:(nullable requestFailure)failure;


/**
 日志打印开关

 @param open 是否打开日志打印
 */
+ (void)openLog:(BOOL)open;

/**
 获取当前网络状态

 @param status 网络状态回调
 */
+ (void)currentNetStatus:(netStatusChange)status;

/**
 修改请求超时时间

 @param timeoutInterval 超时时间
 */
+ (void)changeTimeoutInterval:(NSTimeInterval)timeoutInterval;

/**
 取消请求

 @param url 如果为nil则取消全部请求，否则只取消对应url的请求
 */
+ (void)cancelTask:(nullable NSString *)url;

/**
 设置请求Header

 @param key Header的key
 @param value Header的value
 */
+ (void)setHeadForRequest:(nonnull NSString *)key value:(nonnull NSString *)value;

@end


