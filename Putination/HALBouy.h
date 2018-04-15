//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"

typedef enum
{
    HALBouyTypeNone,
    HALBouyTypePlayer,
    HALBouyTypeBurg,
    HALBouyTypeEmergencyBox,
    HALBouyTypeFuelCanister,
    HALBouyTypeArmoryBox,
    HALBouyTypeTank,
    HALBouyTypeTurret,
    HALBouyTypeCannonBullet,
    HALBouyTypeExplosion,
    HALBouyTypeSupplyAirplane,
    HALBouyTypeSupplyObject
} HALBouyType;

typedef enum
{
    HALDefusingMethodSwitchOff,
    HALDefusingMethodExplode
} HALDefusingMethod;

@interface HALBouy : NSObject

@property (nonatomic, assign) Boolean running;
@property (nonatomic, assign) HALBouyType bouyType;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, assign) CLLocationDistance placementRadius;
@property (nonatomic, assign) CLLocationDistance occupiedRadius;
@property (nonatomic, assign) Boolean needsDisplay;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;

- (id)initWithType:(HALBouyType)bouyType;

- (void)start;

- (void)stop;

- (void)remove;

- (CGSize)bouyFullSize;

- (CGPoint)pointOnRadar;

- (CGRect)frameOnRadar;

- (UIImage *)updatedImage:(CLLocationDirection)radarHeading;

- (BOOL)hit;

- (void)shot:(CLLocationDirection)shotDirection
       range:(CLLocationDistance)maximalRange;

@end
