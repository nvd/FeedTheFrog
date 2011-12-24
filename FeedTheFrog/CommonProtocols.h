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
    kFoodFly,
    kBee,
    kBulletTimeBonusFly,
    kCloud
} GameObjectType;