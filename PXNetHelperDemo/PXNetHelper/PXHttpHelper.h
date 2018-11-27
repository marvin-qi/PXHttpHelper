//
//  PXHttpHelper.h
//
//  Created by Charles on 2018/4/9.
//  Copyright © 2018年 pengxiang-qi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PXCache.h"

static NSString *PXNetworkStatusChanged;

typedef NS_ENUM(NSUInteger,PXNetWorkStatus) {
    PXNetWorkStatusUnknow = -1,//未知网络
    PXNetworkStatusNoNet  = 0,//无网络
    PXNetWorkStatusWifi   = 1,//WIFI
    PXNetworkStatusPhone  = 2,//手机网络
};

typedef void(^cache)(id cacheObject);
typedef void(^networkStatus)(PXNetWorkStatus status);
typedef void(^success)(NSURLSessionDataTask *task ,id responseObject);
typedef void(^failure)(NSURLSessionDataTask *task ,NSError *error);

@interface PXHttpHelper : NSObject

/**
 是否打开打印日志

 @param Log 是否打开请求日志-默认打开
 */
+ (void)px_OpenLog:(BOOL)Log;

/**
 获取当前网络环境

 @param netStatus 当前网络环境回调
 */
+ (void)px_currentNetWorkStatus:(networkStatus)netStatus;

/**
 修改请求等待时间

 @param timeoutInterval 请求等待时间
 */
+ (void)px_changeTimeoutInterval:(NSTimeInterval)timeoutInterval;

/**
 无缓存的POST请求

 @param URLString 请求地址
 @param params 请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
 @return 返回可取消的请求
 */
+ (NSURLSessionTask *)px_postWithURLString:(NSString *)URLString
                                    params:(NSDictionary *)params
                                   success:(success)success
                                   failure:(failure)failure;

/**
 无缓存的GET请求

 @param URLString 请求地址
 @param params 请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
 @return 返回可取消的请求
 */
+ (NSURLSessionTask *)px_getWithURLString:(NSString *)URLString
                                   params:(NSDictionary *)params
                                  success:(success)success
                                  failure:(failure)failure;

/**
 有缓存的POST请求

 @param URLString 请求地址
 @param params 请求参数
 @param cache 缓存
 @param success 请求成功回调
 @param failure 请求失败回调
 @return 返回可取消的请求
 */
+ (NSURLSessionTask *)px_postWithURLString:(NSString *)URLString
                                    params:(NSDictionary *)params
                                     cache:(cache)cache
                                   success:(success)success
                                   failure:(failure)failure;

/**
 有缓存的GET请求

 @param URLString 请求地址
 @param params 请求参数
 @param cache 缓存
 @param success 请求成功回调
 @param failure 请求失败回调
 @return 返回可取消的请求
 */
+ (NSURLSessionTask *)px_getWithURLString:(NSString *)URLString
                                   params:(NSDictionary *)params
                                    cache:(cache)cache
                                  success:(success)success
                                  failure:(failure)failure;

/**
 上传一组图片

 @param URLString 请求地址
 @param params 请求参数
 @param keyName 图片关键字
 @param images 图片数组
 @param names 图片名字数组
 @param progress 上传进度回调
 @param success 成功回调
 @param failure 失败回调
 @return 返回可取消的请求
 */
+ (NSURLSessionTask *)px_uploadWithURLString:(NSString *)URLString
                                      params:(NSDictionary *)params
                                     keyName:(NSString *)keyName
                                      images:(NSArray<UIImage *>*)images
                                       names:(NSArray<NSString *>*)names
                                    progress:(void(^)(NSProgress *progress))progress
                                     success:(success)success
                                     failure:(failure)failure;

/**
 取消某个请求,如果URLString=nil,取消全部请求，否则取消单个请求

 @param URLString 如果URLString=nil,取消全部请求，否则取消单个请求
 */
+ (void)px_cancelTask:(NSString *)URLString;

/**
 设置请求头
 
 @param key 头的key
 @param value 头的value
 */
+ (void)px_setHeadForRequest:(NSString *)key value:(NSString *)value;

@end

#pragma mark =====================NSDictionary,NSArray的分类========================

#ifdef DEBUG
@interface NSArray (PXHttpHelper)

@end

@interface NSDictionary (PXHttpHelper)

@end
#endif
