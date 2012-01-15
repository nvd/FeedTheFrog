//
//  Frog.h
//  FeedTheFrog
//

#import "Box2DSprite.h"

@interface Frog : Box2DSprite {
    b2World *world;
    
    Box2DSprite * footL;
    Box2DSprite * footR;
    b2Body * footLBody;
    b2Body * footRBody;
        
    Box2DSprite * tongueBase;
    Box2DSprite * tongueMid;
    Box2DSprite * tongueTip;
    b2Body * tongueBaseBody;
    b2Body * tongueMidBody;
    b2Body * tongueTipBody;
    
    // Open mouth (flick)
    CCAnimation * flickAnim;
    // Idle (bubble)
    CCAnimation * bublbleAnim;
    // Die (sting)
    CCAnimation * stingAnim;
    
    float millisecondsStayingIdle;
}

@property (readonly) Box2DSprite * footL;
@property (readonly) Box2DSprite * footR;
@property (readonly) Box2DSprite * tongueBase;
@property (readonly) Box2DSprite * tongueMid;
@property (readonly) Box2DSprite * tongueTip;
@property (nonatomic, retain) CCAnimation * flickAnim;
@property (nonatomic, retain) CCAnimation * bubbleAnim;
@property (nonatomic, retain) CCAnimation * stingAnim;

-(id)initWithWorld:(b2World*)world atLocation:(CGPoint)location;

@end
