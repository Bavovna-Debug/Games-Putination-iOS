//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
//

#import "HALApplicationDelegate.h"
#import "HALBouyPool.h"
#import "HALCity.h"
#import "HALKernel.h"

@interface HALKernel ()

@property (nonatomic, strong) NSTimer *fuelConsumptionTimer;

@end

@implementation HALKernel

@synthesize playerLife = _playerLife;
@synthesize fuelConsumptionTimer = _fuelConsumptionTimer;
@synthesize healthViewPanel = _healthViewPanel;

+ (HALKernel *)sharedKernel
{
    static dispatch_once_t onceToken;
    static HALKernel *kernel;
    
    dispatch_once(&onceToken, ^{
        kernel = [[HALKernel alloc] init];
    });
    
    return kernel;
}

- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;

    self.fuelConsumptionTimer = nil;

    [self reset];

    return self;
}

- (void)reset
{
    [self setPlayerLife:fullPlayerLife];
    [self setFuelLevel:fullTankLevel / 20];
    [self setArmoryAmount:fullArmory];
    
    if (self.fuelConsumptionTimer == nil) {
        self.fuelConsumptionTimer = [NSTimer scheduledTimerWithTimeInterval:20.0f
                                                                     target:self
                                                                   selector:@selector(hearthbeatFuelConsumption)
                                                                   userInfo:nil
                                                                    repeats:YES];
    }
}

- (void)hearthbeatFuelConsumption
{
    [self setFuelLevel:MAX(0, [self fuelLevel] - 1)];

    if (self.fuelLevel == 0) {
        HALApplicationDelegate *application = (HALApplicationDelegate *)[[UIApplication sharedApplication] delegate];
        [application gameOver:HALGameOverReasonFuel];
    }

    [self.healthViewPanel refreshDisplay];
}

- (void)playerHitByMissle
{
    [self setPlayerLife:MAX(0, [self playerLife] - 1)];
    
    if (self.playerLife == 0) {
        HALApplicationDelegate *application = (HALApplicationDelegate *)[[UIApplication sharedApplication] delegate];
        [application gameOver:HALGameOverReasonLife];
    }

    [self.radarViewController playerHitByMissle];
    [self.healthViewPanel refreshDisplay];
}

- (BOOL)playerCanShot
{
    if (self.armoryAmount == 0) {
        return NO;
    } else {
        [self.armoryViewPanel hideBullet:self.armoryAmount];
        self.armoryAmount--;
        return YES;
    }
}

- (BOOL)playerFoundEmergencyBox
{
    if ([self playerLife] == fullPlayerLife)
        return NO;
    
    [self setPlayerLife:MIN(fullPlayerLife, [self playerLife] + 4)];
    
    [self.healthViewPanel refreshDisplay];
    [self.findingViewPanel foundEmergencyBox];

    return YES;
}

- (BOOL)playerFoundFuelCanister
{
    if ([self fuelLevel] == fullTankLevel)
        return NO;

    [self setFuelLevel:MIN(fullTankLevel, [self fuelLevel] + 10)];

    [self.healthViewPanel refreshDisplay];
    [self.findingViewPanel foundFuelCanister];
    
    return YES;
}

- (BOOL)playerFoundArmoryBox
{
    if ([self armoryAmount] == fullArmory)
        return NO;

    int previousArmoryAmount = [self armoryAmount];
    
    [self setArmoryAmount:MIN(fullArmory, previousArmoryAmount + 10)];
    
    for (int bulletId = previousArmoryAmount + 1; bulletId <= [self armoryAmount]; bulletId++)
        [self.armoryViewPanel showBullet:bulletId];
    
    [self.findingViewPanel foundArmoryBox];

    return YES;
}

- (void)checkOccupation
{
    int occupiedCities = 0;

    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];
    for (HALCity *city in [bouyPool cities])
    {
        if ([city occupied])
            occupiedCities++;
    }
    
    if (occupiedCities == [[bouyPool cities] count]) {
        HALApplicationDelegate *application = (HALApplicationDelegate *)[[UIApplication sharedApplication] delegate];
        [application gameOver:HALGameOverReasonOccupation];
    }
}

@end
