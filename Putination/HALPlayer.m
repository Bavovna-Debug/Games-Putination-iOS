//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
//

#import "HALBouyPool.h"
#import "HALKernel.h"
#import "HALNavigator.h"
#import "HALPlayer.h"
#import "HALRadar.h"

@interface HALPlayer ()

@property (nonatomic, strong) UIImage *chassisImage;
@property (nonatomic, strong) UIImage *cannonImage;

@property (nonatomic, assign) CLLocationCoordinate2D lastKnownCoordinate;
@property (nonatomic, assign) CLLocationDirection driveDirection;

@property (nonatomic, strong) NSTimer *turnChassisTimer;
@property (nonatomic, strong) NSTimer *findingsTimer;

@end

@implementation HALPlayer

@synthesize chassisImage = _chassisImage;
@synthesize cannonImage = _cannonImage;

@synthesize lastKnownCoordinate = _lastKnownCoordinate;
@synthesize driveDirection = _driveDirection;
@synthesize fireRadius = _fireRadius;

@synthesize turnChassisTimer = _turnChassisTimer;
@synthesize findingsTimer = _findingsTimer;

- (id)init
{
    self = [super initWithType:HALBouyTypePlayer];
    if (self == nil)
        return nil;
    
    self.placementRadius = 0.0f;
    self.occupiedRadius = 8.0f;

    self.chassisImage = [UIImage imageNamed:@"MyTankChassis"];
    self.cannonImage = [UIImage imageNamed:@"MyTankCannon"];
    
    HALNavigator *navigator = [HALNavigator sharedNavigator];
    self.lastKnownCoordinate = [navigator deviceCoordinate];
    self.driveDirection = [navigator deviceHeading];
    self.fireRadius = 400.0f;

    self.turnChassisTimer = nil;
    self.findingsTimer = nil;
    
    [[HALBouyPool sharedBouyPool] setPlayer:self];

    return self;
}

- (void)start
{
    [super start];
    
    self.turnChassisTimer = [NSTimer scheduledTimerWithTimeInterval:0.25f
                                                             target:self
                                                           selector:@selector(hearthbeatTurnChassis)
                                                           userInfo:nil
                                                            repeats:YES];
    self.findingsTimer = [NSTimer scheduledTimerWithTimeInterval:1.1f target:self
                                                        selector:@selector(hearthbeatHaveFoundSomething)
                                                        userInfo:nil
                                                         repeats:YES];
}

- (void)stop
{
    [super stop];
    
    [self.turnChassisTimer invalidate];
    self.turnChassisTimer = nil;

    [self.findingsTimer invalidate];
    self.findingsTimer = nil;
}

- (void)hearthbeatTurnChassis
{
    HALNavigator *navigator = [HALNavigator sharedNavigator];

    CLLocationCoordinate2D currentCoordinate = [navigator deviceCoordinate];

    CLLocationDistance drivenDistance = [navigator distanceFrom:self.lastKnownCoordinate
                                                             to:currentCoordinate];
    CLLocationDirection drivenDirection = [navigator headingFrom:self.lastKnownCoordinate
                                                              to:currentCoordinate];
    CLLocationDirection relativeDrivenDirection = correctDegrees(drivenDirection - self.driveDirection);
    
    const CGFloat turnSpeedFactor = 10.0f;

    if (relativeDrivenDirection < 0.0f) {
        self.driveDirection -= MIN(turnSpeedFactor, -relativeDrivenDirection);
        [self setNeedsDisplay:YES];
    } else if (relativeDrivenDirection > 0.0f) {
        self.driveDirection += MIN(turnSpeedFactor, relativeDrivenDirection);
        [self setNeedsDisplay:YES];
    }
    
    if (drivenDistance > 2.0f)
        self.lastKnownCoordinate = currentCoordinate;
}

- (void)hearthbeatHaveFoundSomething
{
    HALKernel *kernel = [HALKernel sharedKernel];
    HALNavigator *navigator = [HALNavigator sharedNavigator];
    HALRadar *radar = [HALRadar sharedRadar];
    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];

    for (HALBouy *emergencyBox in [bouyPool emergencyBoxes])
    {
        CLLocationDistance distanceToGuessedTarget = [navigator distanceFrom:[self location]
                                                                          to:[emergencyBox location]];
        if (distanceToGuessedTarget <= 8.0f)
        {
            if ([kernel playerFoundEmergencyBox]) {
                [bouyPool deleteBouy:emergencyBox];
                [radar orderBouyDelivery:HALBouyTypeEmergencyBox];
            }
            
            break;
        }
    }

    for (HALBouy *fuelCanister in [bouyPool fuelCanisters])
    {
        CLLocationDistance distanceToGuessedTarget = [navigator distanceFrom:[self location]
                                                                          to:[fuelCanister location]];
        if (distanceToGuessedTarget <= 8.0f)
        {
            if ([kernel playerFoundFuelCanister]) {
                [bouyPool deleteBouy:fuelCanister];
                [radar orderBouyDelivery:HALBouyTypeFuelCanister];
            }
            
            break;
        }
    }
    
    for (HALBouy *armoryBox in [bouyPool armoryBoxes])
    {
        CLLocationDistance distanceToGuessedTarget = [navigator distanceFrom:[self location] to:[armoryBox location]];
        if (distanceToGuessedTarget <= 8.0f)
        {
            if ([kernel playerFoundArmoryBox]) {
                [bouyPool deleteBouy:armoryBox];
                [radar orderBouyDelivery:HALBouyTypeArmoryBox];
            }
            
            break;
        }
    }
}

- (CLLocationCoordinate2D)location
{
    return [[HALNavigator sharedNavigator] deviceCoordinate];
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

    rotationDegrees = correctDegrees(self.driveDirection - radarHeading);
    rotationDegrees = correctDegrees(rotationDegrees + 180.0f);
    CGContextRotateCTM(context, degreesToRadians(rotationDegrees));
    CGContextDrawImage(context,
                       CGRectMake(-(size.width / 2),
                                  -(size.height / 2),
                                  size.width, size.height),
                       [self.chassisImage CGImage]);

    rotationDegrees = correctDegrees(self.driveDirection - radarHeading);
    CGContextRotateCTM(context, degreesToRadians(-rotationDegrees));
    CGContextDrawImage(context,
                       CGRectMake(-(size.width / 2),
                                  -(size.height / 2),
                                  size.width,
                                  size.height),
                       [self.cannonImage CGImage]);
    
    CGContextScaleCTM(context, 1, -1);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (BOOL)hit
{
    HALKernel *kernel = [HALKernel sharedKernel];
    [kernel playerHitByMissle];
    
    return YES;
}

@end
