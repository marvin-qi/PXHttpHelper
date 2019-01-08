//
//  NSSet+PXHttp.m
//  PXNetHelperDemo
//
//  Created by Charles on 2019/1/8.
//  Copyright © 2019 pengxiang-qi. All rights reserved.
//

#import "NSSet+PXHttp.h"

#ifdef DEBUG
@implementation NSSet (PXHttp)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level{
    NSString *output;
    @try {
        output = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        output = [output stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    } @catch (NSException *exception) {
        output = self.description;
    } @finally {
        
    }
    return  output;
}
/*
NSMutableString *desc = [NSMutableString string];

NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
for (NSUInteger i = 0; i < level; ++i) {
    [tabString appendString:@"\t"];
}

NSString *tab = @"\t";
if (level > 0) {
    tab = tabString;
}
[desc appendString:@"\t{(\n"];

for (id obj in self) {
    if ([obj isKindOfClass:[NSDictionary class]]
        || [obj isKindOfClass:[NSArray class]]
        || [obj isKindOfClass:[NSSet class]]) {
        NSString *str = [((NSDictionary *)obj) descriptionWithLocale:locale indent:level + 1];
        [desc appendFormat:@"%@\t%@,\n", tab, str];
    } else if ([obj isKindOfClass:[NSString class]]) {
        [desc appendFormat:@"%@\t\"%@\",\n", tab, obj];
    } else if ([obj isKindOfClass:[NSData class]]) {
        // 如果是NSData类型，尝试去解析结果，以打印出可阅读的数据
        NSError *error = nil;
        NSObject *result =  [NSJSONSerialization JSONObjectWithData:obj
                                                            options:NSJSONReadingMutableContainers
                                                              error:&error];
        // 解析成功
        if (error == nil && result != nil) {
            if ([result isKindOfClass:[NSDictionary class]]
                || [result isKindOfClass:[NSArray class]]
                || [result isKindOfClass:[NSSet class]]) {
                NSString *str = [((NSDictionary *)result) descriptionWithLocale:locale indent:level + 1];
                [desc appendFormat:@"%@\t%@,\n", tab, str];
            } else if ([obj isKindOfClass:[NSString class]]) {
                [desc appendFormat:@"%@\t\"%@\",\n", tab, result];
            }
        } else {
            @try {
                NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                if (str != nil) {
                    [desc appendFormat:@"%@\t\"%@\",\n", tab, str];
                } else {
                    [desc appendFormat:@"%@\t%@,\n", tab, obj];
                }
            }
            @catch (NSException *exception) {
                [desc appendFormat:@"%@\t%@,\n", tab, obj];
            }
        }
    } else {
        [desc appendFormat:@"%@\t%@,\n", tab, obj];
    }
}
[desc appendFormat:@"%@)}", tab];
return desc;
 */
@end
#endif