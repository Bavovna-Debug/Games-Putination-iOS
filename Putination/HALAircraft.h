//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "HALBouy.h"

@interface HALAircraft : HALBouy

@property (nonatomic, assign) CLLocationDirection flightDirection;
@property (nonatomic, assign) CGFloat turnSpeedFactor;

- (id)initWithType:(HALBouyType)bouyType;

- (CLLocationCoordinate2D)destinationCoordinate;

- (CGFloat)speedFactor;

@end
