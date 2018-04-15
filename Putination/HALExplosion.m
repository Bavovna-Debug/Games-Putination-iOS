//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "HALBouyPool.h"
#import "HALExplosion.h"

@interface HALExplosion ()

@property (nonatomic, strong) UIImage *explosionImage;

@end;

@implementation HALExplosion

@synthesize explosionImage = _explosionImage;

- (id)initWithLocation:(CLLocationCoordinate2D)explosionLocation
{
    self = [super initWithType:HALBouyTypeExplosion];
    if (self == nil)
        return nil;

    self.placementRadius = 0.0f;
    self.occupiedRadius = 0.0f;
    
    self.location = explosionLocation;
    
    self.explosionImage = [UIImage imageNamed:@"Explosion"];
    
    return self;
}

- (void)start
{
    [super start];

    NSTimeInterval timeInterval = 0.0f;
    
    for (int i = 0; i < 8; i++)
    {
        [self performSelector:@selector(animateExplosion)
                   withObject:nil
                   afterDelay:timeInterval];
        timeInterval += 0.12f;
    }
    
    [self performSelector:@selector(finishExplosion)
               withObject:nil
               afterDelay:timeInterval];
}

- (void)animateExplosion
{
    [self.imageView setFrame:[self frameOnRadar]];

    self.imageView.image = self.explosionImage;
    
    [self.imageView setAlpha:1.0f];
    
    [UIView beginAnimations:nil
                    context:nil];
    [UIView setAnimationDuration:0.12f];
    
    [self.imageView setAlpha:0.2f];
    
    [UIView commitAnimations];
}

- (void)finishExplosion
{
    [[HALBouyPool sharedBouyPool] deleteBouy:self];
}

@end
