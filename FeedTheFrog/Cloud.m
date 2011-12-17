//
//  Cloud.m
//  FeedTheFrog
//

#import "Cloud.h"
#import "Constants.h"

@implementation Cloud

- (void)setUpMotionWithLocation:(CGPoint) newPosition {
    [self setPosition:newPosition];
    
    int moveDuration = random() % kMaxCloudMoveDuration;
    if (moveDuration < kMinCloudMoveDuration) {
        moveDuration = kMinCloudMoveDuration;
    }
    
    float xOffset = [self boundingBox].size.width / 2;
    float offScreenXPosition = (xOffset * -1) - 1;
    
    id moveAction = [CCMoveTo actionWithDuration:moveDuration 
                                        position:ccp(offScreenXPosition, [self position].y)];
    id resetAction = [CCCallFuncN actionWithTarget:self 
                                          selector:@selector(resetCloud)];
    id sequenceAction = [CCSequence actions:moveAction, resetAction, nil];
    [self runAction:sequenceAction];
    
    int newZOrder = kMaxCloudMoveDuration - moveDuration;
    [parent_ reorderChild:self z:newZOrder];

}

- (void)resetCloud {
    screenSize = [CCDirector sharedDirector].winSize;
    
    float xOffset = [self boundingBox].size.width / 2;
    int xPosition = screenSize.width + 1 + xOffset;
    int yPosition = (random() % (int)screenSize.height/3) + (int)screenSize.height*2/3;

    [self setUpMotionWithLocation:ccp( xPosition, yPosition)];
}

- (void)setupCloudWithInitPosition {
    screenSize = [CCDirector sharedDirector].winSize;
    
    float xOffset = [self boundingBox].size.width / 2;
    int xPosition = (random() % (int)screenSize.width + 1 + xOffset);
    int yPosition = (random() % (int)screenSize.height/3) + (int)screenSize.height*2/3;
    
    [self setUpMotionWithLocation:ccp( xPosition, yPosition)];    
}

- (id)init
{
    if ((self = [super init])) {
        int cloudToDraw = random() % NUM_CLOUDS;
        NSString * cloudFileName = [NSString stringWithFormat:@"Cloud_%d.png",cloudToDraw];
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                               spriteFrameByName:cloudFileName]];
        [self setFlipX:random()%2];
        
        gameObjectType = kCloud;
        [self setupCloudWithInitPosition];
    }
    
    return self;
}
@end
