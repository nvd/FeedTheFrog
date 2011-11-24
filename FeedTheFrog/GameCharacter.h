//
//  GameCharacter.h
//  FeedTheFrog
//

#import "GameObject.h"

@interface GameCharacter : GameObject {
    CharacterStates characterState;
}
@property (readwrite) CharacterStates characterState;

-(void)checkAndClampSpritePosition;

@end
