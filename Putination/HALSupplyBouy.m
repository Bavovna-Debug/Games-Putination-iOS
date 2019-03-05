//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
//

#import "HALBouy.h"
#import "HALBouyPool.h"
#import "HALSupplyBouy.h"

@interface HALSupplyBouy ()

@property (nonatomic, assign) NSTimer *flowDownTimer;
@property (nonatomic, strong) HALBouy *thrownBouy;

@end

@implementation HALSupplyBouy

@synthesize flowDownTimer = _flowDownTimer;
@synthesize thrownBouy = _thrownBouy;

- (id)initWithThrownBouy:(HALBouy *)thrownBouy
{
    self = [super initWithType:HALBouyTypeSupplyObject];
    if (self == nil)
        return nil;
    
    self.placementRadius = 0.0f;
    self.occupiedRadius = 0.0f;
    self.thrownBouy = thrownBouy;
    
    self.imageView.image = [UIImage imageNamed:@"Parachute"];
    
    self.location = thrownBouy.location;

    self.flowDownTimer = nil;
    
    return self;
}

- (void)start
{
    [super start];
    
    self.flowDownTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f
                                                          target:self
                                                        selector:@selector(reachTheGround)
                                                        userInfo:nil
                                                         repeats:NO];
}

- (void)stop
{
    [super stop];
    
    if (self.flowDownTimer != nil) {
        [self.flowDownTimer invalidate];
        self.flowDownTimer = nil;
    }
}

- (void)reachTheGround
{
    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];

    [bouyPool deleteBouy:self];
    [bouyPool addBouy:self.thrownBouy];
    [self.thrownBouy start];
}

@end
