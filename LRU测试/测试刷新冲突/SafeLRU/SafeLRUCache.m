//
//  SafeLRUCache.m
//  测试刷新冲突
//
//  Created by 郭朝顺 on 2022/4/16.
//

#import "SafeLRUCache.h"
#import <UIKit/UIKit.h>

@interface SafeLRUCache ()

/// 串行队列
@property (nonatomic, strong) dispatch_queue_t cacheQueue;

@end

@implementation SafeLRUCache

#pragma mark -初始化方法
- (instancetype)initWithDictionary:(NSDictionary *)dictionary countLimit:(NSUInteger)countLimit {
    self = [self init];
    if (self) {
        self.countLimit = countLimit;
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (self.count < countLimit) {
                [self setObject:obj forKey:key];
            } else {
                *stop = YES;
            }
        }];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _nodeDic = [NSMutableDictionary dictionary];
        _linkedList = [[ULLRULinkedList alloc] init];
        _count = 0;
        _countLimit = NSIntegerMax;
        _cacheQueue = dispatch_queue_create("com.demo.safeLRUCache", NULL);
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMemoryWarning)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}
#pragma mark 初始化结束

#pragma mark -外界调用方法
/// 外界调用的方法都放到串行队列中执行
- (void)setObject:(id<NSObject>)object forKey:(id<NSCopying>)key {
    dispatch_sync(self.cacheQueue, ^{
        [self p_inQueue_setObject:object forKey:key];
    });
}

- (id<NSObject>)objectforKey:(id<NSCopying>)key {
    __block id result = nil;
    dispatch_sync(self.cacheQueue, ^{
        result = [self p_inQueue_objectforKey:key];
    });
    return result;
}

- (void)removeObjectForKey:(id<NSCopying>)key {
    dispatch_sync(self.cacheQueue, ^{
        [self p_inQueue_removeObjectForKey:key];
    });
}

- (NSUInteger)count {
    __block NSUInteger result = 0;
    dispatch_sync(self.cacheQueue, ^{
        result = _count;
    });
    return result;
}

- (void)removeAllObjects {
    dispatch_sync(self.cacheQueue, ^{
        [self p_inQueue_removeAllObjects];
    });
}

- (void)updateCountLimit:(NSUInteger)countLimit {
    dispatch_sync(self.cacheQueue, ^{
        [self p_inQueue_updateCountLimit:countLimit];
    });
}

- (id<NSObject>)objectForKeyedSubscript:(id<NSCopying>)key {
    return [self objectforKey:key];
}

- (void)setObject:(id<NSObject,NSCopying>)obj forKeyedSubscript:(id<NSCopying>)key {
    [self setObject:obj forKey:key];
}

- (NSDictionary *)asDictionary {
    __block NSDictionary *resultDic = nil;
    dispatch_sync(self.cacheQueue, ^{
        resultDic = [self p_inQueue_asDictionary];
    });
    return resultDic;
}

#pragma mark 外界调用方法结束
#pragma mark -内部已加入串行队列的方法

- (void)p_inQueue_setObject:(id<NSObject>)object forKey:(id<NSCopying>)key {
    if (!key) {
        return;
    }
    ULLRUNode *node = [self.nodeDic objectForKey:key];
    // node存在,更新node
    if (node) {
        // object不存在,触发移除操作
        if (!object) {
            [self.nodeDic removeObjectForKey:key];
            [self.linkedList removeNode:node];
            self.count --;
        } else {
            // object存在,触发更新操作
            if (![node.value isEqual:object]) {
                node.value = object;
            }
            // 移动到头节点
            [self.linkedList moveToHead:node];
        }
    } else {
        // node不存在,新增一个node到字典和数组中
        ULLRUNode *newNode = [[ULLRUNode alloc] initWithKey:key value:object];
        [self.nodeDic setObject:newNode forKey:key];
        [self.linkedList addToHead:newNode];
        self.count ++;

        // 检查数量有没有超出
        [self p_inQueue_checkoutLimitCount];
    }
}

- (id<NSObject>)p_inQueue_objectforKey:(id<NSCopying>)key {
    if (!key) {
        return nil;
    }
    ULLRUNode *node = [self.nodeDic objectForKey:key];
    if (node) {
        [self.linkedList moveToHead:node];
    }
    return node.value;
}

- (void)p_inQueue_removeObjectForKey:(id<NSCopying>)key {
    if (!key) {
        return;
    }
    ULLRUNode *node = [self.nodeDic objectForKey:key];
    if (!node) {
        return;
    }
    [self.nodeDic removeObjectForKey:key];
    [self.linkedList removeNode:node];
    self.count --;
}

- (void)p_inQueue_removeAllObjects {
    [self.nodeDic removeAllObjects];
    [self.linkedList removeAllObjects];
    self.count = 0;
}


- (void)p_inQueue_updateCountLimit:(NSUInteger)countLimit {
    self.countLimit = countLimit;
    [self p_inQueue_checkoutLimitCount];
}

// 检查有没有超出限制,如果超出后触发丢弃策略
- (void)p_inQueue_checkoutLimitCount {
    // 若动态修改容量大小，得有这种超限策略加持
    if (self.count > self.countLimit) {
        NSUInteger diff = self.count - self.countLimit;
        for (NSUInteger i = 0; i < diff; i++) {
            ULLRUNode *trailNode = [self.linkedList removeTrailNode];
            [self.nodeDic removeObjectForKey:trailNode.key];
            self.count --;
        }
    }
}

- (id<NSObject>)p_inQueue_objectForKeyedSubscript:(id<NSCopying>)key {
    return [self objectforKey:key];
}

- (void)p_inQueue_setObject:(id<NSObject,NSCopying>)obj forKeyedSubscript:(id<NSCopying>)key {
    [self setObject:obj forKey:key];
}

- (NSDictionary *)p_inQueue_asDictionary {
    NSMutableDictionary *retVal = [NSMutableDictionary dictionaryWithCapacity:self.count];
    ULLRUNode *node = self.linkedList.headNode;
    while (node) {
        [retVal setObject:node.value forKey:node.key];
        node = (ULLRUNode *)node.next;
    }
    return retVal;
}


#pragma mark -内部已加入串行队列的方法结束

#pragma mark -内部方法

- (void)didReceiveMemoryWarning {
    if (self.ingoredMemoryWarning) {
        return;
    }
    [self p_inQueue_removeAllObjects];
}

- (void)dealloc {
    [self p_inQueue_removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
