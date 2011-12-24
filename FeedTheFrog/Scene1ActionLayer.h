#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "Constants.h"
#import "BaseFly.h"


@class Scene1UILayer;
@class Frog;
@class BaseFly;

@interface Scene1ActionLayer : CCLayer {
    b2World* world;
    GLESDebugDraw* debugDraw;
    
    CCSpriteBatchNode* sceneSpriteBatchNode;
    b2Body * groundBody;
    b2MouseJoint * mouseJoint;
    
    Frog* frog;
    //Temp add
    BaseFly* fly;
    
    Scene1UILayer * uiLayer;
}

-(id)initWithScene1UILayer:(Scene1UILayer *)scene1UILayer;

@end
