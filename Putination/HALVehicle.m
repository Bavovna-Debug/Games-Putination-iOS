//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "HALBouy.h"
#import "HALBouyPool.h"
#import "HALNavigator.h"
#import "HALKernel.h"
#import "HALRadar.h"
#import "HALTurret.h"
#import "HALVehicle.h"

@interface HALVehicle ()

@property (nonatomic, strong) UIImage *chassisImage;
@property (nonatomic, strong) UIImage *cannonImage;

@property (nonatomic, assign) CLLocationDirection driveDirection;
@property (nonatomic, assign) CLLocationDirection cannonDirection;
@property (nonatomic, assign) CLLocationDistance targetCaptureRadius;
@property (nonatomic, assign) CLLocationDistance fireRadius;

@property (nonatomic, strong) NSTimer *driveTimer;
@property (nonatomic, strong) NSTimer *destinationTimer;
@property (nonatomic, strong) NSTimer *searchTargetTimer;
@property (nonatomic, strong) NSTimer *fireTimer;

@end;

@implementation HALVehicle
{
    CGFloat speedFactorMax;
    CGFloat speedFactor;
    BOOL explodedChassis;
    BOOL explodedCannon;
}

@synthesize chassisImage = _chassisImage;
@synthesize cannonImage = _cannonImage;

@synthesize driveDirection = _driveDirection;
@synthesize cannonDirection = _cannonDirection;
@synthesize targetCaptureRadius = _targetCaptureRadius;
@synthesize fireRadius = _fireRadius;

@synthesize driveTimer = _driveTimer;
@synthesize destinationTimer = _destinationTimer;
@synthesize searchTargetTimer = _searchTargetTimer;
@synthesize fireTimer = _fireTimer;

@synthesize destinationBouy = _destinationBouy;
@synthesize targetBouy = _targetBouy;

- (id)init
{
    self = [super initWithType:HALBouyTypeTank];
    if (self == nil)
        return nil;

    self.placementRadius = 10.0f;
    self.occupiedRadius = 8.0f;
    
    self.driveDirection = 0.0f;
    self.cannonDirection = 0.0f;
    self.targetCaptureRadius = 300.0f;
    self.fireRadius = 200.0f;

    speedFactorMax = 0.2f + ((float)rand() / RAND_MAX) * 0.1f;
    speedFactor = 0.0f;
    explodedChassis = NO;
    explodedCannon = NO;
    
    self.chassisImage = [UIImage imageNamed:@"TankChassis"];
    self.cannonImage = [UIImage imageNamed:@"TankCannon"];
    
    self.destinationBouy = nil;
    self.targetBouy = nil;

    self.driveTimer = nil;
    self.destinationTimer = nil;
    self.searchTargetTimer = nil;
    self.fireTimer = nil;

    return self;
}

- (void)start
{
    [super start];

    [self startNavigation];
    [self startDriving];
}

- (void)stop
{
    [super stop];
    
    [self stopNavigation];
    [self stopDriving];
    [self stopShoting];
}

- (void)startDriving
{
    self.driveTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                       target:self
                                                     selector:@selector(hearthbeatDrive)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void)stopDriving
{
    if (self.driveTimer != nil) {
        [self.driveTimer invalidate];
        self.driveTimer = nil;
    }
}

- (void)startNavigation
{
    self.destinationTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                             target:self
                                                           selector:@selector(hearthbeatDestination)
                                                           userInfo:nil
                                                            repeats:YES];
    self.searchTargetTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                              target:self
                                                            selector:@selector(hearthbeatSearchTarget)
                                                            userInfo:nil
                                                             repeats:YES];
}

- (void)stopNavigation
{
    if (self.destinationTimer != nil) {
        [self.destinationTimer invalidate];
        self.destinationTimer = nil;
    }

    if (self.searchTargetTimer != nil) {
        [self.searchTargetTimer invalidate];
        self.searchTargetTimer = nil;
    }
}

