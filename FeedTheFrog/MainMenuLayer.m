//
//  MainMenuLayer.m
//  FeedTheFrog
//

#import "MainMenuLayer.h"
#import "GameManager.h"

@implementation MainMenuLayer

-(void)showOptions {
    CCLOG(@"Show the Options Screen");
    [[GameManager sharedGameManager] runSceneWithID:kOptionsScene];
}

-(void)startGame {
}

-(void)displayMainMenu {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    //Main Menu
    CCMenuItemImage *playGameButton = [CCMenuItemImage
                                       itemFromNormalImage:@"PlayGameButtonNormal.png" 
                                       selectedImage:@"PlayGameButtonSelected.png"
                                       disabledImage:nil 
                                       target:self 
                                       selector:@selector(startGame)];
    
    CCMenuItemImage *optionsButton = [CCMenuItemImage
                                      itemFromNormalImage:@"OptionsButtonNormal.png" 
                                      selectedImage:@"OptionsButtonSelected.png"
                                      disabledImage:nil
                                      target:self selector:@selector(showOptions)];
    
    mainMenu = [CCMenu menuWithItems:playGameButton, optionsButton, nil];
    [mainMenu alignItemsVerticallyWithPadding:screenSize.height * 0.06f];
    [mainMenu setPosition:ccp(screenSize.width * 2.0f, screenSize.height / 2.0f)];
    id moveAction = [CCMoveTo actionWithDuration:1.2f 
                                        position:ccp(screenSize.width * 0.85f, screenSize.height/2.0f)];
    id moveEffect = [CCEaseIn actionWithAction:moveAction rate:1.0f];
    
    id sequenceAction = [CCSequence actions:moveEffect, nil];
    [mainMenu runAction:sequenceAction];
    [self addChild:mainMenu z:0 tag:kMainMenuTagValue];
}

-(id)init {
    if ((self = [super init])) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background = [CCSprite spriteWithFile:@"MainMenuBackground.png"];
        [background setPosition:ccp(screenSize.width/2, screenSize.height/2)];
        [self addChild:background];
        [self displayMainMenu];
    }
    return self;
}

@end
