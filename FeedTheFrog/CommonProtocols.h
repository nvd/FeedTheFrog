//
//  CommonProtocols.h
//  FeedTheFrog
//

typedef enum {
    kStateIdle,
    kStateFlying,
    kStateFlicking,
    kStateBlowingBubble,
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