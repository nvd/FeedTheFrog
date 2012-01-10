//
//  Bee.m
//  FeedTheFrog
//

#import "Bee.h"
#import <math.h>
#import "Constants.h"

@implementation Bee

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
- (void)changeState:(CharacterStates)newState {
    if (characterState == newState) return;
    
    [self stopAllActions];
    id action = nil;
    [self setCharacterState:newState];
        
    switch (newState) {
        case kStateFlying:
            CCLOG(@"Bee->Starting the Flying Animation");
            action = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:wingBeatAnim 
                                 restoreOriginalFrame:NO]];
            break;
        default:
            CCLOG(@"Unhandled state %d in Bee", newState);
            break;
    }
    if (action != nil) {
        [self runAction:action];
    }
}

- (void)updateStateWithDeltaTime:(ccTime)deltaTime 
            andListOfGameObjects:(CCArray *)listOfGameObjects {
    static float angle = 0;
    angle += deltaTime;
    angle = fmod(angle, 360.0f);
    
    /*ccBezierConfig bezier;
    bezier.controlPoint_1 = ccp(0, screenSize.height/2);
    bezier.controlPoint_2 = ccp(300, - screenSize.height/2);
    bezier.endPosition = ccp(300,100);
    id bezierForward = [CCBezierBy actionWithDuration:3 bezier:bezier];*/

    /*[self changeState:kStateFlying];
    
    float halfScreenWidth = screenSize.width/2;
    float qtrScreenHeight = screenSize.height/4;
    float randomFactor = 0.5;
    
    float x = halfScreenWidth + (cos(2*angle) * halfScreenWidth * randomFactor);
    float y = qtrScreenHeight + sin(angle) * qtrScreenHeight * randomFactor;
    
    self.body->SetTransform(b2Vec2(x/PTM_RATIO,y/PTM_RATIO), body->GetAngle());*/
        
    //self.body->SetAngularVelocity(3.0);
    //self.body->SetLinearVelocity(b2Vec2(x,y));
    //self.body->ApplyLinearImpulse(b2Vec2(x, y), body->GetPosition());
    
    /*body->SetAngularVelocity(0);
    float angimp = self.body->GetInertia() * self.body->GetAngle();
    self.body->ApplyAngularImpulse(angimp * 2);*/
    
    static int i = 0;
    b2Vec2 position = body->GetPosition();
    float y = screenSize.height/2;
    //if (i > 1) {
        CCLOG(@"Up Pos => %f", position.x);
        if (position.x <= screenSize.width/4/PTM_RATIO) {
            mouseJoint->SetTarget(b2Vec2(screenSize.width*3/4/PTM_RATIO, y/PTM_RATIO));
            i=0;
        } else if (position.x >= screenSize.width*3/4/PTM_RATIO){
            mouseJoint->SetTarget(b2Vec2(screenSize.width/4/PTM_RATIO, y/PTM_RATIO));
            i=0;
        }
    //}
    i++;
}

#pragma mark -
- (void)initAnimations {
    [super initAnimations];
}

- (id)initWithWorld:(b2World *)theWorld withGround:(b2Body*)groundBody atLocation:(CGPoint)location
{
    if ((self = [super init])) {
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                spriteFrameByName:@"ftf_Bee_1.png"]];
        gameObjectType = kBee;
        [self createBodyWithWorld:theWorld withGround:groundBody atLocation:location];
        [self initAnimations];
        [self changeState:kStateFlying];
    }
    return self;
}

-(BOOL)isHarmful {
    return YES;
}

@end
