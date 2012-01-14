//
//  GameCharacter.h
//  FeedTheFrog
//

#import "GameObject.h"

@interface GameCharacter : GameObject {
    BOOL isAlive;
    CharacterStates characterState;
}
@property (readwrite) BOOL isAlive;
@property (readwrite) CharacterStates characterState;

-(void)checkAndClampSpritePosition;

@end