- (void)startShoting
{
    NSTimeInterval shotingInterval = randomRange(8.0f, 10.0f);
    self.fireTimer = [NSTimer scheduledTimerWithTimeInterval:shotingInterval
                                                      target:self
                                                    selector:@selector(hearthbeatFire)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)stopShoting
{
    if (self.fireTimer != nil) {
        [self.fireTimer invalidate];
        self.fireTimer = nil;
    }
}

- (Boolean)driving
{
    return (speedFactor > 0.0f);
}

- (Boolean)fit
{
    return (explodedChassis == NO);
}

- (void)moveVehicle
{
    HALNavigator *navigator = [HALNavigator sharedNavigator];
    
    CLLocationCoordinate2D shiftedLocation;
    shiftedLocation = [navigator shift:[self location]
                               heading:[self driveDirection]
                              distance:speedFactor];
    [self setLocation:shiftedLocation];
}

- (void)steerChassisLeft:(CLLocationDirection)degrees
{
    self.driveDirection = correctDegrees(self.driveDirection - degrees);
    self.needsDisplay = YES;
}

- (void)steerChassisRight:(CLLocationDirection)degrees
{
    self.driveDirection = correctDegrees(self.driveDirection + degrees);
    self.needsDisplay = YES;
}

- (void)rotateCannonLeft:(CLLocationDirection)degrees
{
    self.cannonDirection = correctDegrees(self.cannonDirection - degrees);
    self.needsDisplay = YES;
}

- (void)rotateCannonRight:(CLLocationDirection)degrees
{
    self.cannonDirection = correctDegrees(self.cannonDirection + degrees);
    self.needsDisplay = YES;
}

- (void)hearthbeatDestination
{
    if (explodedChassis)
        return;

    HALNavigator *navigator = [HALNavigator sharedNavigator];
    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];

    if (self.destinationBouy == nil) {
        for (HALCity *city in [bouyPool cities])
        {
            if (city == self.destinationBouy)
                continue;
            
            if (self.destinationBouy == nil) {
                if ([city vehiclesDrivingHere] < 4) {
                    self.destinationBouy = city;
                    break;
                }
            } else {
                CLLocationDistance distanceToLastBouy = [navigator distanceFrom:[self location]
                                                                             to:[self.destinationBouy location]];
                CLLocationDistance distanceToThisBouy = [navigator distanceFrom:[self location]
                                                                             to:[city location]];
                if (distanceToThisBouy > distanceToLastBouy) {
                    if ([city vehiclesDrivingHere] < 4) {
                        self.destinationBouy = city;
                        break;
                    }
                }
            }
        }
    } else {
        CLLocationDistance distanceToDestination = [navigator distanceFrom:[self location]
                                                                        to:[self.destinationBouy location]];
        CLLocationDistance distanceToConvertToTurret = (self.occupiedRadius + self.destinationBouy.occupiedRadius) * 1.2f;

        if (distanceToDestination <= distanceToConvertToTurret)
        {
            [self stop];
            
            HALTurret *turret = [[HALTurret alloc] initWithCity:(HALCity *) self.destinationBouy];
            [turret setLocation:[self location]];
            
            [bouyPool addBouy:turret];
            [bouyPool deleteBouy:self];

            // Start turret only after it is inserted to bouys pool otherwise the coccupied city
            // will not change the flag.
            //
            [turret start];
        }
    }
}

