//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "HALBouy.h"
#import "HALBouyPool.h"
#import "HALCity.h"
#import "HALKernel.h"
#import "HALTurret.h"
#import "HALVehicle.h"

@implementation HALCity

- (id)init
{
    self = [super initWithType:HALBouyTypeBurg];
    if (self == nil)
        return nil;

    self.placementRadius = 50.0f;
    self.occupiedRadius = 10.0f;
    
    return self;
}

- (void)start
{
    [super start];
    
    [self refreshFlag];
}

- (BOOL)occupied
{
    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];
    for (HALTurret *turret in [bouyPool turrets])
    {
        if ([turret active] && ([turret occupiedCity] == self))
            return YES;
    }
    
    return NO;
}

- (int)vehiclesDrivingHere
{
    int numberOfVehicles = 0;
    
    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];
    
    for (HALVehicle *vehicle in [bouyPool vehicles])
    {
        if ([vehicle driving] && (vehicle.destinationBouy == self))
            numberOfVehicles++;
    }
    
    return numberOfVehicles;
}

- (void)refreshFlag
{
    [[HALKernel sharedKernel] checkOccupation];

    NSString *flagName = ([self occupied] == NO) ? @"UA" : @"RU";
    
    UIImage *burgImage = [UIImage imageNamed:@"City"];
    UIImage *flagImage = [UIImage imageNamed:flagName];
    
    CGSize size = CGSizeMake(burgImage.size.width,
                             burgImage.size.height + flagImage.size.height);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1, -1);
    CGContextDrawImage(context,
                       CGRectMake(0,
                                  -(size.height),
                                  burgImage.size.width,
                                  burgImage.size.height),
                       [burgImage CGImage]);
    CGContextDrawImage(context,
                       CGRectMake(0,
                                  -(flagImage.size.height),
                                  flagImage.size.width,
                                  flagImage.size.height),
                       [flagImage CGImage]);
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [self setNeedsDisplay:YES];
}

@end
