//
//  PXHttpHelper.h
//
//  Created by Charles on 2018/4/9.
//  Copyright © 2018年 pengxiang-qi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PXCache.h"

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

@interface PXHttpHelper : NSObject

+ (instancetype)helper;

- (NSURLSessionTask *)post:(nonnull NSString *)url
                    params:(nullable NSDictionary *)params
                   success:(nullable requestSuccess)success
                   failure:(nullable requestFailure)failure;

- (NSURLSessionTask *)get:(nonnull NSString *)url
                   params:(nullable NSDictionary *)params
                  success:(nullable requestSuccess)success
                  failure:(nullable requestFailure)failure;

- (NSURLSessionTask *)post:(nonnull NSString *)url
                    params:(nullable NSDictionary *)params
                     cache:(nullable requestCache)cache
                   success:(nullable requestSuccess)success
                   failure:(nullable requestFailure)failure;

- (NSURLSessionTask *)get:(nonnull NSString *)url
                   params:(nullable NSDictionary *)params
                    cache:(nullable requestCache)cache
                  success:(nullable requestSuccess)success
                  failure:(nullable requestFailure)failure;

- (NSURLSessionTask *)upload:(nonnull NSString *)url
                      params:(nullable NSDictionary *)params
                     keyName:(nullable NSString *)keyName
                        hite:(CGFloat)hite
                      images:(nonnull NSArray<UIImage *>*)images
                       names:(nullable NSArray<NSString *>*)names
                    progress:(nullable void(^)(NSProgress *progress))progress
                     success:(nullable requestSuccess)success
                     failure:(nullable requestFailure)failure;

- (void)openLog:(BOOL)open;

- (void)currentNetStatus:(netStatusChange)status;

- (void)changeTimeoutInterval:(NSTimeInterval)timeoutInterval;

- (void)cancelTask:(nullable NSString *)url;

- (void)setHeadForRequest:(nonnull NSString *)key value:(nonnull NSString *)value;

@end


