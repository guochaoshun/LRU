//
//  ULLRUCache+Dictionary.h
//  UXLive
//
//  Created by 郭朝顺 on 2022/3/17.
//  Copyright © 2022 UXIN CO. All rights reserved.
//

#import "ULLRUCache.h"

@interface ULLRUCache (Convenience)

/// 由键值对进行初始化逻辑
/// @param dictionary @{ @"key": @"value"}
/// @param countLimit 最大容量
- (instancetype)initWithDictionary:(NSDictionary *)dictionary countLimit:(NSUInteger)countLimit;
// 转换成键值对
/// @return  @{ @"key": @"value"}
- (NSDictionary *)asDictionary;



@end
