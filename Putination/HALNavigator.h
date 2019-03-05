//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"

#define degreesToRadians(degrees) (degrees * (M_PI / 180.0f))
#define radiandsToDegrees(radiands) (radiands * (180.0f / M_PI))
#define oppositeDirection(direction) ((direction < 180.0f) ? (direction + 180.0f) : (direction - 180.0f))
#define correctDegrees(x) ((x < 0.0f) ? (360.0f + x) : ((x >= 360.0f) ? (x - 360.0f) : x))

@interface HALNavigator : NSObject <CLLocationManagerDelegate>

@property (nonatomic, assign) CLLocationCoordinate2D startPosition;

+ (HALNavigator *)sharedNavigator;

- (id)init;

- (void)startNavigation;

- (void)stopNavigation;

- (CLLocationCoordinate2D)deviceCoordinate;

- (CLLocationDistance)deviceAltitude;

- (CLLocationDirection)deviceHeading;

- (CLLocationCoordinate2D)randomLocationNearCoordinate:(CLLocationCoordinate2D)coordinate
                                             rangeFrom:(CLLocationDistance)rangeFrom
                                               rangeTo:(CLLocationDistance)rangeTo;

- (CLLocationDirection)headingFrom:(CLLocationCoordinate2D)fromCoordinate
                                to:(CLLocationCoordinate2D)toCoordinate;

- (CLLocationDirection)headingFrom:(CLLocationCoordinate2D)fromCoordinate
                                to:(CLLocationCoordinate2D)toCoordinate
                        forHeading:(CLLocationDirection)forHeading;

- (CLLocationDistance)distanceFrom:(CLLocationCoordinate2D)fromCoordinate
                                to:(CLLocationCoordinate2D)toCoordinate;

- (CLLocationCoordinate2D)shift:(CLLocationCoordinate2D)coordinate
                        heading:(CLLocationDegrees)heading
                       distance:(CLLocationDistance)distance;

@end
