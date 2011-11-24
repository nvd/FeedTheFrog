//
//  CommonProtocols.h
//  FeedTheFrog
//

typedef enum {
    kStateIdle,
    kStateDead
} CharacterStates;

typedef enum{
    kObjectTypeNone,
    kFrog,
    KFoodFly,
    kBee,
    kBulletTimeBonusFly,
} GameObjectType;