//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "HALBouyPool.h"
#import "HALNavigator.h"
#import "HALSupplyAirplane.h"
#import "HALSupplyBouy.h"

@interface HALSupplyAirplane ()

@property (nonatomic, strong) NSTimer *destinationTimer;
@property (nonatomic, strong) HALBouy *bouyToDeliver;
@property (nonatomic, strong) UIImage *airplaneImage;

@end

@implementation HALSupplyAirplane
{
    CLLocationCoordinate2D currentDestinationCoordinate;
}

@synthesize destinationTimer = _destinationTimer;
@synthesize bouyToDeliver = _bouyToDeliver;
@synthesize airplaneImage = _airplaneImage;

- (id)init
{
    self = [super initWithType:HALBouyTypeSupplyAirplane];
    if (self == nil)
        return nil;
    
    self.placementRadius = 100.0f;
    self.occupiedRadius = 20.0f;
    self.flightDirection = 0.0f;
    
    HALNavigator *navigator = [HALNavigator sharedNavigator];
    currentDestinationCoordinate = [navigator randomLocationNearCoordinate:[navigator startPosition]
                                                                 rangeFrom:40.0f
                                                                   rangeTo:80.0f];

    self.destinationTimer = nil;
    self.bouyToDeliver = nil;
    self.airplaneImage = [UIImage imageNamed:@"SupplyAirplane"];
    
    return self;
}

- (BOOL)hasDeliveryOrder
{
    return (self.bouyToDeliver != nil);
}

- (void)orderBouyDelivery:(HALBouy *)bouy
{
    self.bouyToDeliver = bouy;
    currentDestinationCoordinate = [bouy location];
    
    self.destinationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                             target:self
                                                           selector:@selector(hearthbeatDestination)
                                                           userInfo:nil
                                                            repeats:YES];
    
    [self setTurnSpeedFactor:2.0f];
}

- (void)throughBouy
{
    if (self.destinationTimer == nil)
        return;

    [self.destinationTimer invalidate];
    self.destinationTimer = nil;

    HALSupplyBouy *supplyBouy = [[HALSupplyBouy alloc] initWithThrownBouy:self.bouyToDeliver];
    self.bouyToDeliver = nil;

    [[HALBouyPool sharedBouyPool] addBouy:supplyBouy];
    [supplyBouy start];
    
    HALNavigator *navigator = [HALNavigator sharedNavigator];
    currentDestinationCoordinate = [navigator randomLocationNearCoordinate:[navigator startPosition]
                                                                 rangeFrom:100.0f
                                                                   rangeTo:300.0f];

    [self setTurnSpeedFactor:1.0f];
}

- (void)hearthbeatDestination
{
    HALNavigator *navigator = [HALNavigator sharedNavigator];
    
    if (self.bouyToDeliver != nil) {
        CLLocationDistance distanceToDestination = [navigator distanceFrom:[self location]
                                                                        to:currentDestinationCoordinate];
        if (distanceToDestination <= 10.0f) {
            [self throughBouy];
            return;
        }
    }
}

- (CLLocationCoordinate2D)destinationCoordinate
{
    return currentDestinationCoordinate;
}

- (CGFloat)speedFactor
{
    return 2.0f;
}

- (CGSize)bouyFullSize
{
    return [self.airplaneImage size];
}

- (UIImage *)updatedImage:(CLLocationDirection)radarHeading
{
    CLLocationDirection rotationDegrees;
    
    CGSize size = self.airplaneImage.size;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context,
                          size.width / 2,
                          size.height / 2);
    
    rotationDegrees = oppositeDirection(correctDegrees(self.flightDirection - radarHeading));
    CGContextRotateCTM(context, degreesToRadians(rotationDegrees));
    CGContextDrawImage(context,
                       CGRectMake(-(size.width / 2),
                                  -(size.height / 2),
                                  size.width,
                                  size.height),
                       [self.airplaneImage CGImage]);
    
    CGContextScaleCTM(context, 1, -1);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
