//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
//

#import "HALHelpViewController.h"

@interface HALHelpViewController ()

@property (nonatomic, strong) UIScrollView *introductionScrollView;

@end

@implementation HALHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self == nil)
        return nil;
    
    self.index = 1;
  
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    assert(self.introductionScrollView == nil);
    
    self.introductionScrollView = [[UIScrollView alloc] initWithFrame:self.applicationFrame];
    self.introductionScrollView.backgroundColor = [UIColor clearColor];
    self.introductionScrollView.contentSize = CGSizeMake(self.applicationFrame.size.width, 0);
    [self.introductionScrollView setBackgroundColor:[UIColor whiteColor]];

    [self.view addSubview:self.introductionScrollView];

    [self insertParagraph:[UIImage imageNamed:@"City"]
                     name:NSLocalizedStringFromTable(@"GAME_DESCRIPTION_CITY_TITLE", @"Description", nil)
                     memo:NSLocalizedStringFromTable(@"GAME_DESCRIPTION_CITY", @"Description", nil)];
    [self insertParagraph:[UIImage imageNamed:@"DescriptionPlayer"]
                     name:NSLocalizedStringFromTable(@"GAME_DESCRIPTION_PLAYER_TITLE", @"Description", nil)
                     memo:NSLocalizedStringFromTable(@"GAME_DESCRIPTION_PLAYER", @"Description", nil)];
    [self insertParagraph:[UIImage imageNamed:@"DescriptionTank"]
                     name:NSLocalizedStringFromTable(@"GAME_DESCRIPTION_THEIR_TANK_TITLE", @"Description", nil)
                     memo:NSLocalizedStringFromTable(@"GAME_DESCRIPTION_THEIR_TANK", @"Description", nil)];
    [self insertParagraph:[UIImage imageNamed:@"DescriptionTurret"]
                     name:NSLocalizedStringFromTable(@"GAME_DESCRIPTION_TURRET_TITLE", @"Description", nil)
                     memo:NSLocalizedStringFromTable(@"GAME_DESCRIPTION_TURRET", @"Description", nil)];
    [self insertParagraph:[UIImage imageNamed:@"DescriptionSupplyAircraft"]
                     name:NSLocalizedStringFromTable(@"GAME_DESCRIPTION_SUPPLY_AIRCRAFT_TITLE", @"Description", nil)
                     memo:NSLocalizedStringFromTable(@"GAME_DESCRIPTION_SUPPLY_AIRCRAFT", @"Description", nil)];
    [self insertParagraph:[UIImage imageNamed:@"EmergencyBox"]
                     name:NSLocalizedStringFromTable(@"GAME_DESCRIPTION_EMERGENCY_BOX_TITLE", @"Description", nil)
                     memo:NSLocalizedStringFromTable(@"GAME_DESCRIPTION_EMERGENCY_BOX", @"Description", nil)];
    [self insertParagraph:[UIImage imageNamed:@"FuelCanister"]
                     name:NSLocalizedStringFromTable(@"GAME_DESCRIPTION_FUEL_CANISTER_TITLE", @"Description", nil)
                     memo:NSLocalizedStringFromTable(@"GAME_DESCRIPTION_FUEL_CANISTER", @"Description", nil)];
    [self insertParagraph:[UIImage imageNamed:@"ArmoryBox"]
                     name:NSLocalizedStringFromTable(@"GAME_DESCRIPTION_ARMORY_BOX_TITLE", @"Description", nil)
                     memo:NSLocalizedStringFromTable(@"GAME_DESCRIPTION_ARMORY_BOX", @"Description", nil)];

    [self.pageNavigationView setPagingLeft:YES right:NO];
}

- (void)insertParagraph:(UIImage *)image
                   name:(NSString *)name
                   memo:(NSString *)memo
{
    CGFloat nameFontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 20.0f : 16.0f;
    CGFloat memoFontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 18.0f : 12.0f;
    
    UIFont *nameFont = [UIFont boldSystemFontOfSize:nameFontSize];
    UIFont *memoFont = [UIFont systemFontOfSize:memoFontSize];

    CGFloat margin = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 24 : 12;
    CGFloat betweener = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 48 : 24;
    
    CGSize contentSize = [self.introductionScrollView contentSize];
    
    CGRect imageFrame = CGRectMake(margin,
                                   contentSize.height + margin,
                                   image.size.width / 2,
                                   image.size.height / 2);
    CGRect memoFrame = CGRectMake(imageFrame.origin.x + imageFrame.size.width + margin,
                                  contentSize.height + margin,
                                  contentSize.width - imageFrame.origin.x - imageFrame.size.width - 3 * margin,
                                  0);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
    [imageView setImage:image];
 
    CGRect nameFrame = memoFrame;
    NSAttributedString *attributedText;

    attributedText = [[NSAttributedString alloc] initWithString:name
                                                     attributes:@{NSFontAttributeName:nameFont}];
    CGRect nameRect = [attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth(nameFrame), CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
    nameFrame.size = nameRect.size;

    UILabel *nameLabel = [[UILabel alloc] initWithFrame:nameFrame];
    [nameLabel setText:name];
    [nameLabel setFont:nameFont];
    [nameLabel setTextColor:[UIColor darkTextColor]];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setNumberOfLines:0];
    
    memoFrame.origin.y += nameFrame.size.height;

    attributedText = [[NSAttributedString alloc] initWithString:memo
                                                     attributes:@{NSFontAttributeName:memoFont}];
    CGRect memoRect = [attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth(memoFrame), CGFLOAT_MAX)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
    memoFrame.size = memoRect.size;

    UILabel *memoLabel = [[UILabel alloc] initWithFrame:memoFrame];
    [memoLabel setText:memo];
    [memoLabel setFont:memoFont];
    [memoLabel setTextColor:[UIColor darkTextColor]];
    [memoLabel setTextAlignment:NSTextAlignmentLeft];
    [memoLabel setNumberOfLines:0];
 
    contentSize.height += MAX(imageFrame.size.height, nameFrame.size.height + memoFrame.size.height);
    contentSize.height += margin + betweener;
    
    [self.introductionScrollView setContentSize:contentSize];

    [self.introductionScrollView addSubview:imageView];
    [self.introductionScrollView addSubview:nameLabel];
    [self.introductionScrollView addSubview:memoLabel];
}

@end
