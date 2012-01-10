//
//  Bee.h
//  FeedTheFrog
//

#import "BaseFly.h"

@interface Bee : BaseFly {
}
- (id)initWithWorld:(b2World *)theWorld withGround:(b2Body*)groundBody atLocation:(CGPoint)location;

@end
