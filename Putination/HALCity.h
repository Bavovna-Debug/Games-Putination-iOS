//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
//

#import "HALBouy.h"

@interface HALCity : HALBouy

- (id)init;

- (BOOL)occupied;

- (int)vehiclesDrivingHere;

- (void)refreshFlag;

@end
