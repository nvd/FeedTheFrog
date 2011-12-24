//
//  BaseFly.h
//  FeedTheFrog
//

#import "Box2DSprite.h"

@interface BaseFly : Box2DSprite {
    // Wing beat
    CCAnimation * wingBeatAnim;
}
@property (nonatomic, retain) CCAnimation * wingBeatAnim;

-(void)createBodyWithWorld:(b2World*)world AtLocation:(CGPoint)location;
-(void)initAnimations;
-(BOOL)isHarmful;
-(int)getPointWorth;

@end
