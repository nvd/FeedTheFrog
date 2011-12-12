//
//  Box2DSprite.m
//  FeedTheFrog
//

#import "Box2DSprite.h"

@implementation Box2DSprite
@synthesize body;

// Override if necessary
-(BOOL)mouseJointBegan {
    return TRUE;
}

@end