- (void)hearthbeatDrive
{
    if (explodedChassis)
        return;
    
    BOOL mustSkipBouyOnMyWay = NO;
    
    HALNavigator *navigator = [HALNavigator sharedNavigator];
    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];
    
    for (HALBouy *bouy in [bouyPool all])
    {        
        if (bouy == self)
            continue;
        
        CLLocationDistance normalDistanceToAnotherBouy = self.occupiedRadius + bouy.occupiedRadius;
        CLLocationDistance actualDistanceToAnotherBouy = [navigator distanceFrom:[self location]
                                                                              to:[bouy location]];
        if (actualDistanceToAnotherBouy > normalDistanceToAnotherBouy)
            continue;
        
        CLLocationDirection headingToAnotherBouy = [navigator headingFrom:[self location]
                                                                       to:[bouy location]
                                                               forHeading:self.driveDirection];
        
        if ((headingToAnotherBouy > -90.0f) && (headingToAnotherBouy < 90.0f))
        {
            if (bouy.bouyType == HALBouyTypeTank) {
                HALVehicle *otherTank = (HALVehicle *)bouy;
                if ([otherTank driving] == YES) {
                    speedFactor = -(speedFactorMax / 2);
                    
                    if (headingToAnotherBouy < 0.0f) {
                        [self steerChassisRight:4.0f];
                    } else {
                        [self steerChassisLeft:4.0f];
                    }
                
                    mustSkipBouyOnMyWay = YES;
                    break;
                }
            }
            
            const CGFloat turnSpeedFactor = 4.0f;

            if (headingToAnotherBouy < 0.0f) {
                CLLocationDirection headingFactor = (90.0f + headingToAnotherBouy) / 90.0f;
                headingToAnotherBouy = MIN(turnSpeedFactor, -headingToAnotherBouy);
                [self steerChassisRight:headingToAnotherBouy * headingFactor];
            } else if (headingToAnotherBouy > 0.0f) {
                CLLocationDirection headingFactor = (90.0f - headingToAnotherBouy) / 90.0f;
                headingToAnotherBouy = MIN(turnSpeedFactor, headingToAnotherBouy);
                [self steerChassisLeft:headingToAnotherBouy * headingFactor];
            } else {
                [self steerChassisRight:4.0f];
            }

            mustSkipBouyOnMyWay = YES;
            break;
        }
    }

    if (mustSkipBouyOnMyWay == NO) {
        CLLocationDirection headingToDestinationBouy = [navigator headingFrom:[self location]
                                                                           to:[self.destinationBouy location]
                                                                   forHeading:self.driveDirection];
        
        const CGFloat turnSpeedFactor = 2.0f;

        if (headingToDestinationBouy < -1.0f) {
            headingToDestinationBouy = MIN(turnSpeedFactor, -headingToDestinationBouy);
            [self steerChassisLeft:headingToDestinationBouy];
        } else if (headingToDestinationBouy > 1.0f) {
            headingToDestinationBouy = MIN(turnSpeedFactor, headingToDestinationBouy);
            [self steerChassisRight:headingToDestinationBouy];
        }
    }
    
    if (speedFactor == 0.0f) {
        [self performSelector:@selector(hearthbeatCheckIfStuckDriving)
                   withObject:nil
                   afterDelay:8.0f];
    }
    
    if (speedFactor < speedFactorMax)
        speedFactor += speedFactorMax / 8;

    [self moveVehicle];
    [self turnCanon];
}

- (void)hearthbeatCheckIfStuckDriving
{
    if (self.running == NO)
        return;
    
    if (speedFactor == 0.0f)
        speedFactor = speedFactorMax;

    [self moveVehicle];
}

- (void)hearthbeatSearchTarget
{
    if (explodedCannon)
        return;

    if ([self driving] == NO)
        return;
    
    HALNavigator *navigator = [HALNavigator sharedNavigator];
    HALBouyPool *bouys = [HALBouyPool sharedBouyPool];

    if (self.targetBouy == nil) {
        HALPlayer *player = [bouys player];
        CLLocationDistance distanceToGuessedTarget = [navigator distanceFrom:[self location]
                                                                          to:[player location]];
        if (distanceToGuessedTarget <= self.targetCaptureRadius) {
            self.targetBouy = player;
            [self startShoting];
        }
    } else {
        HALPlayer *player = [bouys player];
        CLLocationDistance distanceToGuessedTarget = [navigator distanceFrom:[self location]
                                                                          to:[player location]];
        if (distanceToGuessedTarget > self.targetCaptureRadius)
            self.targetBouy = nil;
    }
}

