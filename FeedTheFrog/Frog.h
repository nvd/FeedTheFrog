//
//  Frog.h
//  FeedTheFrog
//

#import "Box2DSprite.h"

@interface Frog : Box2DSprite {
    b2World *world;
    
    Box2DSprite *footL;
    Box2DSprite *footR;
    b2Body * footLBody;
    b2Body * footRBody;
        
    Box2DSprite * tongueBase;
    Box2DSprite * tongueMid;
    Box2DSprite * tongueTip;
    b2Body * tongueBaseBody;
    b2Body * tongueMidBody;
    b2Body * tongueTipBody;
}
@property (readonly) Box2DSprite * footL;
@property (readonly) Box2DSprite * footR;
@property (readonly) Box2DSprite * tongueBase;
@property (readonly) Box2DSprite * tongueMid;
@property (readonly) Box2DSprite * tongueTip;

-(id)initWithWorld:(b2World*)world atLocation:(CGPoint)location;

@end
