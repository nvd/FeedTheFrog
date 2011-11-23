//
//  OptionsLayer.m
//  FeedTheFrog
//
//  Created by Muhammad Naveed Siddiqui on 23/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OptionsLayer.h"
#import "GameManager.h"
#import "AudioManager.h"

@implementation OptionsLayer

-(void)returnToMainMenu {
    [[GameManager sharedGameManager] runSceneWithID:kMainMenuScene];
}

-(void)musicTogglePressed {
    [[AudioManager sharedAudioManager] setIsMusicON:
        ![[AudioManager sharedAudioManager] isMusicON]];
}

-(void)SFXTogglePressed {
    [[AudioManager sharedAudioManager] setIsSoundEffectsON:
        ![[AudioManager sharedAudioManager] isSoundEffectsON]];
}

- (id)init
{
    if ((self = [super init])) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background = [CCSprite spriteWithFile:@"MainMenuBackground.png"];
        [background setPosition:ccp(screenSize.width/2, screenSize.height/2)];
        [self addChild:background];
        
        CCLabelBMFont *musicOnLabelText = [CCLabelBMFont labelWithString:@"Music On" fntFile:@"FeedTheFrogFont.fnt"];
        CCLabelBMFont *musicOffLabelText = [CCLabelBMFont labelWithString:@"Music Off" fntFile:@"FeedTheFrogFont.fnt"];
        CCLabelBMFont *SFXOnLabelText = [CCLabelBMFont labelWithString:@"Sound Effects On" fntFile:@"FeedTheFrogFont.fnt"];
        CCLabelBMFont *SFXOffLabelText = [CCLabelBMFont labelWithString:@"Sound Effects Off" fntFile:@"FeedTheFrogFont.fnt"];
        
        CCMenuItemLabel *musicOnLabel = [CCMenuItemLabel itemWithLabel:musicOnLabelText target:self selector:nil];
        CCMenuItemLabel *musicOffLabel = [CCMenuItemLabel itemWithLabel:musicOffLabelText target:self selector:nil];
        CCMenuItemLabel *SFXOnLabel = [CCMenuItemLabel itemWithLabel:SFXOnLabelText target:self selector:nil];
        CCMenuItemLabel *SFXOffLabel = [CCMenuItemLabel itemWithLabel:SFXOffLabelText target:self selector:nil];
        
        CCMenuItemToggle *musicToggle = [CCMenuItemToggle itemWithTarget:self 
                                                                selector:@selector(musicTogglePressed) 
                                                                   items:musicOnLabel, musicOffLabel, nil];
        CCMenuItemToggle *SFXToggle = [CCMenuItemToggle itemWithTarget:self 
                                                              selector:@selector(SFXTogglePressed) 
                                                                 items:SFXOnLabel, SFXOffLabel, nil];
        
        CCLabelBMFont *backButtonLabelText = [CCLabelBMFont labelWithString:@"Back" fntFile:@"FeedTheFrogFont.fnt"];
        CCMenuItemLabel *backButtonLabel = [CCMenuItemLabel itemWithLabel:backButtonLabelText 
                                                                   target:self 
                                                                 selector:@selector(returnToMainMenu)];
        
        CCMenu *optionsMenu = [CCMenu menuWithItems:musicToggle, SFXToggle, backButtonLabel, nil];
        [optionsMenu alignItemsVerticallyWithPadding:40.0f];
        [optionsMenu setPosition:ccp(screenSize.width * 0.75f, screenSize.height/2)];
        [self addChild:optionsMenu];
        
        if ([[AudioManager sharedAudioManager] isMusicON] == NO) {
            [musicToggle setSelectedIndex:1]; // Music is OFF
        }
        
        if ([[AudioManager sharedAudioManager] isSoundEffectsON] == NO) {
            [SFXToggle setSelectedIndex:1]; // SFX are OFF
        }
    }
    return self;
}

@end
