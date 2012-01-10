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
- (void)createBodyWithWorld:(b2World*)world withGround:(b2Body*)groundBody atLocation:(CGPoint)location {
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
    
    //Create mouse joint
    b2MouseJointDef mouseJointDef;
    mouseJointDef.bodyA = groundBody;
    mouseJointDef.bodyB = body;
    mouseJointDef.target = bodyDef.position;
    mouseJointDef.maxForce = 100 * body->GetMass();
    mouseJointDef.collideConnected = true;
    mouseJoint = (b2MouseJoint *) world->CreateJoint(&mouseJointDef);
    body->SetAwake(true);
}

- (void)initAnimations {
    wingBeatAnim = [self loadPlistForAnimationWithName:@"wingBeatAnim" 
                                          andClassName:NSStringFromClass([self class])];
    [[CCAnimationCache sharedAnimationCache] addAnimation:wingBeatAnim
                                                     name:[NSString stringWithFormat:@"wingBeatAnim_%@",
                                                           NSStringFromClass([self class])]];
}

-(BOOL)isHarmful {
    return NO;
}

-(int)getPointWorth {
    return 0;
}

@end
