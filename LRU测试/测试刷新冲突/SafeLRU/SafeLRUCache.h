//
//  SafeLRUCache.h
//  测试刷新冲突
//
//  Created by 郭朝顺 on 2022/4/16.
//

#import <Foundation/Foundation.h>
#import "ULLRULinkedList.h"

NS_ASSUME_NONNULL_BEGIN
// 提供一个线程安全的基于LRU淘汰策略的缓存类
@interface SafeLRUCache < Key : id<NSCopying>, Value : id<NSObject> > : NSObject

// 基于个数控制缓存的数量，默认为NSIntegerMax
@property (nonatomic, assign) NSUInteger countLimit;

// 是否要忽略内存警告
@property (nonatomic, assign) BOOL ingoredMemoryWarning;

/// 由键值对进行初始化逻辑
/// @param dictionary @{ @"key": @"value"}
/// @param countLimit 最大容量
- (instancetype)initWithDictionary:(NSDictionary *)dictionary countLimit:(NSUInteger)countLimit;

// 更新缓存数量限制,当前缓存数量超过会触发丢弃逻辑
// 时间复杂度：O(n) n: countLimit
- (void)updateCountLimit:(NSUInteger)countLimit;

// 时间复杂度：O(1)
- (NSUInteger)count;
// 时间复杂度：O(1)
- (void)setObject:(Value)object forKey:(Key)key;
// 时间复杂度：O(1)
- (Value)objectforKey:(Key)key;
// 时间复杂度：O(1)
- (void)removeObjectForKey:(Key)key;
// 移除所有的缓存
- (void)removeAllObjects;

/// 提供语法糖形式获取值
- (Value)objectForKeyedSubscript:(Key)key;
/// 提供语法糖形式设置值
- (void)setObject:(Value)obj forKeyedSubscript:(Key)key;

// 转换成键值对
/// @return  @{ @"key": @"value"}
- (NSDictionary *)asDictionary;

@end

NS_ASSUME_NONNULL_END
