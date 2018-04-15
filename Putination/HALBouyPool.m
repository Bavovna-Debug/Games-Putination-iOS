//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "HALBouy.h"
#import "HALBouyPool.h"
#import "HALNavigator.h"
#import "HALRadar.h"

@interface HALBouyPool ()

@end

@implementation HALBouyPool
{
    HALBouy *bouyToParse;
    NSString *currentElementName;
}

@synthesize player = _player;
@synthesize all = _all;
@synthesize cities = _cities;
@synthesize emergencyBoxes = _emergencyBoxes;
@synthesize fuelCanisters = _fuelCanisters;
@synthesize armoryBoxes = _armoryBoxes;
@synthesize vehicles = _vehicles;
@synthesize turrets = _turrets;
@synthesize bullets = _bullets;
@synthesize aircrafts = _aircrafts;
@synthesize supplyAirplanes = _supplyAirplanes;

+ (HALBouyPool *)sharedBouyPool
{
    static dispatch_once_t onceToken;
    static HALBouyPool *bouys;
    
    dispatch_once(&onceToken, ^{
        bouys = [[HALBouyPool alloc] init];
    });
    
    return bouys;
}

- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    self.all = [NSMutableArray array];
    self.cities = [NSMutableArray array];
    self.emergencyBoxes = [NSMutableArray array];
    self.fuelCanisters = [NSMutableArray array];
    self.armoryBoxes = [NSMutableArray array];
    self.vehicles = [NSMutableArray array];
    self.turrets = [NSMutableArray array];
    self.bullets = [NSMutableArray array];
    self.aircrafts = [NSMutableArray array];
    self.supplyAirplanes = [NSMutableArray array];

    return self;
}

- (void)startAll
{
    for (HALBouy *bouy in [self all])
    {
        [bouy start];
    }
}

- (void)stopAll
{
    for (HALBouy *bouy in [self all])
    {
        [bouy stop];
    }
}

- (void)deleteAll
{
    while ([[self all] count] > 0)
    {
        HALBouy *bouy = (HALBouy *)[[self all] lastObject];
        [self deleteBouy:bouy];
    }
}

- (void)addBouy:(HALBouy *)bouy
{
    switch (bouy.bouyType)
    {
        case HALBouyTypePlayer:
            [self.all addObject:bouy];
            [self setPlayer:(HALPlayer *)bouy];
            break;
            
        case HALBouyTypeBurg:
            [self.all addObject:bouy];
            [self.cities addObject:bouy];
            break;
            
        case HALBouyTypeEmergencyBox:
            [self.all addObject:bouy];
            [self.emergencyBoxes addObject:bouy];
            break;

        case HALBouyTypeFuelCanister:
            [self.all addObject:bouy];
            [self.fuelCanisters addObject:bouy];
            break;

        case HALBouyTypeArmoryBox:
            [self.all addObject:bouy];
            [self.armoryBoxes addObject:bouy];
            break;

        case HALBouyTypeTank:
            [self.all addObject:bouy];
            [self.vehicles addObject:bouy];
            break;
            
        case HALBouyTypeTurret:
            [self.all addObject:bouy];
            [self.turrets addObject:bouy];
            break;

        case HALBouyTypeCannonBullet:
            [self.all addObject:bouy];
            [self.bullets addObject:bouy];
            break;

        case HALBouyTypeSupplyAirplane:
            [self.all addObject:bouy];
            [self.aircrafts addObject:bouy];
            [self.supplyAirplanes addObject:bouy];
            break;

        default:
            [self.all addObject:bouy];
            break;
    }
    
    [[HALRadar sharedRadar] registerOnRadar:bouy];
}

- (void)deleteBouy:(HALBouy *)bouy
{
    [[HALRadar sharedRadar] removeFromRadar:bouy];
    
    switch (bouy.bouyType)
    {
        case HALBouyTypePlayer:
            [self setPlayer:nil];
            [self.all removeObject:bouy];
            break;
            
        case HALBouyTypeBurg:
            [self.cities removeObject:bouy];
            [self.all removeObject:bouy];
            break;
            
        case HALBouyTypeEmergencyBox:
            [self.emergencyBoxes removeObject:bouy];
            [self.all removeObject:bouy];
            break;
            
        case HALBouyTypeFuelCanister:
            [self.fuelCanisters removeObject:bouy];
            [self.all removeObject:bouy];
            break;
            
        case HALBouyTypeArmoryBox:
            [self.armoryBoxes removeObject:bouy];
            [self.all removeObject:bouy];
            break;
            
        case HALBouyTypeTank:
            [self.vehicles removeObject:bouy];
            [self.all removeObject:bouy];
            break;
            
        case HALBouyTypeTurret:
            [self.turrets removeObject:bouy];
            [self.all removeObject:bouy];
            break;
            
        case HALBouyTypeCannonBullet:
            [self.bullets removeObject:bouy];
            [self.all removeObject:bouy];
            break;
            
        case HALBouyTypeSupplyAirplane:
            [self.supplyAirplanes removeObject:bouy];
            [self.aircrafts removeObject:bouy];
            [self.all removeObject:bouy];
            break;
            
        default:
            [self.all removeObject:bouy];
            break;
    }
}

- (NSMutableArray *)getBouysForHeadingRange:(float)fromHeading
                                         to:(float)toHeading
                             fromCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    HALNavigator *navigator = [HALNavigator sharedNavigator];
    
    for (HALBouy *bouy in [self all])
    {
        CLLocationDirection heading = [navigator headingFrom:coordinate
                                                          to:[bouy location]];
        if (fromHeading < toHeading) {
            if ((heading >= fromHeading) && (heading <= toHeading)) {
                [result addObject:bouy];
            }
        } else {
            if ((heading >= toHeading) && (heading <= fromHeading)) {
                [result addObject:bouy];
            }
        }
    }
    
    return result;
}

@end
