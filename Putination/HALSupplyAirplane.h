//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "HALAircraft.h"

@interface HALSupplyAirplane : HALAircraft

- (BOOL)hasDeliveryOrder;

- (void)orderBouyDelivery:(HALBouy *)bouy;

@end
