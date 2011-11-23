//
//  AudioManager.h
//  FeedTheFrog
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "SimpleAudioEngine.h"

@interface AudioManager : NSObject {
    BOOL isMusicON;
    BOOL isSoundEffectsON;
    
    BOOL hasAudioBeenInitialized;
    AudioManagerSoundState managerSoundState;
    SimpleAudioEngine *soundEngine;
    NSMutableDictionary *listOfSoundEffectFiles;
    NSMutableDictionary *soundEffectsState;
}
@property (readwrite) BOOL isMusicON;
@property (readwrite) BOOL isSoundEffectsON;
@property (readwrite) AudioManagerSoundState managerSoundState;
@property (nonatomic, retain) NSMutableDictionary *listOfSoundEffectFiles;
@property (nonatomic, retain) NSMutableDictionary *soundEffectsState;

+(AudioManager*)sharedAudioManager;
-(void)setupAudioEngine;

-(void)playBackgroundTrack:(NSString*) trackFileName;

-(ALuint)playSoundEffect:(NSString*) soundEffectKey;
-(void)stopSoundEffect:(ALuint) soundEffectID;
-(void)loadSoundEffect:(NSString*) keyString FromFile:(NSString*) keyString;
-(void)unloadSoundEffect:(NSString*) keyString;

-(void)loadListOfSoundEffectsFromPList:(NSDictionary*) plistDictionary;
-(void)initSoundEffectStates;
@end
