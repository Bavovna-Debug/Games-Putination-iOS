//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "CoreLocation/CoreLocation.h"

#import "HALBouy.h"
#import "HALBouyPool.h"
#import "HALCity.h"
#import "HALNavigator.h"
#import "HALPlayer.h"
#import "HALRadar.h"
#import "HALSupplyAirplane.h"
#import "HALVehicle.h"

@interface HALRadar ()

@property (nonatomic, strong) NSTimer *radarTimer;

@end

@implementation HALRadar

@synthesize playAreaSize = _playAreaSize;
@synthesize radarTimer = _radarTimer;

+ (HALRadar *)sharedRadar
{
    static dispatch_once_t onceToken;
    static HALRadar *radar;
    
    dispatch_once(&onceToken, ^{
        radar = [[HALRadar alloc] init];
    });
    
    return radar;
}

- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    CGFloat fieldSize = 1200.0f;
    self.playAreaSize = CGSizeMake(fieldSize, fieldSize);

    self.numberOfCities = 40;
    self.numberOfVehicles = 40;
    self.numberOfSupplyAirplanes = 2;
    self.numberOfEmergencyBoxes = 50;
    self.numberOfFuelCanisters = 50;
    self.numberOfArmoryBoxes = 50;

    self.radarTimer = nil;
    
    return self;
}

- (void)start
{
    [self.view start];

    self.radarTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f
                                                       target:self
                                                     selector:@selector(hearthbeatFindingsOnBattlefield)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void)stop
{
    [self.view stop];

    if (self.radarTimer != nil) {
        [self.radarTimer invalidate];
        self.radarTimer = nil;
    }
}

- (void)registerOnRadar:(HALBouy *)bouy
{
    if (self.view != nil) {
        HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];
        
        NSInteger subviewIndex = 0;
        
        switch (bouy.bouyType)
        {
            case HALBouyTypeTank:
            case HALBouyTypeTurret:
            case HALBouyTypeCannonBullet:
                subviewIndex = [[bouyPool all] count] - [[bouyPool aircrafts] count] - 1;
                break;

            case HALBouyTypeSupplyAirplane:
                subviewIndex = [[bouyPool all] count];
                break;
                
            default:
                subviewIndex = 0;
                break;
        }
        
        [self.view insertSubview:bouy.imageView atIndex:subviewIndex];
    }
}

- (void)removeFromRadar:(HALBouy *)bouy
{
    if (self.view != nil) {
        [bouy.imageView removeFromSuperview];
    }
}

- (void)prepareBattleField
{
    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];

    HALPlayer *player = [[HALPlayer alloc] init];
    [bouyPool addBouy:player];

    for (int i = 0; i < self.numberOfCities; i++)
    {
        HALCity *city = [[HALCity alloc] init];
        [self distributeBouyOverTheArea:city
                              rangeFrom:200.0f
                                rangeTo:500.0f];
        [bouyPool addBouy:city];
    }

    for (int i = 0; i < self.numberOfVehicles; i++)
    {
        HALVehicle *vehicle = [[HALVehicle alloc] init];
        [self distributeBouyOverTheArea:vehicle
                              rangeFrom:200.0f
                                rangeTo:400.0f];
        [bouyPool addBouy:vehicle];
    }
    
    for (int i = 0; i < self.numberOfSupplyAirplanes; i++)
    {
        HALSupplyAirplane *supplyAirplane = [[HALSupplyAirplane alloc] init];
        [self distributeBouyOverTheArea:supplyAirplane
                              rangeFrom:300.0f
                                rangeTo:320.0f];
        [bouyPool addBouy:supplyAirplane];
    }
    
    for (int i = 0; i < self.numberOfEmergencyBoxes * 0.9; i++)
    {
        HALBouy *emergencyBox = [[HALBouy alloc] initWithType:HALBouyTypeEmergencyBox];
        [self distributeBouyOverTheArea:emergencyBox
                              rangeFrom:40.0f
                                rangeTo:400.0f];
        [bouyPool addBouy:emergencyBox];
    }
    
    for (int i = 0; i < self.numberOfFuelCanisters * 0.9; i++)
    {
        HALBouy *fuelCanister = [[HALBouy alloc] initWithType:HALBouyTypeFuelCanister];
        [self distributeBouyOverTheArea:fuelCanister
                              rangeFrom:40.0f
                                rangeTo:400.0f];
        [bouyPool addBouy:fuelCanister];
    }

    for (int i = 0; i < self.numberOfArmoryBoxes * 0.9; i++)
    {
        HALBouy *armoryBox = [[HALBouy alloc] initWithType:HALBouyTypeArmoryBox];
        [self distributeBouyOverTheArea:armoryBox
                              rangeFrom:40.0f
                                rangeTo:400.0f];
        [bouyPool addBouy:armoryBox];
    }

    [bouyPool startAll];
}

