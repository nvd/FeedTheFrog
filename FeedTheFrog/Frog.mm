//
//  Frog.mm
//  FeedTheFrog
//

#import "Frog.h"
#import "Constants.h"

@interface Frog (PrivateMethods) 
- (b2Body *)createPartAtLocation: withSprite: withDensity;
- (void)createFeet;
- (void)createFeetJoints;
@end

@implementation Frog

@synthesize footL;
@synthesize footR;
@synthesize tongueBase;
@synthesize tongueMid;
@synthesize tongueTip;
@synthesize flickAnim;
@synthesize bubbleAnim;
@synthesize stingAnim;

- (void) dealloc {
    [flickAnim release];
    [bubbleAnim release];
    [stingAnim release];
    [super dealloc];
}

- (void)createBodyAtLocation:(CGPoint)location {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    body = world->CreateBody(&bodyDef);
    body->SetUserData(self);
    
    //TODO: need to change this to match sprite shape
    b2PolygonShape shape;
    /*int num = 4;
    b2Vec2 verts[] = {
        b2Vec2(11.0f / HD_PTM_RATIO, 73.0f / HD_PTM_RATIO),
        b2Vec2(-46.0f / HD_PTM_RATIO, 73.0f / HD_PTM_RATIO),
        b2Vec2(-66.0f / HD_PTM_RATIO, -76.0f / HD_PTM_RATIO),
        b2Vec2(69.0f / HD_PTM_RATIO, -74.0f / HD_PTM_RATIO)
    };*/
    
    /*int num = 6;
    b2Vec2 verts[] = {
        b2Vec2(-12.0f / HD_PTM_RATIO, 75.0f / HD_PTM_RATIO),
        b2Vec2(-29.0f / HD_PTM_RATIO, 74.0f / HD_PTM_RATIO),
        b2Vec2(-69.0f / HD_PTM_RATIO, -47.0f / HD_PTM_RATIO),
        b2Vec2(-29.0f / HD_PTM_RATIO, -76.0f / HD_PTM_RATIO),
        b2Vec2(35.0f / HD_PTM_RATIO, -75.0f / HD_PTM_RATIO),
        b2Vec2(69.0f / HD_PTM_RATIO, -29.0f / HD_PTM_RATIO)
    };*/
    //shape.Set(verts, num);

    shape.SetAsBox(self.contentSize.width/2/PTM_RATIO, 
                   self.contentSize.height/2/PTM_RATIO);

    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    fixtureDef.density = 1.0;
    fixtureDef.restitution = 0.5;
    
    body->CreateFixture(&fixtureDef);
}


- (void)createFrog {    
    [self createFeet];
    [self createFeetJoints];
}

#pragma mark -
-(void)changeState:(CharacterStates)newState {
    [self stopAllActions];
    id action = nil;
    [self setCharacterState:newState];
    
    switch (newState) {
        case kStateIdle:
            [self setDisplayFrame:[[CCSpriteFrameCache 
                                    sharedSpriteFrameCache]
                                   spriteFrameByName:@"Torso.png"]];
            break;
        case kStateFlicking:
            action = [CCAnimate actionWithAnimation:flickAnim 
                               restoreOriginalFrame:NO];
            break;
        case kStateBlowingBubble:
            action = [CCAnimate actionWithAnimation:bubbleAnim 
                               restoreOriginalFrame:NO];
            break;
        case kStateDead:
            action = [CCAnimate actionWithAnimation:stingAnim 
                               restoreOriginalFrame:NO];
            break;
        default:
            break;
    }
    if (action != nil) {
        [self runAction:action];
    }
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime 
           andListOfGameObjects:(CCArray *)listOfGameObjects {
    // Return if dead
    if (self.characterState == kStateDead) return;
    
    // TODO: Check for collisions with tongue
    
    if([self numberOfRunningActions] == 0) {
        // Not playing an animation
        if (!self.isAlive) {
            [self changeState:kStateDead];
        } else if (self.characterState == kStateIdle) {
            millisecondsStayingIdle = millisecondsStayingIdle + deltaTime;
            if (millisecondsStayingIdle > kFrogIdleTimer) {
                [self changeState:kStateBlowingBubble];
            }
        } else {
            millisecondsStayingIdle = 0.0f;
            [self changeState:kStateIdle];
        }
    }
}

#pragma mark -
-(void)initAnimations {
    [self setFlickAnim:[self loadPlistForAnimationWithName:@"flickAnim" andClassName:NSStringFromClass([self class])]];
    [self setBubbleAnim:[self loadPlistForAnimationWithName:@"bubbleAnim" andClassName:NSStringFromClass([self class])]];
    [self setStingAnim:[self loadPlistForAnimationWithName:@"stingAnim" andClassName:NSStringFromClass([self class])]];
}

- (id)initWithWorld:(b2World *)theWorld atLocation:(CGPoint)location
{
    if ((self = [super init])) {
        world = theWorld;
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                               spriteFrameByName:@"Torso.png"]];
        gameObjectType = kFrog;
        millisecondsStayingIdle = 0.0f;
        [self initAnimations];
        [self createBodyAtLocation:location];
        [self createFrog];
    }
    
    return self;
}

