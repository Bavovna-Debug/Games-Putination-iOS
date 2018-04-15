//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "CoreLocation/CoreLocation.h"

#import "HALBouy.h"
#import "HALBouyPool.h"
#import "HALCannonBullet.h"
#import "HALNavigator.h"
#import "HALRadar.h"

@interface HALBouy ()

@property (nonatomic, strong) NSTimer *expireTimer;

@end

@implementation HALBouy

@synthesize running = _running;
@synthesize bouyType = _bouyType;
@synthesize location = _location;
@synthesize occupiedRadius = _occupiedRadius;
@synthesize needsDisplay = _needsDisplay;

@synthesize expireTimer = _expireTimer;
@synthesize imageView = _imageView;
@synthesize image = _image;

- (id)initWithType:(HALBouyType)bouyType
{
    self = [super init];
    if (self == nil)
        return nil;
    
    self.bouyType = bouyType;

    self.running = NO;
    
    self.placementRadius = 0.0f;
    self.occupiedRadius = 0.0f;
    self.needsDisplay = YES;
    
    switch (bouyType)
    {
        case HALBouyTypeEmergencyBox:
            self.placementRadius = 5.0f;
            self.occupiedRadius = 5.0f;
            self.image = [UIImage imageNamed:@"EmergencyBox"];
            break;
         
        case HALBouyTypeArmoryBox:
            self.placementRadius = 5.0f;
            self.occupiedRadius = 5.0f;
            self.image = [UIImage imageNamed:@"ArmoryBox"];
            break;
            
        case HALBouyTypeFuelCanister:
            self.placementRadius = 5.0f;
            self.occupiedRadius = 5.0f;
            self.image = [UIImage imageNamed:@"FuelCanister"];
            break;

        default:
            break;
    }
    
    self.expireTimer = nil;
    self.imageView = [[UIImageView alloc] init];
    
    return self;
}

- (void)start
{
    self.running = YES;
    
    [self startExpiration];
}

- (void)stop
{
    self.running = NO;
    
    [self stopExpiration];
}

- (void)remove
{
    [[HALBouyPool sharedBouyPool] deleteBouy:self];
}

- (void)startExpiration
{
    switch (self.bouyType)
    {
        case HALBouyTypeEmergencyBox:
        case HALBouyTypeFuelCanister:
        case HALBouyTypeArmoryBox:
        {
            NSTimeInterval expirationTime = 780.0f + ((float)arc4random() / RAND_MAX) * 240.0f;
            self.expireTimer = [NSTimer scheduledTimerWithTimeInterval:expirationTime
                                                                target:self
                                                              selector:@selector(expirationHandler)
                                                              userInfo:nil
                                                               repeats:NO];
            break;
        }
            
        default:
            break;
    }
}

- (void)stopExpiration
{
    if (self.expireTimer != nil) {
        [self.expireTimer invalidate];
        self.expireTimer = nil;
    }
}

- (void)expirationHandler
{
    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];
    [bouyPool deleteBouy:self];
}

- (CGSize)bouyFullSize
{
    return [self.imageView.image size];
}

- (UIImage *)updatedImage:(CLLocationDirection)radarHeading
{
    UIImage *image = self.image;
    if (self.image != nil)
        self.image = nil;
    return image;
}

- (CGPoint)pointOnRadar
{
    if (self.imageView.superview == nil)
        return CGPointMake(0, 0);

    HALNavigator *navigator = [HALNavigator sharedNavigator];
    HALRadar *radar = [HALRadar sharedRadar];
    
    CGSize playAreaSize = [radar playAreaSize];
    
    CLLocationDirection headingRelative = [navigator headingFrom:[navigator deviceCoordinate]
                                                              to:[self location]
                                                      forHeading:[navigator deviceHeading]];
    
    CLLocationDistance distance = [navigator distanceFrom:[navigator deviceCoordinate] to:[self location]];

    CGFloat x = distance * cos((90.0f - headingRelative) * M_PI / 180);
    CGFloat y = distance * sin((90.0f - headingRelative) * M_PI / 180);

    CGPoint bouyCenter;
    
    bouyCenter.x = playAreaSize.width / 2;
    bouyCenter.y = playAreaSize.height / 2;//- (playAreaSize.width / 2);
    bouyCenter.x += x;
    bouyCenter.y -= y;
    
    return bouyCenter;
}

- (CGRect)frameOnRadar
{
    if (self.imageView.superview == nil)
        return CGRectMake(0, 0, 0, 0);

    const CGFloat scaleFactor = 0.1f;

    CGPoint bouyCenter = [self pointOnRadar];
    CGSize bouyFullSize = [self bouyFullSize];

    CGRect bouyFrame;

    bouyFrame.size.width = bouyFullSize.width * scaleFactor;
    bouyFrame.size.height = bouyFullSize.height * scaleFactor;
    
    bouyFrame.origin.x = bouyCenter.x - (bouyFrame.size.width / 2);
    bouyFrame.origin.y = bouyCenter.y - (bouyFrame.size.height / 2);
    
    return bouyFrame;
}

- (BOOL)hit { return NO; }

- (void)shot:(CLLocationDirection)shotDirection
       range:(CLLocationDistance)maximalRange
{
    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];
    
    HALCannonBullet *bullet = [[HALCannonBullet alloc] initWithShot:self
                                                     fromCoordinate:[self location]
                                                      shotDirection:shotDirection
                                                       maximalRange:maximalRange];

    [bouyPool addBouy:bullet];
    [bullet start];
}

@end
