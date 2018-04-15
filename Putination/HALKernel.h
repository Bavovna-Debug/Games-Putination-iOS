//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HALArmoryViewPanel.h"
#import "HALFindingViewPanel.h"
#import "HALHealthViewPanel.h"
#import "HALRadarViewController.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define randomValue(max) (((float)arc4random() / RAND_MAX) * max)
#define randomRange(min, max) (min + ((float)arc4random() / RAND_MAX) * (max - min))

#define fullPlayerLife  25
#define fullTankLevel   1000
#define fullArmory      20

@interface HALKernel : NSObject

@property (nonatomic, assign) int playerLife;
@property (nonatomic, assign) int fuelLevel;
@property (nonatomic, assign) int armoryAmount;

@property (nonatomic, weak) HALRadarViewController *radarViewController;
@property (nonatomic, weak) HALHealthViewPanel *healthViewPanel;
@property (nonatomic, weak) HALArmoryViewPanel *armoryViewPanel;
@property (nonatomic, weak) HALFindingViewPanel *findingViewPanel;

+ (HALKernel *)sharedKernel;

- (id)init;

- (void)reset;

- (void)playerHitByMissle;

- (BOOL)playerCanShot;

- (BOOL)playerFoundEmergencyBox;

- (BOOL)playerFoundFuelCanister;

- (BOOL)playerFoundArmoryBox;

- (void)checkOccupation;

@end
