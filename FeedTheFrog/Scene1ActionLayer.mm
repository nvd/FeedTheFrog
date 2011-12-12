//
//  Scene1ActionLayer.m
//  FeedTheFrog
//

#import "Scene1ActionLayer.h"
#import "Box2DSprite.h"
#import "SimpleQueryCallback.h"
#import "GameManager.h"
#import "Frog.h"

@implementation Scene1ActionLayer

-(void)setupWorld {
    b2Vec2 gravity = b2Vec2(0.0f,-10.0f);
    bool doSleep = true;
    world = new b2World(gravity, doSleep);
}

-(void)createFrogAtLocation:(CGPoint)location {
    frog = [[[Frog alloc] initWithWorld:world atLocation:location] autorelease];
    CCLOGINFO(@"%d",frog.texture.name);
    [sceneSpriteBatchNode addChild:frog z:1 tag:kFrogSpriteTagValue];
    //[sceneSpriteBatchNode addChild:frog.torso];
    [sceneSpriteBatchNode addChild:frog.footL];
    [sceneSpriteBatchNode addChild:frog.footR];
}

-(void)createGround {
/*    b2BodyDef groundBodyDef;
    groundBodyDef.type = b2_staticBody;
    groundBodyDef.position.Set(0, 0);
    groundBody = world->CreateBody(&groundBodyDef);*/
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    float32 margin = 10.0f;
    b2Vec2 lowerLeft = b2Vec2(margin/PTM_RATIO, margin/PTM_RATIO);
    b2Vec2 lowerRight = b2Vec2((winSize.width-margin)/PTM_RATIO,
                               margin/PTM_RATIO);

    b2BodyDef groundBodyDef;
    groundBodyDef.type = b2_staticBody;
    groundBodyDef.position.Set(0, 0);
    groundBody = world->CreateBody(&groundBodyDef);
 
    b2PolygonShape groundShape;
    b2FixtureDef groundFixtureDef;
    groundFixtureDef.shape = &groundShape;
    groundFixtureDef.density = 0.0;

    groundShape.SetAsEdge(lowerLeft, lowerRight);
    groundBody->CreateFixture(&groundFixtureDef);
}

// Remains more or less the same
-(void)createBackground {
    CCParallaxNode * parallex = [CCParallaxNode node];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    
    CCSprite * background;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        background = [CCSprite spriteWithFile:@"bg1-ipad.png"];
    }
    else {
        background = [CCSprite spriteWithFile:@"bg1.png"];
    }
    
    background.anchorPoint = ccp(0, 0);
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
    
    [parallex addChild:background z:-10 parallaxRatio:ccp(0.05f, 0.05f) 
        positionOffset:ccp(0, 0)];
    [self addChild:parallex z:-10];
}

-(void)createLevel {
    [self createBackground];
}

- (void)createBoxAtLocation:(CGPoint)location withSize:(CGSize)size {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    bodyDef.allowSleep = false;
    b2Body *body = world->CreateBody(&bodyDef);
    
    b2PolygonShape shape;
    shape.SetAsBox(size.width/2/PTM_RATIO, size.height/2/PTM_RATIO);
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    fixtureDef.density = 1.0;
    body->CreateFixture(&fixtureDef);
}

#pragma mark -
#pragma Debug draw

-(void) draw {
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    if (world) {
        world->DrawDebugData();
    }
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

-(void)setupDebugDraw {
    debugDraw = new GLESDebugDraw(PTM_RATIO * 
                                  [[CCDirector sharedDirector] contentScaleFactor]);
    world->SetDebugDraw(debugDraw);
    debugDraw->SetFlags(b2DebugDraw::e_shapeBit);
}

#pragma mark -
-(id)initWithScene1UILayer:(Scene1UILayer *)scene1UILayer
{
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        uiLayer = scene1UILayer;
        
        [self setupWorld];
        [self setupDebugDraw];
        [self scheduleUpdate];
        [self createGround];
        
        self.isTouchEnabled = YES;
        
        //Create level background
        //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile:@"gameAtlas-hd.plist"];
            sceneSpriteBatchNode = [CCSpriteBatchNode 
                                    batchNodeWithFile:@"gameAtlas-hd.png"];
            [self addChild:sceneSpriteBatchNode z:-1];
        /*}
        else {
            [[CCSpriteFrameCache sharedSpriteFrameCache]
             addSpriteFramesWithFile:@"gameAtlas.plist"];
            sceneSpriteBatchNode = [CCSpriteBatchNode
                                    batchNodeWithFile:@"gameAtlas.png"];
            [self addChild:sceneSpriteBatchNode z:-1];
        }*/
        
        [self createFrogAtLocation:ccp(winSize.width/2, winSize.width*0.3)];
        [self createLevel];
    }
    
    return self;
}

