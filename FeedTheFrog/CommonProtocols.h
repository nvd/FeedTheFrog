//
//  CommonProtocols.h
//  FeedTheFrog
//

typedef enum {
    kStateIdle,
    kStateFlying,
    kStateFlicking,
    kStateDead
} CharacterStates;

typedef enum{
    kObjectTypeNone,
    kFrog,
    KFoodFly,
    kBee,
    kBulletTimeBonusFly,
    kCloud
} GameObjectType;