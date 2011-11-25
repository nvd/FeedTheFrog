//
//  GameManager.mm
//  FeedTheFrog
//

#import "GameManager.h"
#import "AudioManager.h"
#import "MainMenuScene.h"
#import "OptionsScene.h"
#import "Scene1.h"

@implementation GameManager
static GameManager* _sharedGameManager = nil;                      

- (id)init
{
    if ((self = [super init])) {
        // Game Manager initialized
        CCLOG(@"Game Manager Singleton, init");
    }
    
    return self;
}

- (NSString*)formatSceneTypeToString:(SceneTypes)sceneID {
    NSString *result = nil;
    switch(sceneID) {
        case kNoSceneInitialized:
            result = @"kNoSceneInitialized";
            break;
        case kMainMenuScene:
            result = @"kMainMenuScene";
            break;
        case kOptionsScene:
            result = @"kOptionsScene";
            break;
        case kGameScene1:
            result = @"kGameScene1";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected SceneType."];
    }
    return result;
}

-(NSDictionary *)getSoundEffectsListForSceneWithID:(SceneTypes)sceneID {
    NSString *fullFileName = @"SoundEffects.plist";
    NSString *plistPath;
    
    // 1: Get the Path to the plist file
    NSString *rootPath = 
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                         NSUserDomainMask, YES) 
     objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] 
                     pathForResource:@"SoundEffects" ofType:@"plist"];
    }
    
    // 2: Read in the plist file
    NSDictionary *plistDictionary = 
    [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // 3: If the plistDictionary was null, the file was not found.
    if (plistDictionary == nil) {
        CCLOG(@"Error reading SoundEffects.plist");
        return nil; // No Plist Dictionary or file found
    }
    
    // 4. If the list of soundEffectFiles is empty, load it
    [[AudioManager sharedAudioManager] loadListOfSoundEffectsFromPList:plistDictionary];
    
    // 5. Load the list of sound effects state, mark them as unloaded
    [[AudioManager sharedAudioManager] initSoundEffectStates];
    
    // 6. Return just the mini SFX list for this scene
    NSString *sceneIDName = [self formatSceneTypeToString:sceneID];
    NSDictionary *soundEffectsList = [plistDictionary objectForKey:sceneIDName];
    
    return soundEffectsList;
}

-(void)loadAudioForSceneWithID:(NSNumber*)sceneIDNumber {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    SceneTypes sceneID = (SceneTypes) [sceneIDNumber intValue];
    AudioManagerSoundState currentSoundState = [[AudioManager sharedAudioManager] managerSoundState];
    
    if (currentSoundState == kAudioManagerInitializing) {
        int waitCycles = 0;
        while (waitCycles < AUDIO_MAX_WAITTIME) {
            [NSThread sleepForTimeInterval:0.1f];
            if ((currentSoundState == kAudioManagerReady) || 
                (currentSoundState == kAudioManagerFailed)) {
                break;
            }
            waitCycles = waitCycles + 1;
        }
    }
    
    if (currentSoundState == kAudioManagerFailed) {
        return; // Nothing to load, CocosDenshion not ready
    }
    
    NSDictionary *soundEffectsToLoad = 
        [self getSoundEffectsListForSceneWithID:sceneID];
    if (soundEffectsToLoad == nil) { 
        CCLOG(@"Error reading SoundEffects.plist");
        return;
    }
    // Get all of the entries and PreLoad 
    for( NSString *keyString in soundEffectsToLoad )
    {
        CCLOG(@"\nLoading Audio Key:%@ File:%@", 
              keyString,[soundEffectsToLoad objectForKey:keyString]);
        [[AudioManager sharedAudioManager] loadSoundEffect:keyString 
                                         FromFile:[soundEffectsToLoad objectForKey:keyString]];
    }
    [pool release];
}

-(void)unloadAudioForSceneWithID:(NSNumber*)sceneIDNumber {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    SceneTypes sceneID = (SceneTypes)[sceneIDNumber intValue];
    if (sceneID == kNoSceneInitialized) {
        return; // Nothing to unload
    }
    
    NSDictionary *soundEffectsToUnload = 
        [self getSoundEffectsListForSceneWithID:sceneID];
    
    if (soundEffectsToUnload == nil) {
        CCLOG(@"Error reading SoundEffects.plist");
        return;
    }
    if ([[AudioManager sharedAudioManager] managerSoundState] == kAudioManagerReady) {
        // Get all of the entries and unload
        for( NSString *keyString in soundEffectsToUnload )
        {
            [[AudioManager sharedAudioManager] unloadSoundEffect:keyString];
            CCLOG(@"\nUnloading Audio Key:%@ File:%@", 
                  keyString,[soundEffectsToUnload objectForKey:keyString]);
        }
    }
    [pool release];
}

#pragma mark -
#pragma Run Scene Code
-(void)runSceneWithID:(SceneTypes)sceneID {
    SceneTypes oldScene = currentScene;
    currentScene = sceneID;
    
    id sceneToRun = nil;
    switch (sceneID) {
        case kMainMenuScene: 
            sceneToRun = [MainMenuScene node];
            break;
        case kOptionsScene:
            sceneToRun = [OptionsScene node];
            break;
        case kGameScene1:
            sceneToRun = [Scene1 node];
            break;
            
        default:
            CCLOG(@"Unknown ID, cannot switch scenes");
            return;
    }
    
    // Menu Scenes have a value of < 100
    if (sceneID < GAME_LEVEL_INDEX) {
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            CGSize screenSize = [CCDirector sharedDirector].winSizeInPixels; 
            if (screenSize.width == 960.0f) {
                // iPhone 4 Retina
                [sceneToRun setScaleX:0.9375f];
                [sceneToRun setScaleY:0.8333f];
                CCLOG(@"GameMgr:Scaling for iPhone 4 (retina)");
                
            } else {
                [sceneToRun setScaleX:0.4688f];
                [sceneToRun setScaleY:0.4166f];
                CCLOG(@"GameMgr:Scaling for iPhone 3GS or older (non-retina)");
                
            }
        }
    }
    
    [self performSelectorInBackground:@selector(loadAudioForSceneWithID:) 
                           withObject:[NSNumber numberWithInt:currentScene]];
    
    if ([[CCDirector sharedDirector] runningScene] == nil) {
        [[CCDirector sharedDirector] runWithScene:sceneToRun];
        
    } else {
        
        [[CCDirector sharedDirector] replaceScene:sceneToRun];
    }
    [self performSelectorInBackground:@selector(unloadAudioForSceneWithID:) 
                           withObject:[NSNumber numberWithInt:oldScene]];
    currentScene = sceneID;
}

#pragma mark -
#pragma mark Singleton Code
+(GameManager*)sharedGameManager {
    @synchronized([GameManager class])                            
    {
        if(!_sharedGameManager)                                    
            [[self alloc] init]; 
        return _sharedGameManager;                                 
    }
    return nil; 
}

+(id)alloc 
{
    @synchronized ([GameManager class])                            
    {
        NSAssert(_sharedGameManager == nil,
                 @"Attempted to allocated a second instance of the Game Manager singleton");
        _sharedGameManager = [super alloc];
        return _sharedGameManager;                                 
    }
    return nil;  
}

@end
