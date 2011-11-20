//
//  Constants.h
//  FeedTheFrog
//

// NOTE: SceneTypes, SceneTypeStrings & MENU_SCENE_LIMIT_INDEX are co-related
typedef enum {
    kNoSceneInitialized=0,
    kMainMenuScene=1,
    kOptionsScene=2,
    kOriginalGameScene=3
} SceneTypes;

NSString* sceneTypeStrings[] = {    
    @"kNoSceneInitialized",
    @"kMainMenuScene",
    @"kOptionsScene",
    @"kOriginalGameScene"
};

#define MENU_SCENE_LIMIT_INDEX 3

// Audio Items
#define AUDIO_MAX_WAITTIME 150

typedef enum {
    kAudioManagerUninitialized=0,
    kAudioManagerFailed=1,
    kAudioManagerInitializing=2,
    kAudioManagerInitialized=100,
    kAudioManagerLoading=200,
    kAudioManagerReady=300
    
} GameManagerSoundState;

// Audio Constants
#define SFX_NOTLOADED NO
#define SFX_LOADED YES

#define PLAYSOUNDEFFECT(...) \
[[GameManager sharedGameManager] playSoundEffect:@#__VA_ARGS__]

#define STOPSOUNDEFFECT(...) \
[[GameManager sharedGameManager] stopSoundEffect:__VA_ARGS__]
