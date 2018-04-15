//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "HALArmoryViewPanel.h"
#import "HALKernel.h"

@interface HALArmoryViewPanel ()

@property (nonatomic, strong) NSMutableArray *bullets;

@end

@implementation HALArmoryViewPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    self.backgroundColor = [UIColor colorWithRed:0.867f
                                           green:0.890f
                                            blue:0.867f
                                           alpha:1.0f];

    self.bullets = [[NSMutableArray alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"ArmoryBullet"];
    CGRect elementRect = CGRectMake(0,
                                    0,
                                    frame.size.height * (image.size.width / image.size.height),
                                    frame.size.height);
    for (int index = 0; index < 20; index++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:elementRect];
        [imageView setImage:image];
        [self addSubview:imageView];
        [self.bullets insertObject:imageView atIndex:index];
        
        elementRect.origin.x += elementRect.size.width;
    }
    
    [[HALKernel sharedKernel] setArmoryViewPanel:self];
        
    return self;
}

- (void)refreshDisplay
{
    for (UIImageView *imageView in self.bullets)
    {
        [imageView setAlpha:1.0f];
    }
}

- (void)hideBullet:(int)bulletId
{
    UIImageView *imageView = (UIImageView *)[self.bullets objectAtIndex:bulletId - 1];

    [UIView beginAnimations:nil
                    context:nil];
    [UIView setAnimationDuration:0.5f];

    [imageView setAlpha:0.0f];
    
    [UIView commitAnimations];
}

- (void)showBullet:(int)bulletId
{
    UIImageView *imageView = (UIImageView *)[self.bullets objectAtIndex:bulletId - 1];
    
    [UIView beginAnimations:nil
                    context:nil];
    [UIView setAnimationDuration:0.5f];
    
    [imageView setAlpha:1.0f];
    
    [UIView commitAnimations];
}

@end
