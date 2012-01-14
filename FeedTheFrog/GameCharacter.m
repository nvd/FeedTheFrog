//
//  GameCharacter.m
//  FeedTheFrog
//

#import "GameCharacter.h"

@implementation GameCharacter
@synthesize isAlive;
@synthesize characterState;

-(void) dealloc {
    [super dealloc];
}

- (id)init {
    if ((self = [super init])) {
        CCLOG(@"GameCharacter init");
        isAlive = TRUE;
        characterState = kStateIdle;
    }
    
    return self;
}

-(void)checkAndClampSpritePosition {
    CGPoint currentSpritePosition = [self position];
    CGSize levelSize = [[CCDirector sharedDirector] winSize];
    
    float xOffset = 24.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        xOffset = 30.0f;
    }
    
    if (currentSpritePosition.x < xOffset) {
        [self setPosition:ccp(xOffset, currentSpritePosition.y)];
    } else if (currentSpritePosition.x > (levelSize.width - xOffset)) {
        [self setPosition:ccp((levelSize.width - xOffset),
                              currentSpritePosition.y)];
    } 
}

@end
