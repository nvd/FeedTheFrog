//
//  GameManager.mm
//  FeedTheFrog
//

#import "GameManager.h"

@implementation GameManager
static GameManager* _sharedGameManager = nil;                      

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark -
#pragma mark Singleton Setup Code

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