- (void)turnCanon
{
    if (explodedCannon)
        return;

    HALNavigator *navigator = [HALNavigator sharedNavigator];
    
    if ([navigator distanceFrom:[self location]
                             to:[self.targetBouy location]] > self.targetCaptureRadius) {
        self.targetBouy = nil;
        [self hearthbeatSearchTarget];
    }

    CLLocationDirection targetRelativeHeading;
    if (self.targetBouy == nil) {
        targetRelativeHeading = self.driveDirection - self.cannonDirection;
    } else {
        targetRelativeHeading = [navigator headingFrom:[self location]
                                                    to:[self.targetBouy location]
                                            forHeading:self.cannonDirection];
    }

    CGFloat turnSpeedFactor = (self.targetBouy == nil) ? 1.0f : 3.0f;
    
    if (targetRelativeHeading < -1.0f) {
        targetRelativeHeading = MIN(turnSpeedFactor, -targetRelativeHeading);
        [self rotateCannonLeft:targetRelativeHeading];
    } else if (targetRelativeHeading > 1.0f) {
        targetRelativeHeading = MIN(turnSpeedFactor, targetRelativeHeading);
        [self rotateCannonRight:targetRelativeHeading];
    }
}

- (void)hearthbeatFire
{
    if (self.targetBouy == nil)
        return;
    
    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];
    if ([[bouyPool bullets] count] >= MAX_BULLETS_ON_RADAR)
        return;

    HALNavigator *navigator = [HALNavigator sharedNavigator];
    CLLocationDirection targetRelativeHeading = [navigator headingFrom:[self location]
                                                                    to:[self.targetBouy location]
                                                            forHeading:self.cannonDirection];

    if ((targetRelativeHeading > -2.0f) && (targetRelativeHeading < 2.0f)) {
        if ([navigator distanceFrom:[self location]
                                 to:[self.targetBouy location]] <= self.fireRadius) {
            [self shot:[self cannonDirection]
                 range:self.fireRadius];
        }
    }
}

- (CGSize)bouyFullSize
{
    return [self.chassisImage size];
}

- (UIImage *)updatedImage:(CLLocationDirection)radarHeading
{
    CLLocationDirection rotationDegrees;
    
    CGSize size = self.chassisImage.size;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context,
                          size.width / 2,
                          size.height / 2);
    
    rotationDegrees = oppositeDirection(correctDegrees(self.driveDirection - radarHeading));
    CGContextRotateCTM(context, degreesToRadians(rotationDegrees));
    if (explodedChassis)
        CGContextSetAlpha(context, 0.25f);
    CGContextDrawImage(context,
                       CGRectMake(-(size.width / 2),
                                  -(size.height / 2),
                                  size.width,
                                  size.height),
                       [self.chassisImage CGImage]);

    rotationDegrees = correctDegrees(self.cannonDirection - self.driveDirection);
    CGContextRotateCTM(context, degreesToRadians(rotationDegrees));
    if (explodedChassis && !explodedCannon)
        CGContextSetAlpha(context, 1.0f);
    CGContextDrawImage(context,
                       CGRectMake(-(size.width / 2),
                                  -(size.height / 2),
                                  size.width,
                                  size.height),
                       [self.cannonImage CGImage]);

    CGContextScaleCTM(context, 1, 1);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (BOOL)hit
{
    if (explodedChassis == NO) {
        explodedChassis = YES;
        
        [self stopDriving];
    } else {
        explodedCannon = YES;
        
        [self stopNavigation];
        [self stopShoting];
    }
    
    self.needsDisplay = YES;
    
    return YES;
}

@end
