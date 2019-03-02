//
//  PXCache.m
//  PXNetHelper
//
//  Created by Charles on 2018/4/9.
//  Copyright © 2018年 pengxiang-qi. All rights reserved.
//

#import "PXCache.h"

@implementation PXCache

static PXCache *instance;
+ (PXCache *)cache{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == instance) {
            instance = [[super alloc] init];
        }
    });
    return instance;
}

+ (NSString *)getCacheKey:(NSString *)URLString params:(NSDictionary *)params{
    if (params.count < 1 || params == nil || !params) {
        return URLString;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSString *paramString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [URLString stringByAppendingString:paramString];
}

+ (void)clearAllCache{
    [[PXCache cache] removeAllObjects];
}

+ (void)clearCacheWithKey:(NSString *)key{
    [[PXCache cache] removeObjectForKey:key];
}

+ (void)cacheObject:(id)obj withKey:(NSString *)key{
    [[PXCache cache] setObject:obj forKey:key];
}

+ (id)readObjectWithKey:(NSString *)key{
    return [[PXCache cache] objectForKey:key];
}

@end


