//
//  ULLRUNode.h
//  UnitTestObjc
//
//  Created by 郭朝顺 on 2022/3/17.
//

#import <Foundation/Foundation.h>

@interface ULLRUNode < Key : id<NSCopying>, Value : id<NSObject> > : NSObject

// prev用assign, weak都行,个人喜欢weak
// 追求极致性能就使用assign或者__unsafe_unretained
@property (nonatomic, weak) ULLRUNode *prev;
@property (nonatomic, strong) ULLRUNode *next;

@property (nonatomic, copy) Key key;
@property (nonatomic, strong) Value value;

- (instancetype)initWithKey:(Key)key value:(Value)value;

@end
