//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
//

#import "HALRadarGrid.h"

@interface HALRadarGrid ()

@property (nonatomic, strong) CAShapeLayer *crossShapeLayer;
@property (nonatomic, strong) CAShapeLayer *bazookaShapeLayer;

@end

@implementation HALRadarGrid

@synthesize crossShapeLayer =_crossShapeLayer;
@synthesize bazookaShapeLayer = _bazookaShapeLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
    
    self.backgroundColor = [UIColor clearColor];

    CGRect bounds = [self bounds];
    
    CGSize size = bounds.size;
    CGPoint center = CGPointMake(bounds.size.width / 2,
                                 bounds.size.height / 2);
    
    // Cross
    
    self.crossShapeLayer = [CAShapeLayer layer];
    [self.crossShapeLayer setBounds:bounds];
    [self.crossShapeLayer setPosition:CGPointMake(bounds.size.width / 2,
                                                  bounds.size.height / 2)];
    [self.crossShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [self.crossShapeLayer setLineWidth:1.0f];
    [self.crossShapeLayer setLineJoin:kCALineJoinRound];
    [self.crossShapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:4],
                                              [NSNumber numberWithInt:2], nil]];
    
    CGMutablePathRef crossPath = CGPathCreateMutable();
    
    CGPoint pointsCrossNorth[] = {
        CGPointMake(center.x,
                    center.y - size.height * 0.05f),
        CGPointMake(center.x,
                    size.height * 0.12f)
    };
    
    CGPoint pointsCrossWest[] = {
        CGPointMake(center.x - size.width * 0.04f,
                    center.y),
        CGPointMake(size.width * 0.12f,
                    center.y)
    };
    
    CGPoint pointsCrossEast[] = {
        CGPointMake(center.x + size.width * 0.04f,
                    center.y),
        CGPointMake(size.width * 0.88f,
                    center.y)
    };
    
    CGPathAddLines(crossPath, nil, pointsCrossNorth, 2);
    CGPathAddLines(crossPath, nil, pointsCrossWest, 2);
    CGPathAddLines(crossPath, nil, pointsCrossEast, 2);
    
    [self.crossShapeLayer setPath:crossPath];
    
    CGPathRelease(crossPath);
    
    // Bazooka
    
    self.bazookaShapeLayer = [CAShapeLayer layer];
    [self.bazookaShapeLayer setBounds:bounds];
    [self.bazookaShapeLayer setPosition:CGPointMake(bounds.size.width / 2,
                                                    bounds.size.height / 2)];
    [self.bazookaShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [self.bazookaShapeLayer setStrokeColor:[[UIColor lightGrayColor] CGColor]];
    [self.bazookaShapeLayer setLineWidth:1.0f];
    [self.bazookaShapeLayer setLineJoin:kCALineJoinRound];
    [self.bazookaShapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:4],
                                         [NSNumber numberWithInt:2], nil]];
    
    CGMutablePathRef bazookaPath = CGPathCreateMutable();
    
    CGPoint pointsBazookaLeft[] = {
        CGPointMake(center.x * 0.8f,
                    0),
        CGPointMake(center.x,
                    center.y)
    };
    
    CGPoint pointsBazookaRight[] = {
        CGPointMake(center.x * 1.2f,
                    0),
        CGPointMake(center.x,
                    center.y)
    };
    
    CGPathAddLines(bazookaPath, nil, pointsBazookaLeft, 2);
    CGPathAddLines(bazookaPath, nil, pointsBazookaRight, 2);
    
    [self.bazookaShapeLayer setPath:bazookaPath];
    
    CGPathRelease(bazookaPath);

    [self.crossShapeLayer setHidden:YES];
    [self.bazookaShapeLayer setHidden:YES];

    [self.layer addSublayer:self.crossShapeLayer];
    [self.layer addSublayer:self.bazookaShapeLayer];

    [self cross:YES];
    
    return self;
}

- (void)setSchema:(HALSchema)schema
{
    switch (schema)
    {
        case HALSchemaDay:
            [self.crossShapeLayer setStrokeColor:[[UIColor colorWithRed:0.643f
                                                                  green:0.784f
                                                                   blue:0.776f
                                                                  alpha:1.0f] CGColor]];
            break;
            
        case HALSchemaNight:
            [self.crossShapeLayer setStrokeColor:[[UIColor colorWithRed:0.035f
                                                                  green:0.369f
                                                                   blue:0.102f
                                                                  alpha:1.0f] CGColor]];
            break;
    }
}

- (void)switchOff
{
    [self cross:NO];
    [self bazooka:NO];
}

- (void)switchToCross
{
    [self cross:YES];
    [self bazooka:NO];
}

- (void)switchToBazooka
{
    //[self cross:NO];
    //[self bazooka:YES];
}

- (void)cross:(BOOL)on
{
    if (on) {
        [self.crossShapeLayer setHidden:NO];
    } else {
        [self.crossShapeLayer setHidden:YES];
    }
}

- (void)bazooka:(BOOL)on
{
    if (on) {
        if ([self.bazookaShapeLayer animationForKey:@"linePhase"] == nil)
        {
            CABasicAnimation *dashAnimation;
            dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
            
            [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
            [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
            [dashAnimation setDuration:2.0f];
            [dashAnimation setRepeatCount:HUGE_VALF];
            
            [self.bazookaShapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
        }
        
        [self.bazookaShapeLayer setHidden:NO];
    } else {
        if ([self.bazookaShapeLayer animationForKey:@"linePhase"] != nil)
        {
            [self.bazookaShapeLayer removeAnimationForKey:@"linePhase"];
        }
        
        [self.bazookaShapeLayer setHidden:YES];
    }
}

@end
