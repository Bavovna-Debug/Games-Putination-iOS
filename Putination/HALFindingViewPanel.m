//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
//

#import "HALFindingViewPanel.h"
#import "HALKernel.h"

@interface HALFindingViewPanel ()

@property (nonatomic, strong) UIImage *emergencyBoxImage;
@property (nonatomic, strong) UIImage *fuelCanisterImage;
@property (nonatomic, strong) UIImage *armoryBoxImage;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HALFindingViewPanel
{
    CGRect blowRectFrom;
    CGRect blowRectTo;
}

@synthesize emergencyBoxImage = _emergencyBoxImage;
@synthesize fuelCanisterImage = _fuelCanisterImage;
@synthesize armoryBoxImage = _armoryBoxImage;
@synthesize imageView = _imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    self.backgroundColor = [UIColor clearColor];

    CGSize blowSizeFrom = CGSizeMake(frame.size.width / 32,
                                     frame.size.width / 32);
    CGSize blowSizeTo = CGSizeMake(frame.size.width / 2,
                                   frame.size.width / 2);
    
    blowRectFrom = CGRectMake(frame.size.width / 2 - blowSizeFrom.width / 2,
                              frame.size.height / 2 - blowSizeFrom.height / 2,
                              blowSizeFrom.width,
                              blowSizeFrom.height);
    
    blowRectTo = CGRectMake(frame.size.width / 2 - blowSizeTo.width / 2,
                            frame.size.height / 2 - blowSizeFrom.height * 0.2f,
                            blowSizeTo.width,
                            blowSizeTo.height);
    
    self.emergencyBoxImage = [UIImage imageNamed:@"EmergencyBoxBaloon"];
    self.fuelCanisterImage = [UIImage imageNamed:@"FuelCanisterBaloon"];
    self.armoryBoxImage = [UIImage imageNamed:@"ArmoryBoxBaloon"];

    self.imageView = [[UIImageView alloc] initWithFrame:[self bounds]];
    [self addSubview:self.imageView];

    [self setHidden:YES];

    [[HALKernel sharedKernel] setFindingViewPanel:self];

    return self;
}

- (void)foundEmergencyBox
{
    [self.imageView setImage:self.emergencyBoxImage];
    
    [self startBaloon];
}

- (void)foundFuelCanister
{
    [self.imageView setImage:self.fuelCanisterImage];
    
    [self startBaloon];
}

- (void)foundArmoryBox
{
    [self.imageView setImage:self.armoryBoxImage];
    
    [self startBaloon];
}

- (void)startBaloon
{
    [self setHidden:NO];
    
    [self.imageView setFrame:blowRectFrom];
    [self.imageView setAlpha:0.8f];

    [UIView beginAnimations:nil
                    context:nil];
    [UIView setAnimationDuration:1.4f];
    
    [self.imageView setFrame:blowRectTo];
    [self.imageView setAlpha:0.0f];
    
    [UIView commitAnimations];

    [self performSelector:@selector(stopBaloon)
               withObject:nil
               afterDelay:1.4f];
}

- (void)stopBaloon
{
    [self setHidden:YES];
    [self.imageView setImage:nil];
}

@end
