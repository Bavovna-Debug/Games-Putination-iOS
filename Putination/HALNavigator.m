//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "CoreLocation/CoreLocation.h"

#import "HALKernel.h"
#import "HALNavigator.h"

@interface HALNavigator ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation HALNavigator
{
    CLLocationCoordinate2D knownDeviceCoordinate;
    CLLocationDistance knownDeviceAltitude;
    CLLocationDirection knownDeviceHeading;
}

@synthesize locationManager = _locationManager;
@synthesize startPosition = _startPosition;

+ (HALNavigator *)sharedNavigator
{
    static dispatch_once_t onceToken;
    static HALNavigator *navigator;
    
    dispatch_once(&onceToken, ^{
        navigator = [[HALNavigator alloc] init];
    });
    
    return navigator;
}

- (id)init
{
    self = [super init];
    if (self == nil)
        return nil;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.headingFilter = 1.0f;
    self.locationManager.delegate = self;

    return self;
}

- (void)startNavigation
{
    [self.locationManager startUpdatingHeading];
    [self.locationManager startUpdatingLocation];
    
    self.startPosition = [[self.locationManager location] coordinate];
}

- (void)stopNavigation
{
    [self.locationManager stopUpdatingHeading];
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = (CLLocation *)[locations lastObject];
    knownDeviceAltitude = location.altitude;
    knownDeviceCoordinate = location.coordinate;
    //currentCoordinate.latitude = 48.646824;
    //currentCoordinate.longitude = 9.009466;
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
    knownDeviceHeading = newHeading.trueHeading;
}

- (CLLocationCoordinate2D)deviceCoordinate
{
    return knownDeviceCoordinate;
}

- (CLLocationDistance)deviceAltitude
{
    return knownDeviceAltitude;
}

- (CLLocationDirection)deviceHeading
{
    return knownDeviceHeading;
}

- (CLLocationCoordinate2D)randomLocationNearCoordinate:(CLLocationCoordinate2D)coordinate
                                             rangeFrom:(CLLocationDistance)rangeFrom
                                               rangeTo:(CLLocationDistance)rangeTo
{
    HALNavigator *navigator = [HALNavigator sharedNavigator];

    CLLocationDegrees guessedDegrees = randomValue(360.0f);
    CLLocationDistance guessedDistance = randomRange(rangeFrom, rangeTo);
    CLLocationCoordinate2D guessedLocation = [navigator shift:coordinate
                                                      heading:guessedDegrees
                                                     distance:guessedDistance];
        
    return guessedLocation;
}

- (CLLocationDirection)headingFrom:(CLLocationCoordinate2D)fromCoordinate
                                to:(CLLocationCoordinate2D)toCoordinate
{
    CLLocationDegrees fromLatitude = degreesToRadians(fromCoordinate.latitude);
    CLLocationDegrees fromLongitude = degreesToRadians(fromCoordinate.longitude);
    CLLocationDegrees toLatitude = degreesToRadians(toCoordinate.latitude);
    CLLocationDegrees toLongitude = degreesToRadians(toCoordinate.longitude);
    
    CLLocationDirection degree;
    
    degree = atan2(sin(toLongitude - fromLongitude) * cos(toLatitude), cos(fromLatitude) * sin(toLatitude) - sin(fromLatitude) * cos(toLatitude) * cos(toLongitude - fromLongitude));
    
    degree = radiandsToDegrees(degree);
    
    return (degree >= 0.0f) ? degree : 360.0f + degree;
}

- (CLLocationDirection)headingFrom:(CLLocationCoordinate2D)fromCoordinate
                                to:(CLLocationCoordinate2D)toCoordinate
                        forHeading:(CLLocationDirection)forHeading
{
    CLLocationDirection headingAbsolute = [self headingFrom:fromCoordinate
                                                         to:toCoordinate];
    CLLocationDirection headingRelative = headingAbsolute - forHeading;
    
    if (headingRelative < 180.0f)
        headingRelative = 360.0f + headingRelative;
    if (headingRelative > 180.0f)
        headingRelative = headingRelative - 360.0f;
    
    return headingRelative;
}

- (CLLocationDistance)distanceFrom:(CLLocationCoordinate2D)fromCoordinate
                                to:(CLLocationCoordinate2D)toCoordinate
{
    CLLocation *fromLocation = [[CLLocation alloc] initWithLatitude:fromCoordinate.latitude
                                                          longitude:fromCoordinate.longitude];
    CLLocation *toLocation = [[CLLocation alloc] initWithLatitude:toCoordinate.latitude
                                                        longitude:toCoordinate.longitude];
    
    CLLocationDistance distance = [toLocation distanceFromLocation:fromLocation];
    
    return distance;
}

- (CLLocationCoordinate2D)shift:(CLLocationCoordinate2D)fromCoordinate
                        heading:(CLLocationDegrees)heading
                       distance:(CLLocationDistance)distance
{
    double distanceRadians = distance / 6371000.0f;
    
    double bearingRadians = degreesToRadians(heading);
    
    double fromLatitudeRadians = degreesToRadians(fromCoordinate.latitude);
    
    double fromLongitudeRadians = degreesToRadians(fromCoordinate.longitude);
    
    double toLatitudeRadians = asin(sin(fromLatitudeRadians) * cos(distanceRadians) + cos(fromLatitudeRadians) * sin(distanceRadians) * cos(bearingRadians));
    
    double toLongitudeRadians = fromLongitudeRadians + atan2(sin(bearingRadians) * sin(distanceRadians) * cos(fromLatitudeRadians), cos(distanceRadians) - sin(fromLatitudeRadians) * sin(toLatitudeRadians));
    
    toLongitudeRadians = fmod((toLongitudeRadians + 3 * M_PI), (2 * M_PI)) - M_PI;
    
    CLLocationCoordinate2D toCoordinate;
    toCoordinate.latitude = radiandsToDegrees(toLatitudeRadians);
    toCoordinate.longitude = radiandsToDegrees(toLongitudeRadians);
    
    return toCoordinate;
}

@end
