//
//  BaseFly.m
//  FeedTheFrog
//

#import "BaseFly.h"
#import "Constants.h"

@implementation BaseFly
@synthesize wingBeatAnim;

- (void) dealloc {
    [wingBeatAnim release];
    [super dealloc];
}

#pragma mark -
- (void)createBodyWithWorld:(b2World*)world AtLocation:(CGPoint)location {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    b2Body *flyBody = world->CreateBody(&bodyDef);
    flyBody->SetUserData(self);
    self.body = flyBody;
    
    b2PolygonShape shape;
    shape.SetAsBox(self.contentSize.width/2/PTM_RATIO, 
                   self.contentSize.height/2/PTM_RATIO);
    
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    fixtureDef.density = 1.0;
    fixtureDef.restitution = 0.5;
    
    body->CreateFixture(&fixtureDef);
}

- (void)initAnimations {
    wingBeatAnim = [self loadPlistForAnimationWithName:@"wingBeatAnim" 
                                          andClassName:NSStringFromClass([self class])];
    [[CCAnimationCache sharedAnimationCache] addAnimation:wingBeatAnim
                                                     name:@"wingBeatAnim"];
}

-(BOOL)isHarmful {
    return NO;
}

-(int)getPointWorth {
    return 0;
}

@end
