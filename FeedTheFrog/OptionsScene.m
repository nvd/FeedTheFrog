//
//  OptionsScene.m
//  FeedTheFrog
//

#import "OptionsScene.h"
#import "OptionsLayer.h"

@implementation OptionsScene

- (id)init
{
    if ((self = [super init])) {
        [self addChild:[OptionsLayer node]];
    }
    return self;
}

@end