/*- (BOOL)mouseJointBegan {
    return FALSE;
}*/

#pragma mark -
#pragma mark Frog model create methods
- (b2Body *)createPartAtLocation:(b2Vec2)location 
                      withSprite:(Box2DSprite *)sprite
                    withDensity:(float)density{
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = location;
    bodyDef.angle = body->GetAngle();
    
    b2Body *partBody = world->CreateBody(&bodyDef);
    partBody->SetUserData(sprite);
    sprite.body = partBody;
    
    b2PolygonShape shape;
    shape.SetAsBox(sprite.contentSize.width/2/PTM_RATIO,
                   sprite.contentSize.height/2/PTM_RATIO);
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    fixtureDef.density = density;
    fixtureDef.filter.categoryBits = 0x2;
    fixtureDef.filter.maskBits = 0xFFFF;
    fixtureDef.filter.groupIndex = -1;
    
    partBody->CreateFixture(&fixtureDef);
    return partBody;
}

- (void)createFeet {
    footL = [Box2DSprite spriteWithSpriteFrameName:@"Foot.png"];
    footL.gameObjectType = kFrog;
    footLBody = [self createPartAtLocation:
                 body->GetWorldPoint(b2Vec2(-78.0/PTM_RATIO, -90.0/PTM_RATIO))
                                withSprite:footL
                               withDensity:10.0];
    
    footR = [Box2DSprite spriteWithSpriteFrameName:@"Foot.png"];
    footR.flipX = true;
    footR.gameObjectType = kFrog;
    footRBody = [self createPartAtLocation:
                 body->GetWorldPoint(b2Vec2(78.0/PTM_RATIO, -90.0/PTM_RATIO))
                                withSprite:footR
                               withDensity:10.0];
}

- (void)createFeetJoints {
    // FOOT JOINTS
    //NOTE: Prismatic joints specify axis and end-limits for feet
    //      Distance joints specify bouncy motion and normal distance of feet
    
    //Creating the joints
    b2Transform axisTransform;
    axisTransform.Set(b2Vec2(0, 0), body->GetAngle());
    b2Vec2 axis = b2Mul(axisTransform.R, b2Vec2(0,1));
    
    // Body - Left Foot Joint
    b2PrismaticJointDef prisJointDef;
    prisJointDef.Initialize(body, footLBody,
                            footLBody->GetWorldCenter(), axis);
    prisJointDef.enableLimit = true;
    prisJointDef.lowerTranslation = 0.0;
    prisJointDef.upperTranslation = 43.0/PTM_RATIO;
    world->CreateJoint(&prisJointDef);
    
    // Body - Right Foot Joint
    prisJointDef.Initialize(body, footRBody,
                            footRBody->GetWorldCenter(), axis);
    prisJointDef.enableLimit = true;
    prisJointDef.lowerTranslation = 0.0;
    prisJointDef.upperTranslation = 43.0/PTM_RATIO;
    world->CreateJoint(&prisJointDef);
    
    //Body - Left Foot Soft Distance Joint
    b2DistanceJointDef distanceJointDef;
    distanceJointDef.Initialize(body, footLBody, body->GetWorldCenter(), footLBody->GetWorldCenter());
    distanceJointDef.collideConnected = true;
    distanceJointDef.dampingRatio = 0.5;
    distanceJointDef.frequencyHz = 1.5;
    distanceJointDef.length = 125.0/PTM_RATIO;
    world->CreateJoint(&distanceJointDef);
    
    //Body - Left Foot Soft Distance Joint
    distanceJointDef.Initialize(body, footRBody, body->GetWorldCenter(), footRBody->GetWorldCenter());
    distanceJointDef.collideConnected = true;
    distanceJointDef.dampingRatio = 0.5;
    distanceJointDef.frequencyHz = 1.5;
    distanceJointDef.length = 125.0/PTM_RATIO;
    world->CreateJoint(&distanceJointDef);
}

@end
