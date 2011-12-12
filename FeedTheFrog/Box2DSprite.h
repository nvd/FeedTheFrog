//
//  Box2DSprite.h
//  FeedTheFrog
//

#import "GameCharacter.h"
#import "Box2D.h"

@interface Box2DSprite : GameCharacter {
    b2Body *body;
}
@property (assign) b2Body *body;

// Return TRUE to accept the mouse joint
// Return FALSE to reject the mouse joint
-(BOOL)mouseJointBegan;

@end
