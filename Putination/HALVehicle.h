//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "HALBouy.h"
#import "HALCity.h"

@interface HALVehicle : HALBouy

@property (nonatomic, weak) HALCity *destinationBouy;
@property (nonatomic, weak) HALBouy *targetBouy;

- (Boolean)driving;

- (Boolean)fit;

@end
