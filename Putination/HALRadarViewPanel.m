//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "CoreLocation/CoreLocation.h"

#import "HALFindingViewPanel.h"
#import "HALRadar.h"
#import "HALRadarGrid.h"
#import "HALRadarView.h"
#import "HALRadarViewPanel.h"

@interface HALRadarViewPanel ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HALRadarView *radarView;
@property (nonatomic, strong) HALRadarGrid *radarGrid;
@property (nonatomic, strong) HALFindingViewPanel *findingViewPanel;

@end

@implementation HALRadarViewPanel

@synthesize scrollView = _scrollView;
@synthesize radarView = _radarView;
@synthesize radarGrid = _radarGrid;
@synthesize findingViewPanel = _findingViewPanel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;
   
    self.backgroundColor = [UIColor clearColor];

    CGRect radarFrame = self.bounds;
    
    CGSize playAreaSize = [[HALRadar sharedRadar] playAreaSize];
    playAreaSize.height *= radarFrame.size.height / radarFrame.size.width;
    [[HALRadar sharedRadar] setPlayAreaSize:playAreaSize];

    self.findingViewPanel = [[HALFindingViewPanel alloc] initWithFrame:[self bounds]];
    [self addSubview:self.findingViewPanel];

    self.scrollView = [[UIScrollView alloc] initWithFrame:radarFrame];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = playAreaSize;
    self.scrollView.center = CGPointMake(radarFrame.size.width / 2,
                                         radarFrame.size.height / 2);
    [self addSubview:self.scrollView];

    self.radarView = [[HALRadarView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    playAreaSize.width,
                                                                    playAreaSize.height)];
    [self.scrollView addSubview:self.radarView];

    self.radarGrid = [[HALRadarGrid alloc] initWithFrame:radarFrame];
    [self addSubview:self.radarGrid];

    self.scrollView.minimumZoomScale = 0.2f;
    self.scrollView.maximumZoomScale = 4.0f;
    self.scrollView.zoomScale = 0.4f;
    
    [self centerScrollViewContents];
    
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.radarView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerScrollViewContents];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self centerScrollViewContents];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self centerScrollViewContents];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self centerScrollViewContents];
}

- (void)centerScrollViewContents
{
    CGSize contentSize = self.scrollView.contentSize;
    CGSize viewSize = self.frame.size;

    [self.scrollView setContentOffset:CGPointMake((contentSize.width / 2) - (viewSize.width / 2),
                                                  (contentSize.height / 2) - (viewSize.height / 2))];
}

- (void)setSchema:(HALSchema)schema
{
    [self.radarGrid setSchema:schema];
}

@end