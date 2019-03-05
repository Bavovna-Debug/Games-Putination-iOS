//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
//

#import "HALBouy.h"

@interface HALCannonBullet : HALBouy

@property (nonatomic, assign) CLLocationDirection shotDirection;
@property (nonatomic, assign) CLLocationDistance maximalRange;
@property (nonatomic, assign) CLLocationDistance flownDistance;

- (id)initWithShot:(HALBouy *)shooter
    fromCoordinate:(CLLocationCoordinate2D)fromCoordinate
     shotDirection:(CLLocationDirection)shotDirection
      maximalRange:(CLLocationDistance)maximalRange;

@end
