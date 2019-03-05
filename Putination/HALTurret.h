//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
//

#import "HALBouy.h"
#import "HALCity.h"

@interface HALTurret : HALBouy

@property (nonatomic, assign) CLLocationDirection cannonDirection;
@property (nonatomic, assign) CLLocationDistance targetCaptureRadius;
@property (nonatomic, assign) CLLocationDistance fireRadius;

@property (nonatomic, weak) HALCity *occupiedCity;
@property (nonatomic, weak) HALBouy *targetBouy;

- (id)initWithCity:(HALCity *)occupiedBurg;

- (BOOL)active;

@end