- (void)wipeOutBattleField
{
    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];
    [bouyPool stopAll];
    [bouyPool deleteAll];
}

- (void)hearthbeatFindingsOnBattlefield
{
    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];

    NSUInteger actualEmergencyBoxes = [[bouyPool emergencyBoxes] count];
    NSUInteger actualFuelCanisters = [[bouyPool fuelCanisters] count];
    NSUInteger actualArmoryBoxes = [[bouyPool armoryBoxes] count];
    
    if (actualEmergencyBoxes < self.numberOfEmergencyBoxes)
        [self orderBouyDelivery:HALBouyTypeEmergencyBox];

    if (actualFuelCanisters < self.numberOfFuelCanisters)
        [self orderBouyDelivery:HALBouyTypeFuelCanister];

    if (actualArmoryBoxes < self.numberOfArmoryBoxes)
        [self orderBouyDelivery:HALBouyTypeArmoryBox];

    NSUInteger actualEnemyUnits = [[bouyPool turrets] count];
    for (HALVehicle *vehicle in [bouyPool vehicles]) {
        if ([vehicle fit])
            actualEnemyUnits++;
    }
    
    if (actualEnemyUnits < (self.numberOfVehicles)) {
        HALVehicle *vehicle = [[HALVehicle alloc] init];
        [self distributeBouyOverTheArea:vehicle
                              rangeFrom:400.0f
                                rangeTo:600.0f];
        [bouyPool addBouy:vehicle];
        [vehicle start];
    }
}

- (void)orderBouyDelivery:(HALBouyType)bouyType
{
    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];

    HALBouy *bouy = [[HALBouy alloc] initWithType:bouyType];
    [self distributeBouyOverTheArea:bouy
                          rangeFrom:10.0f
                            rangeTo:20.0f];

    for (HALSupplyAirplane *supplyAirplane in [bouyPool supplyAirplanes])
    {
        if ([supplyAirplane hasDeliveryOrder] == NO) {
            [supplyAirplane orderBouyDelivery:bouy];
            break;
        }
    }
}

- (void)distributeBouyOverTheArea:(HALBouy *)thisBouy
                        rangeFrom:(CLLocationDistance)rangeFrom
                          rangeTo:(CLLocationDistance)rangeTo
{
    HALNavigator *navigator = [HALNavigator sharedNavigator];
    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];
    
    CLLocationCoordinate2D startPosition = [navigator startPosition];

    do {
        CLLocationCoordinate2D guessedLocation = [navigator randomLocationNearCoordinate:startPosition
                                                                               rangeFrom:rangeFrom
                                                                                 rangeTo:rangeTo];

        for (HALBouy *anotherBouy in [bouyPool all])
        {
            CLLocationDistance distance = [navigator distanceFrom:guessedLocation
                                                               to:[anotherBouy location]];
            distance -= [thisBouy placementRadius] + [anotherBouy placementRadius];
            if (distance > 5.0f)
            {
                [thisBouy setLocation:guessedLocation];
                return;
            }
        }
    } while (YES);
}

@end
