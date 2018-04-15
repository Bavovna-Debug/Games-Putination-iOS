//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "HALIntroductionViewController.h"

@interface HALIntroductionViewController ()

@property (nonatomic, strong) UIScrollView *introductionScrollView;

@end

@implementation HALIntroductionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self == nil)
        return nil;

    self.index = 0;
   
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    assert(self.introductionScrollView == nil);

    UILabel *gameTitleLabel;
    UILabel *gameSubtitleLabel;
    UILabel *introductionTextLabel;

    NSString *gameTitleText;
    NSString *gameSubtitleText;
    NSString *gameDescriptionText;
    
    gameTitleText = NSLocalizedString(@"GAME_TITLE", nil);
    gameSubtitleText = NSLocalizedString(@"GAME_SUBTITLE", nil);
    gameDescriptionText = NSLocalizedStringFromTable(@"GAME_INTRODUCTION",
                                                     @"Introduction",
                                                     nil);
    
    CGFloat gameTitleFontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 32.0f : 24.0f;
    CGFloat gameSubtitleFontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 24.0f : 18.0f;
    CGFloat gameDescriptionFontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 20.0f : 14.0f;

    UIFont *gameTitleFont = [UIFont systemFontOfSize:gameTitleFontSize];
    UIFont *gameSubtitleFont = [UIFont systemFontOfSize:gameSubtitleFontSize];
    UIFont *gameDescriptionFont = [UIFont systemFontOfSize:gameDescriptionFontSize];
    
    CGFloat margin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 24 : 12;

    CGRect textFrame = CGRectMake(margin,
                                  margin,
                                  self.applicationFrame.size.width - 2 * margin,
                                  0);
    CGSize textRequiredSize;
    
    textRequiredSize = [gameTitleText sizeWithFont:gameTitleFont
                                 constrainedToSize:CGSizeMake(textFrame.size.width, CGFLOAT_MAX)
                                     lineBreakMode:NSLineBreakByWordWrapping];
    textFrame.size.height = textRequiredSize.height;
    
    gameTitleLabel = [[UILabel alloc] initWithFrame:textFrame];
    [gameTitleLabel setText:gameTitleText];
    [gameTitleLabel setFont:gameTitleFont];
    [gameTitleLabel setTextColor:[UIColor redColor]];
    [gameTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [gameTitleLabel setNumberOfLines:0];
    [gameTitleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    textFrame.origin.y += textFrame.size.height + margin;
    
    textRequiredSize = [gameSubtitleText sizeWithFont:gameSubtitleFont
                                    constrainedToSize:CGSizeMake(textFrame.size.width, CGFLOAT_MAX)
                                        lineBreakMode:NSLineBreakByWordWrapping];
    textFrame.size.height = textRequiredSize.height;

    gameSubtitleLabel = [[UILabel alloc] initWithFrame:textFrame];
    [gameSubtitleLabel setText:gameSubtitleText];
    [gameSubtitleLabel setFont:gameSubtitleFont];
    [gameSubtitleLabel setTextColor:[UIColor redColor]];
    [gameSubtitleLabel setTextAlignment:NSTextAlignmentCenter];
    [gameSubtitleLabel setNumberOfLines:0];
    [gameSubtitleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    textFrame.origin.y += textFrame.size.height + margin;
    
    textRequiredSize = [gameDescriptionText sizeWithFont:gameDescriptionFont
                                       constrainedToSize:CGSizeMake(textFrame.size.width, CGFLOAT_MAX)
                                           lineBreakMode:NSLineBreakByWordWrapping];
    textFrame.size.height = textRequiredSize.height;

    introductionTextLabel = [[UILabel alloc] initWithFrame:textFrame];
    [introductionTextLabel setText:gameDescriptionText];
    [introductionTextLabel setFont:gameDescriptionFont];
    [introductionTextLabel setTextColor:[UIColor darkTextColor]];
    [introductionTextLabel setTextAlignment:NSTextAlignmentLeft];
    [introductionTextLabel setNumberOfLines:0];
    [introductionTextLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    self.introductionScrollView = [[UIScrollView alloc] initWithFrame:self.applicationFrame];
    self.introductionScrollView.backgroundColor = [UIColor clearColor];
    self.introductionScrollView.contentSize = CGSizeMake(self.applicationFrame.size.width,
                                                         textFrame.origin.y + textFrame.size.height + 2 * margin);
    [self.introductionScrollView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.introductionScrollView];

    [self.introductionScrollView addSubview:gameTitleLabel];
    [self.introductionScrollView addSubview:gameSubtitleLabel];
    [self.introductionScrollView addSubview:introductionTextLabel];
    
    [self.pageNavigationView setPagingLeft:NO right:YES];
}

@end