#pragma mark -
#pragma Event Handlers
-(void)update:(ccTime)dt {
    static double UPDATE_INTERVAL = 1.0f/60.0f;
    static double MAX_CYCLES_PER_FRAME = 5;
    static double timeAccumulator = 0;
    
    timeAccumulator += dt;
    if (timeAccumulator > (MAX_CYCLES_PER_FRAME * UPDATE_INTERVAL)) {
        timeAccumulator = UPDATE_INTERVAL;
    }
    
    int32 velocityInteractions = 3;
    int32 positionInteractions = 2;
    while (timeAccumulator >= UPDATE_INTERVAL) {
        timeAccumulator -= UPDATE_INTERVAL;
        world->Step(UPDATE_INTERVAL, velocityInteractions, positionInteractions);
    }
    
    for (b2Body *b=world->GetBodyList(); b!=NULL; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            Box2DSprite *character = (Box2DSprite*) b->GetUserData();
            character.position = ccp(b->GetPosition().x * PTM_RATIO,
                                     b->GetPosition().y * PTM_RATIO);
            character.rotation = CC_RADIANS_TO_DEGREES(b->GetAngle() * -1);
        }
    }
    
    CCArray *listOfGameCharacters = [sceneSpriteBatchNode children];
    for (GameCharacter *tempChar in listOfGameCharacters) {
        [tempChar updateStateWithDeltaTime:dt 
                      andListOfGameObjects:listOfGameCharacters];
    }
}

-(void)gameOver:(id)sender {
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

//Remains more or less the same
-(void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher]
     addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector]
                     convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    b2Vec2 locationWorld = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
    
    b2AABB aabb;
    b2Vec2 delta = b2Vec2(1.0/PTM_RATIO, 1.0/PTM_RATIO);
    aabb.lowerBound = locationWorld - delta;
    aabb.upperBound = locationWorld + delta;
    SimpleQueryCallback callback(locationWorld);
    world->QueryAABB(&callback, aabb);
    
    if (callback.fixtureFound) {
        b2Body *body = callback.fixtureFound->GetBody();
        
        Box2DSprite *sprite = (Box2DSprite *) body->GetUserData();
        if (sprite == NULL) return FALSE;
        if(![sprite mouseJointBegan]) return FALSE;
        
        b2MouseJointDef mouseJointDef;
        mouseJointDef.bodyA = groundBody;
        mouseJointDef.bodyB = body;
        mouseJointDef.target = locationWorld;
        mouseJointDef.maxForce = 50 * body->GetMass();
        mouseJointDef.collideConnected = true;
        mouseJoint = (b2MouseJoint *)
        world->CreateJoint(&mouseJointDef);
        body->SetAwake(true);
        return YES; 
    }
    else {
        [self createBoxAtLocation:touchLocation
                         withSize:CGSizeMake(50, 50)];
    }
    
    return TRUE;
}

//following to be del after debug
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector]
                     convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    b2Vec2 locationWorld = b2Vec2(touchLocation.x/PTM_RATIO,
                                  touchLocation.y/PTM_RATIO);
    if (mouseJoint) {
        mouseJoint->SetTarget(locationWorld);
    } 
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (mouseJoint) {
        world->DestroyJoint(mouseJoint);
        mouseJoint = NULL;
    }
}

@end
