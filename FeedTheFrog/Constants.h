//
//  Constants.h
//  FeedTheFrog
//

// Frog
#define kFrogZ 1
#define kFrogSpriteTagValue 0
#define kFrogIdleTimer 4.0f

// Flies
#define FOOD_FLY_POINT_WORTH 10
#define kFlyZ 5

#define kMainMenuTagValue 10

typedef enum {
    kNoSceneInitialized=0,
    kMainMenuScene=1,
    kOptionsScene=2,
    kGameScene1=100
} SceneTypes;

#define GAME_LEVEL_INDEX 100

// Audio Items
#define AUDIO_MAX_WAITTIME 150

typedef enum {
    kAudioManagerUninitialized=0,
    kAudioManagerFailed=1,
    kAudioManagerInitializing=2,
    kAudioManagerInitialized=100,
    kAudioManagerLoading=200,
    kAudioManagerReady=300
    
} AudioManagerSoundState;

// Audio Constants
#define SFX_NOTLOADED NO
#define SFX_LOADED YES

#define PLAYSOUNDEFFECT(...) \
[[AudioManager sharedAudioManager] playSoundEffect:@#__VA_ARGS__]

#define STOPSOUNDEFFECT(...) \
[[AudioManager sharedAudioManager] stopSoundEffect:__VA_ARGS__]

#define PTM_RATIO ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 100.0 : 50.0)
#define HD_PTM_RATIO 100.0

// Clouds
#define NUM_CLOUDS 5
#define kMaxCloudMoveDuration 25
#define kMinCloudMoveDuration 10

