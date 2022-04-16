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

@interface ViewController ()<ULLRUCacheDelegate>

@property (nonatomic, strong) ULLRULinkedList *linkList;

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


}


- (void)cacheTest {

}


// 丢弃一个元素
- (void)cache:(ULLRUCache *)cache didDropObject:(id)object forKey:(id)key {
    NSLog(@"%s", __func__);
}
// 更新一个元素：`由-setObject:forKey:`  触发
- (void)cache:(ULLRUCache *)cache didUpdateObject:(id)object forKey:(id)key {
    NSLog(@"%s", __func__);
}




@end
