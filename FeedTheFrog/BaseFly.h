//
//  BaseFly.h
//  FeedTheFrog
//

#import "Box2DSprite.h"

@interface BaseFly : Box2DSprite {
    b2MouseJoint * mouseJoint;
    
    // Wing beat
    CCAnimation * wingBeatAnim;
}
@property (nonatomic, retain) CCAnimation * wingBeatAnim;

-(void)createBodyWithWorld:(b2World*)world withGround:(b2Body*)groundBody atLocation:(CGPoint)location;
-(void)initAnimations;
-(BOOL)isHarmful;
-(int)getPointWorth;

@end
