//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
//

#import "HALBouy.h"
#import "HALBouyPool.h"
#import "HALCannonBullet.h"
#import "HALExplosion.h"
#import "HALNavigator.h"

@interface HALCannonBullet ()

@property (nonatomic, weak) HALBouy *shooter;
@property (nonatomic, strong) UIImage *bulletImage;
@property (nonatomic, strong) NSTimer *flyTimer;

@end;

@implementation HALCannonBullet
{
    CLLocationDistance catchRadius;
    CGFloat speedFactor;
}

@synthesize shooter = _shooter;
@synthesize bulletImage = _bulletImage;
@synthesize flyTimer = _flyTimer;
@synthesize shotDirection = _shotDirection;
@synthesize maximalRange = _maximalRange;
@synthesize flownDistance = _flownDistance;

- (id)initWithShot:(HALBouy *)shooter
    fromCoordinate:(CLLocationCoordinate2D)fromCoordinate
     shotDirection:(CLLocationDirection)shotDirection
      maximalRange:(CLLocationDistance)maximalRange
{
    self = [super initWithType:HALBouyTypeCannonBullet];
    if (self == nil)
        return nil;

    self.placementRadius = 0.0f;
    self.occupiedRadius = 0.0f;
    

    HALNavigator *navigator = [HALNavigator sharedNavigator];
    self.location = [navigator shift:fromCoordinate
                             heading:shotDirection
                            distance:5.0f];

    self.shooter = shooter;
    self.shotDirection = shotDirection;
    self.maximalRange = maximalRange;
    self.flownDistance = 0.0f;
    
    self.bulletImage = [UIImage imageNamed:@"CannonBullet"];
    
    self.flyTimer = nil;
    
    catchRadius = 5.0f;
    switch (shooter.bouyType) {
        case HALBouyTypePlayer:
            speedFactor = 2.4f;
            break;
            
        case HALBouyTypeTank:
            speedFactor = 1.0f;
            break;

        case HALBouyTypeTurret:
            speedFactor = 0.8f;
            break;

        default:
            break;
    }
    
    return self;
}

- (void)start
{
    [super start];
    
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
    [self.flyTimer invalidate];
    self.flyTimer = nil;
}

- (void)hearthbeatFly
{
    HALNavigator *navigator = [HALNavigator sharedNavigator];

    self.location = [navigator shift:[self location]
                             heading:[self shotDirection]
                            distance:speedFactor];

    self.flownDistance += speedFactor;

    if (self.flownDistance >= self.maximalRange) {
        [self remove];
        return;
    }

    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];

    for (HALBouy *bouy in [bouyPool all])
    {
        if (bouy == self.shooter)
            continue;

        if ([navigator distanceFrom:[self location]
                                 to:[bouy location]] <= catchRadius) {
            if ([bouy hit]) {
                [self stop];
                [[HALBouyPool sharedBouyPool] deleteBouy:self];
                
                HALExplosion *explosion = [[HALExplosion alloc] initWithLocation:[self location]];
                [[HALBouyPool sharedBouyPool] addBouy:explosion];
                [explosion start];
                
                return;
            }
        }
    }
}

- (UIImage *)updatedImage:(CLLocationDirection)radarHeading
{
    CLLocationDirection rotationDegrees;
    
    CGSize size = self.bulletImage.size;
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context,
                          size.width / 2,
                          size.height / 2);
    
    rotationDegrees = oppositeDirection(correctDegrees(self.shotDirection - radarHeading));
    CGContextRotateCTM(context, degreesToRadians(rotationDegrees));
    CGContextDrawImage(context,
                       CGRectMake(-(size.width / 2),
                                  -(size.height / 2),
                                  size.width,
                                  size.height),
                       [self.bulletImage CGImage]);
    
    CGContextScaleCTM(context, 1, -1);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
