//
//  GameManager.h
//  FeedTheFrog
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface GameManager : NSObject {
    SceneTypes currentScene;
}

+(GameManager*)sharedGameManager;                                  

-(void)runSceneWithID:(SceneTypes)sceneID;

@end
