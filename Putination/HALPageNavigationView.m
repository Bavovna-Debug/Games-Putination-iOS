//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
//

#import "HALApplicationDelegate.h"
#import "HALPageNavigationView.h"

@interface HALPageNavigationView ()

@property (nonatomic, strong) UIButton *startGameButton;
@property (nonatomic, strong) UIButton *pageLeftButton;
@property (nonatomic, strong) UIButton *pageRightButton;

@end

@implementation HALPageNavigationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;

    NSString *startGameText = NSLocalizedString(@"START_GAME", nil);
    
    UIFont *startGameButtonFont = [UIFont systemFontOfSize:18.0];
    
    UIImage *startGameButtonImage = [UIImage imageNamed:@"StartGameButton"];
    UIImage *pageLeftButtonImage = [UIImage imageNamed:@"PageLeft"];
    UIImage *pageRightButtonImage = [UIImage imageNamed:@"PageRight"];
    
    self.startGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.startGameButton setFrame:CGRectMake((frame.size.width - startGameButtonImage.size.width / 2) / 2,
                                              frame.size.height - startGameButtonImage.size.height / 2,
                                              startGameButtonImage.size.width / 2,
                                              startGameButtonImage.size.height / 2)];
    [self.startGameButton setBackgroundImage:startGameButtonImage
                                    forState:UIControlStateNormal];
    [self.startGameButton setTitleColor:[UIColor whiteColor]
                               forState:UIControlStateNormal];
    [self.startGameButton.titleLabel setFont:startGameButtonFont];
    [self.startGameButton setTitle:startGameText
                          forState:UIControlStateNormal];
    
    self.pageLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pageLeftButton setFrame:CGRectMake(0,
                                             frame.size.height - pageLeftButtonImage.size.height / 2,
                                             pageLeftButtonImage.size.width / 2,
                                             pageLeftButtonImage.size.height / 2)];
    [self.pageLeftButton setBackgroundImage:pageLeftButtonImage
                                    forState:UIControlStateNormal];
  
    self.pageRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pageRightButton setFrame:CGRectMake(frame.size.width - pageRightButtonImage.size.width / 2,
                                              frame.size.height - pageRightButtonImage.size.height / 2,
                                              pageRightButtonImage.size.width / 2,
                                              pageRightButtonImage.size.height / 2)];
    [self.pageRightButton setBackgroundImage:pageRightButtonImage
                                    forState:UIControlStateNormal];
    
    [self addSubview:self.startGameButton];
    [self addSubview:self.pageLeftButton];
    [self addSubview:self.pageRightButton];
    
    [self.startGameButton addTarget:self
                             action:@selector(didTouchStartGameButton)
                   forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)setPagingLeft:(Boolean)left
                right:(Boolean)right
{
    [self.pageLeftButton setAlpha:(left) ? 1.0f : 0.25f];
    [self.pageRightButton setAlpha:(right) ? 1.0f : 0.25f];
}

- (void)didTouchStartGameButton
{
    HALApplicationDelegate *application = (HALApplicationDelegate *)[[UIApplication sharedApplication] delegate];
    [application startGame];
}

- (void)drawRect:(CGRect)rect
{
    UIImage *backgroundImage = [UIImage imageNamed:@"NavigationViewBackgroundPhone"];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        backgroundImage = [UIImage imageNamed:@"NavigationViewBackgroundPad"];
    } else {
        backgroundImage = [UIImage imageNamed:@"NavigationViewBackgroundPhone"];
    }
    [backgroundImage drawInRect:rect];
}

@end
