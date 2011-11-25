//
//  Scene1.m
//  FeedTheFrog
//

#import "Scene1.h"
#import "Scene1UILayer.h"
#import "Scene1ActionLayer.h"

@implementation Scene1

- (id)init
{
    if ((self = [super init])) {
        Scene1UILayer * uiLayer = [Scene1UILayer node];
        [self addChild:uiLayer z:1];
        
        Scene1ActionLayer * actionLayer = [[[Scene1ActionLayer alloc] 
                                            initWithScene1UILayer:uiLayer] autorelease];
        [self addChild:actionLayer z:0];
    }
    
    return self;
}

@end
