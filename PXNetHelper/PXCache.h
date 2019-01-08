//
//  PXCache.h
//  PXNetHelper
//
//  Created by Charles on 2018/4/9.
//  Copyright © 2018年 pengxiang-qi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXCache : NSCache

/**
 获取单例

 @return 返回实例
 */
+ (PXCache *)cache;

/**
 缓存一个object，用key作为关键字

 @param obj 需要缓存的内容
 @param key 缓存关键字
 */
- (void)cacheObject:(id)obj withKey:(NSString *)key;

/**
 读取意key为关键字的缓存内容

 @param key 关键字
 @return 返回读取的缓存内容
 */
- (id)readObjectWithKey:(NSString *)key;

/**
 清除全部缓存
 */
- (void)clearAllCache;

/**
 清除以key为关键字的缓存内容

 @param key 关键字
 */
- (void)clearCacheWithKey:(NSString *)key;

/**
 根据URLString与params生成一个关键字

 @param URLString 一个字符串
 @param params 字典值
 @return 返回一个混合成的关键字
 */
- (NSString *)getCacheKey:(NSString *)URLString params:(NSDictionary *)params;

@end

