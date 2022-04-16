//
//  ULLRULinkedList.h
//  UXLive
//
//  Created by 郭朝顺 on 2022/3/17.
//  Copyright © 2022 UXIN CO. All rights reserved.
//

#import "ULLRUNode.h"

@interface ULLRULinkedList < Key : id<NSCopying>, Value : id<NSObject> > : NSObject

@property (nonatomic, strong, readonly) ULLRUNode *head;
@property (nonatomic, strong, readonly) ULLRUNode *trail;

// 将节点添加到头结点
- (void)addToHead:(ULLRUNode *)node;
// 将节点添加到尾结点
- (void)addToTrail:(ULLRUNode *)node;
// 移除节点
- (void)removeNode:(ULLRUNode *)node;
// 移除尾结点
- (ULLRUNode *)removeTrailNode;
// 移除头结点
- (ULLRUNode *)removeHeadNode;
// 移动到头结点
- (void)moveToHead:(ULLRUNode *)node;
// 移除所有元素
- (void)removeAllObjects;

- (NSInteger)count;

- (NSArray *)asArray;

@end
