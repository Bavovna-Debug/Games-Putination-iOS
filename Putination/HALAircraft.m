//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "HALAircraft.h"
#import "HALBouy.h"
#import "HALBouyPool.h"
#import "HALNavigator.h"

@interface HALAircraft ()

@property (nonatomic, strong) NSTimer *flyTimer;

@end

@implementation HALAircraft

@synthesize flightDirection = _flightDirection;
@synthesize turnSpeedFactor = _turnSpeedFactor;
@synthesize flyTimer = _flyTimer;

- (id)initWithType:(HALBouyType)bouyType;
{
    self = [super initWithType:bouyType];
    if (self == nil)
        return nil;

    self.placementRadius = 100.0f;
    self.occupiedRadius = 20.0f;
    self.flightDirection = 0.0f;
    
    return self;
}

- (void)start
{
    [super start];
    
    self.turnSpeedFactor = 0.5f;

    [self startFlying];
}

- (void)stop
{
    [super stop];
    
    [self stopFlying];
}

- (void)startFlying
{
    self.flyTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                     target:self
                                                   selector:@selector(hearthbeatFly)
                                                   userInfo:nil
                                                    repeats:YES];
}

- (void)stopFlying
{
    if (self.flyTimer != nil ) {
        [self.flyTimer invalidate];
        self.flyTimer = nil;
    }
}

- (void)moveAircraft
{
    HALNavigator *navigator = [HALNavigator sharedNavigator];
    
    CLLocationCoordinate2D shiftedLocation;
    shiftedLocation = [navigator shift:[self location]
                               heading:[self flightDirection]
                              distance:[self speedFactor]];
    [self setLocation:shiftedLocation];
}

- (void)turnLeft:(CLLocationDirection)degrees
{
    self.flightDirection = correctDegrees(self.flightDirection - degrees);
    self.needsDisplay = YES;
}

- (void)turnRight:(CLLocationDirection)degrees
{
    self.flightDirection = correctDegrees(self.flightDirection + degrees);
    self.needsDisplay = YES;
}

- (void)hearthbeatFly
{
    BOOL mustSkipAircraftOnMyWay = NO;
    
    HALNavigator *navigator = [HALNavigator sharedNavigator];
    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];
    
    for (HALAircraft *aircraft in [bouyPool aircrafts])
    {
        if (aircraft == self)
            continue;
        
        CLLocationDistance normalDistanceToAnotherAicraft = self.occupiedRadius + aircraft.occupiedRadius;
        CLLocationDistance actualDistanceToAnotherAicraft = [navigator distanceFrom:[self location]
                                                                                 to:[aircraft location]];
        if (actualDistanceToAnotherAicraft > normalDistanceToAnotherAicraft)
            continue;
        
        CLLocationDirection headingToAnotherAicraft = [navigator headingFrom:[self location]
                                                                          to:[aircraft location]
                                                                  forHeading:self.flightDirection];
        
        if ((headingToAnotherAicraft > -90.0f) && (headingToAnotherAicraft < 90.0f))
        {
            if (headingToAnotherAicraft < 0.0f) {
                [self turnRight:4.0f];
            } else {
                [self turnLeft:4.0f];
            }
            
            mustSkipAircraftOnMyWay = YES;
            break;
        }
    }
    
    if (mustSkipAircraftOnMyWay == NO) {
        CLLocationDirection headingToDestinationPoint = [navigator headingFrom:[self location]
                                                                            to:[self destinationCoordinate]
                                                                    forHeading:self.flightDirection];
        
        if (headingToDestinationPoint < -1.0f) {
            headingToDestinationPoint = MIN(self.turnSpeedFactor, -headingToDestinationPoint);
            [self turnLeft:headingToDestinationPoint];
        } else if (headingToDestinationPoint > 1.0f) {
            headingToDestinationPoint = MIN(self.turnSpeedFactor, headingToDestinationPoint);
            [self turnRight:headingToDestinationPoint];
        }
    }
    
    [self moveAircraft];
}

- (CLLocationCoordinate2D)destinationCoordinate
{
    return CLLocationCoordinate2DMake(0.0f, 0.0f);
}

- (CGFloat)speedFactor
{
    return 0.0f;
}

@end
