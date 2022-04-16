//
//  ViewController.m
//  测试刷新冲突
//
//  Created by 郭朝顺 on 2021/9/24.
//

#import "ViewController.h"
#import "ULLRUCache.h"
#import "Person.h"
#import "ULLRULinkedList.h"
#import "SafeLRUCache.h"

@interface ViewController ()<ULLRUCacheDelegate>

@end

@implementation ViewController

/// 获取引用计数
void retainCount(id obj) {
    NSLog(@"%@ %ld", obj,CFGetRetainCount((__bridge CFTypeRef)obj));
}
/// 打印自动释放池的内容
extern void _objc_autoreleasePoolPrint(void);

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self cacheThreadTest];
    [self safeCacheThreadTest];
}

- (void)cacheThreadTest {

    // 无线程安全的类,执行1W次,必定出现野指针crash
    ULLRUCache *cache = [[ULLRUCache alloc] init];
    cache.countLimit = 3;
    for (NSInteger i = 0; i < 10000; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [cache setObject:[Person new] forKey:@"1"];
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [cache setObject:[Person new] forKey:@"2"];
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [cache setObject:[Person new] forKey:@"3"];
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [cache setObject:[Person new] forKey:@"4"];
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [cache removeObjectForKey:@"3"];
        });
    }
}


- (void)safeCacheThreadTest {
    // 线程安全的类,执行10*1W次,都正常
    // 制作线程安全的类思路: https://blog.csdn.net/u014600626/article/details/107691986
    SafeLRUCache *cache = [[SafeLRUCache alloc] init];
    cache.countLimit = 3;
    for (NSInteger i = 0; i < 10000; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [cache setObject:[Person new] forKey:@"1"];
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [cache setObject:[Person new] forKey:@"2"];
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [cache setObject:[Person new] forKey:@"3"];
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [cache setObject:[Person new] forKey:@"4"];
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [cache objectforKey:@"4"];
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [cache removeObjectForKey:@"3"];
        });
    }
}

@end
