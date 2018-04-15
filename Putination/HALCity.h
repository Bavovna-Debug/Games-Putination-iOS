//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "HALBouy.h"

@interface HALCity : HALBouy

- (id)init;

- (BOOL)occupied;

- (int)vehiclesDrivingHere;

- (void)refreshFlag;

@end
