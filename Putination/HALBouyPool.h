//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HALPlayer.h"

@interface HALBouyPool : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) HALPlayer *player;

@property (nonatomic, strong) NSMutableArray *all;
@property (nonatomic, strong) NSMutableArray *cities;
@property (nonatomic, strong) NSMutableArray *emergencyBoxes;
@property (nonatomic, strong) NSMutableArray *fuelCanisters;
@property (nonatomic, strong) NSMutableArray *armoryBoxes;
@property (nonatomic, strong) NSMutableArray *vehicles;
@property (nonatomic, strong) NSMutableArray *turrets;
@property (nonatomic, strong) NSMutableArray *bullets;
@property (nonatomic, strong) NSMutableArray *aircrafts;
@property (nonatomic, strong) NSMutableArray *supplyAirplanes;

+ (HALBouyPool *)sharedBouyPool;

- (id)init;

- (void)addBouy:(HALBouy *)bouy;

- (void)deleteBouy:(HALBouy *)bouy;

- (void)startAll;

- (void)stopAll;

- (void)deleteAll;

- (NSMutableArray *)getBouysForHeadingRange:(float)fromHeading
                                         to:(float)toHeading
                             fromCoordinate:(CLLocationCoordinate2D)coordinate;

@end
