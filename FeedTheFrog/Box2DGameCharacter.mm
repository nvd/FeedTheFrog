//
//  Box2DGameCharacter.m
//  FeedTheFrog
//

#import "Box2DGameCharacter.h"

@implementation Box2DGameCharacter
@synthesize body;

// Override if necessary
-(BOOL)mouseJointBegan {
    return TRUE;
}

@end
