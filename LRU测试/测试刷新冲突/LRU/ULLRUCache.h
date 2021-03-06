//
//  ULLRUCache.h
//  UXLive
//
//  Created by 郭朝顺 on 2022/3/16.
//  Copyright © 2022 UXIN CO. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ULLRUCache,ULLRULinkedList;

@protocol ULLRUCacheDelegate <NSObject>

@optional
// 丢弃一个元素
- (void)cache:(ULLRUCache *)cache didDropObject:(id)object forKey:(id)key;
// 更新一个元素：由-setObject:forKey: 触发
- (void)cache:(ULLRUCache *)cache didUpdateObject:(id)object forKey:(id)key;
// 收到内存警告，会丢弃所有的元素
- (void)cacheDidReceiveMemoryWarning:(ULLRUCache *)cache;

@end


// 提供一个基于LRU淘汰策略的缓存类；
// 注意：非线程安全，如果需要多线程使用时，建议自行包装加锁
@interface ULLRUCache < Key : id<NSCopying>, Value : id<NSObject> > : NSObject

// 基于个数控制缓存的数量，默认为NSIntegerMax
@property (nonatomic, assign) NSUInteger countLimit;

// 是否要忽略内存警告
@property (nonatomic, assign) BOOL ingoredMemoryWarning;
// ULLRUCacheDelegate
@property (nonatomic, weak) id<ULLRUCacheDelegate> delegate;

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
