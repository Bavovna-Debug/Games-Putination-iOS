//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "HALBouy.h"
#import "HALBouyPool.h"
#import "HALKernel.h"
#import "HALNavigator.h"
#import "HALRadar.h"
#import "HALTurret.h"

@interface HALTurret ()

@property (nonatomic, strong) UIImage *buildingImage;
@property (nonatomic, strong) UIImage *cannonImage;
@property (nonatomic, strong) NSTimer *searchTargetTimer;
@property (nonatomic, strong) NSTimer *turnCanonTimer;
@property (nonatomic, strong) NSTimer *fireTimer;

@end;

@implementation HALTurret
{
    BOOL explodedBuilding;
    BOOL explodedCannon;
}

@synthesize cannonDirection = _cannonDirection;
@synthesize targetCaptureRadius = _targetCaptureRadius;
@synthesize fireRadius = _fireRadius;

@synthesize occupiedCity = _occupiedCity;
@synthesize targetBouy = _targetBouy;

@synthesize buildingImage = _buildingImage;
@synthesize cannonImage = _cannonImage;
@synthesize searchTargetTimer = _searchTargetTimer;
@synthesize turnCanonTimer = _turnCanonTimer;
@synthesize fireTimer = _fireTimer;

- (id)initWithCity:(HALCity *)occupiedCity
{
    self = [super initWithType:HALBouyTypeTurret];
    if (self == nil)
        return nil;
    
    self.placementRadius = 0.0f;
    self.occupiedRadius = 10.0f;
    self.targetCaptureRadius = 600.0f;
    self.fireRadius = 500.0f;
    
    explodedBuilding = NO;
    explodedCannon = NO;
    
    self.buildingImage = [UIImage imageNamed:@"TurretBuilding"];
    self.cannonImage = [UIImage imageNamed:@"TurretCannon"];
    
    self.occupiedCity = occupiedCity;
    
    self.searchTargetTimer = nil;
    self.turnCanonTimer = nil;
    self.fireTimer = nil;

    return self;
}

- (BOOL)active
{
    return (explodedBuilding == NO);
}

- (void)start
{
    [super start];
    
    [self.occupiedCity refreshFlag];
    
    [self startNavigation];
}

- (void)stop
{
    [super stop];
    
    [self stopNavigation];
}

- (void)startNavigation
{
    NSTimeInterval shotingInterval = randomRange(8.0f, 10.0f);

    self.searchTargetTimer = [NSTimer scheduledTimerWithTimeInterval:2.5f
                                                              target:self
                                                            selector:@selector(hearthbeatSearchTarget)
                                                            userInfo:nil
                                                             repeats:YES];
    self.turnCanonTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f
                                                           target:self
                                                         selector:@selector(hearthbeatTurnCanon)
                                                         userInfo:nil
                                                          repeats:YES];
    self.fireTimer = [NSTimer scheduledTimerWithTimeInterval:shotingInterval
                                                      target:self
                                                    selector:@selector(hearthbeatFire)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)stopNavigation
{
    [self.searchTargetTimer invalidate];
    self.searchTargetTimer = nil;

    [self.turnCanonTimer invalidate];
    self.turnCanonTimer = nil;

    [self.fireTimer invalidate];
    self.fireTimer = nil;
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

- (void)hearthbeatSearchTarget
{
    if (explodedBuilding)
        return;

    HALNavigator *navigator = [HALNavigator sharedNavigator];
    HALBouyPool *bouys = [HALBouyPool sharedBouyPool];
    
    if (self.targetBouy == nil) {
        HALPlayer *player = [bouys player];
        CLLocationDistance distanceToGuessedTarget = [navigator distanceFrom:[self location]
                                                                          to:[player location]];
        if (distanceToGuessedTarget <= self.targetCaptureRadius) {
            self.targetBouy = player;
            [self hearthbeatFire];
        }
    } else {
        HALPlayer *player = [bouys player];
        CLLocationDistance distanceToGuessedTarget = [navigator distanceFrom:[self location]
                                                                          to:[player location]];
        if (distanceToGuessedTarget > self.targetCaptureRadius)
            self.targetBouy = nil;
    }
}

- (void)hearthbeatTurnCanon
{
    HALNavigator *navigator = [HALNavigator sharedNavigator];
    
    if ([navigator distanceFrom:[self location]
                             to:[self.targetBouy location]] > self.targetCaptureRadius) {
        self.targetBouy = nil;
        return;
    }
    
    CLLocationDirection targetRelativeHeading;
    if (self.targetBouy == nil) {
        targetRelativeHeading = self.cannonDirection;
    } else {
        targetRelativeHeading = [navigator headingFrom:[self location]
                                                    to:[self.targetBouy location]
                                            forHeading:self.cannonDirection];
    }
    
    const CGFloat turnSpeedFactor = 4.0f;

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
    if ([[bouyPool bullets] count] >= MaxBulletsOnRadar)
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
    return [self.buildingImage size];
}

- (UIImage *)updatedImage:(CLLocationDirection)radarHeading
{
    CLLocationDirection rotationDegrees;
    
    CGSize size = self.buildingImage.size;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context,
                          size.width / 2,
                          size.height / 2);
    
    rotationDegrees = oppositeDirection(correctDegrees(radarHeading));
    CGContextRotateCTM(context, degreesToRadians(rotationDegrees));
    if (explodedBuilding)
        CGContextSetAlpha(context, 0.25f);
    CGContextDrawImage(context,
                       CGRectMake(-(size.width / 2),
                                  -(size.height / 2),
                                  size.width,
                                  size.height),
                       [self.buildingImage CGImage]);
    
    rotationDegrees = correctDegrees(self.cannonDirection);
    CGContextRotateCTM(context, degreesToRadians(rotationDegrees));
    if (explodedBuilding && !explodedCannon)
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
    if (explodedCannon == NO) {
        [self stopNavigation];

        explodedCannon = YES;

        self.needsDisplay = YES;
    } else {
        explodedBuilding = YES;
        
        [self.occupiedCity refreshFlag];

        HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];
        [bouyPool deleteBouy:self];
    }

    return YES;
}

@end
