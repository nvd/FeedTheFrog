//
//  MainMenuScene.m
//  FeedTheFrog
//

#import "MainMenuScene.h"

@implementation MainMenuScene

- (id)init
{
    if ((self = [super init])) {
        mainMenuLayer = [MainMenuLayer node];
        [self addChild:mainMenuLayer];
    }
    return self;
}

@end
