//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HALBouy.h"
#import "HALRadarView.h"

#define MAX_BULLETS_ON_RADAR 50

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
