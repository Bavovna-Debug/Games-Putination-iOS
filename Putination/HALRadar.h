//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HALBouy.h"
#import "HALRadarView.h"

#define BattleFieldSize         1200.0f
#define NumberOfCities          40
#define NumberOfVehicles        80
#define NumberOfSupplyAirplanes 2
#define NumberOfEmergencyBoxes  60
#define NumberOfFuelCanisters   60
#define NumberOfArmoryBoxes     60
#define MaxBulletsOnRadar       80

@interface HALRadar : NSObject

@property (nonatomic, assign) CGSize playAreaSize;
@property (nonatomic, weak) HALRadarView *view;

@property (nonatomic, assign) int numberOfCities;
@property (nonatomic, assign) int numberOfVehicles;
@property (nonatomic, assign) int numberOfSupplyAirplanes;
@property (nonatomic, assign) int numberOfEmergencyBoxes;
@property (nonatomic, assign) int numberOfFuelCanisters;
@property (nonatomic, assign) int numberOfArmoryBoxes;

+ (HALRadar *)sharedRadar;

- (id)init;

- (void)start;

- (void)stop;

- (void)registerOnRadar:(HALBouy *)bouy;

- (void)removeFromRadar:(HALBouy *)bouy;

- (void)prepareBattleField;

- (void)wipeOutBattleField;

- (void)orderBouyDelivery:(HALBouyType)bouyType;

@end
