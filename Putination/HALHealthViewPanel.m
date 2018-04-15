//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "HALHealthViewPanel.h"
#import "HALKernel.h"

@interface HALHealthViewPanel ()

@property (nonatomic, strong) NSMutableArray *hearts;
@property (nonatomic, strong) UILabel *fuelLevelLabel;

@end

@implementation HALHealthViewPanel
{
    int numberOfHearts;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;

    self.backgroundColor = [UIColor colorWithRed:0.867f
                                           green:0.890f
                                            blue:0.867f
                                           alpha:1.0f];
    
    numberOfHearts = 5;
    
    self.hearts = [[NSMutableArray alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"Heart"];
    CGRect elementRect = CGRectMake(0,
                                    0,
                                    frame.size.height,
                                    frame.size.height);
    for (int index = 0; index < numberOfHearts; index++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:elementRect];
        [imageView setImage:image];
        [self addSubview:imageView];
        [self.hearts insertObject:imageView atIndex:index];
        
        elementRect.origin.x += elementRect.size.width;
    }
    
    elementRect.origin.x = frame.size.width - frame.size.height;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:elementRect];
    [imageView setImage:[UIImage imageNamed:@"FuelTank"]];
    [self addSubview:imageView];
    
    elementRect.size.width = 80;
    elementRect.origin.x -= elementRect.size.width;
    elementRect.origin.x -= 4;
    self.fuelLevelLabel = [[UILabel alloc] initWithFrame:elementRect];
    [self.fuelLevelLabel setBackgroundColor:[UIColor clearColor]];
    [self.fuelLevelLabel setTextColor:[UIColor blackColor]];
    [self.fuelLevelLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:self.fuelLevelLabel];
    
    [[HALKernel sharedKernel] setHealthViewPanel:self];
    
    [self refreshDisplay];
    
    return self;
}

- (void)refreshDisplay
{
    HALKernel *kernel = [HALKernel sharedKernel];
    int heartId = [kernel playerLife] / numberOfHearts;
    int heartHealth = [kernel playerLife] % numberOfHearts;
    
    [UIView beginAnimations:nil
                    context:nil];
    [UIView setAnimationDuration:0.5f];
    
    for (NSInteger index = 0; index < [self.hearts count]; index++)
    {
        UIImageView *imageView = (UIImageView *)[self.hearts objectAtIndex:index];
        if (index == heartId) {
            [imageView setAlpha:0.2f * heartHealth];
        } else if (index < heartId) {
            [imageView setAlpha:1.0f];
        } else if (index > heartId) {
            [imageView setAlpha:0.0f];
        }
    }
    
    [UIView commitAnimations];

    [self.fuelLevelLabel setText:[NSString stringWithFormat:@"%d", [kernel fuelLevel]]];
}

@end
