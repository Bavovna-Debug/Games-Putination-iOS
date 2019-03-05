//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
//

#import "HALBouy.h"
#import "HALBouyPool.h"
#import "HALNavigator.h"
#import "HALRadar.h"
#import "HALRadarView.h"

@interface HALRadarView ()

@property (nonatomic, strong) NSTimer *radarTimer;

@end

@implementation HALRadarView
{
    CLLocationDirection lastHeading;
}

@synthesize radarTimer = _radarTimer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    self.backgroundColor = [UIColor clearColor];
    
    lastHeading = 0.0f;
    
    [[HALRadar sharedRadar] setView:self];

    self.radarTimer = nil;
    
    return self;
}

- (void)start
{
    self.radarTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f
                                                       target:self
                                                     selector:@selector(hearthbeatRadar)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void)stop
{
    [self.radarTimer invalidate];
    self.radarTimer = nil;
}

- (void)hearthbeatRadar
{
    [UIView beginAnimations:nil
                    context:nil];
    [UIView setAnimationDuration:0.2f];
    
    HALNavigator *navigator = [HALNavigator sharedNavigator];
    
    CLLocationDirection heading = [navigator deviceHeading];
    
    Boolean headingChanged = (heading != lastHeading);

    lastHeading = heading;
    
    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];
    for (HALBouy *bouy in [bouyPool all])
    {
        CGRect bouyFrame = [bouy frameOnRadar];

        if (headingChanged || bouy.needsDisplay) {
            bouy.needsDisplay = NO;
    
            UIImage *bouyImage = [bouy updatedImage:heading];
            if (bouyImage != nil) {
                [bouy.imageView setImage:bouyImage];
            }
        }
        
        [bouy.imageView setFrame:bouyFrame];
    }
    
    [UIView commitAnimations];
}

@end
