//
//  FoodFly.m
//  FeedTheFrog
//

#import "FoodFly.h"
#import "Constants.h"

@implementation FoodFly

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
            CCLOG(@"FoodFly->Starting the Flying Animation");
            action = [CCRepeatForever actionWithAction:
                      [CCAnimate actionWithAnimation:wingBeatAnim 
                               restoreOriginalFrame:NO]];
            break;
        default:
            CCLOG(@"Unhandled state %d in FoodFly", newState);
            break;
    }
    if (action != nil) {
        [self runAction:action];
    }
}

- (void)updateStateWithDeltaTime:(ccTime)deltaTime 
            andListOfGameObjects:(CCArray *)listOfGameObjects {
    [self changeState:kStateFlying];
}

#pragma mark -
- (void)initAnimations {
    [super initAnimations];
}

- (id)initWithWorld:(b2World *)theWorld withGround:(b2Body*)groundBody atLocation:(CGPoint)location
{
    if ((self = [super init])) {
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] 
                                spriteFrameByName:@"ftf_FoodFly_1.png"]];
        gameObjectType = kFoodFly;
        [self createBodyWithWorld:theWorld withGround:groundBody atLocation:location];
        [self initAnimations];
        [self changeState:kStateFlying];
    }
    return self;
}

-(int)getPointWorth {
    return FOOD_FLY_POINT_WORTH;
}

@end
