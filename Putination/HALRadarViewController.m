//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
//

#import "HALApplicationDelegate.h"
#import "HALArmoryViewPanel.h"
#import "HALBouyPool.h"
#import "HALHealthViewPanel.h"
#import "HALKernel.h"
#import "HALNavigator.h"
#import "HALRadar.h"
#import "HALRadarViewController.h"
#import "HALRadarViewPanel.h"

@interface HALRadarViewController ()

@property (nonatomic, strong) HALHealthViewPanel *healthViewPanel;
@property (nonatomic, strong) HALArmoryViewPanel *armoryViewPanel;
@property (nonatomic, strong) HALRadarViewPanel *radarViewPanel;
@property (nonatomic, strong) UIButton *exitButton;
@property (nonatomic, strong) UIButton *schemaButton;
@property (nonatomic, strong) UIButton *fireButton;

@end

@implementation HALRadarViewController

@synthesize healthViewPanel = _healthViewPanel;
@synthesize armoryViewPanel = _armoryViewPanel;
@synthesize radarViewPanel = _radarViewPanel;
@synthesize exitButton = _exitButton;
@synthesize schemaButton = _schemaButton;
@synthesize fireButton = _fireButton;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self == nil)
        return nil;
    
    [[HALKernel sharedKernel] setRadarViewController:self];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    assert(self.healthViewPanel == nil);
    assert(self.armoryViewPanel == nil);
    assert(self.radarViewPanel == nil);
    assert(self.exitButton == nil);
    assert(self.schemaButton == nil);
    assert(self.fireButton == nil);
    
    CGRect healthPanelRect;
    CGRect armoryPanelRect;
    CGRect radarRect;
    CGRect exitButtonRect;
    CGRect schemaButtonRect;
    CGRect fireButtonRect;

    CGFloat statusBar = 0.0f;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        healthPanelRect = CGRectMake(0.0f,
                                     statusBar,
                                     CGRectGetWidth(self.view.frame),
                                     32.0f);
        armoryPanelRect = CGRectMake(0.0f,
                                     statusBar + 32.0f,
                                     CGRectGetWidth(self.view.frame),
                                     48.0f);
        radarRect = CGRectMake(0.0f,
                               statusBar + 80.0f,
                               CGRectGetWidth(self.view.frame),
                               CGRectGetHeight(self.view.frame) - statusBar - 32.0f - 48.0f);
        exitButtonRect = CGRectMake((CGRectGetWidth(self.view.frame) / 2.0f) - 288.0f,
                                    CGRectGetHeight(self.view.frame) - 32.0f - 128.0f,
                                    128.0f,
                                    128.0f);
        schemaButtonRect = CGRectMake((CGRectGetWidth(self.view.frame) / 2.0f) + 160.0f,
                                      CGRectGetHeight(self.view.frame) - 32.0f - 128.0f,
                                      128.0f,
                                      128.0f);
        fireButtonRect = CGRectMake((CGRectGetWidth(self.view.frame) / 2.0f) - 128.0f,
                                    CGRectGetHeight(self.view.frame) - 32.0f - 128.0f,
                                    256.0f,
                                    128.0f);
    }
    else
    {
        CGFloat screenHeight = CGRectGetHeight(UIScreen.mainScreen.nativeBounds);
        if ((screenHeight != 1136) && (screenHeight != 1334) && (screenHeight != 1920) && (screenHeight != 2208))
            statusBar += 36.0f;

        healthPanelRect = CGRectMake(0.0f,
                                     statusBar,
                                     CGRectGetWidth(self.view.frame),
                                     24.0f);
        armoryPanelRect = CGRectMake(0.0f,
                                     statusBar + 24.0f,
                                     CGRectGetWidth(self.view.frame),
                                     24.0f);
        radarRect = CGRectMake(0.0f,
                               statusBar + 24.0f + 24.0f,
                               CGRectGetWidth(self.view.frame),
                               CGRectGetHeight(self.view.frame) - statusBar - 24.0f - 24.0f);

        exitButtonRect = CGRectMake((CGRectGetWidth(self.view.frame) / 2.0f) - 144.0f,
                                    CGRectGetHeight(self.view.frame) - 16.0f - 64.0f,
                                    64.0f,
                                    64.0f);
        schemaButtonRect = CGRectMake((CGRectGetWidth(self.view.frame) / 2.0f) + 80.0f,
                                      CGRectGetHeight(self.view.frame) - 16.0f - 64.0f,
                                      64.0f,
                                      64.0f);
        fireButtonRect = CGRectMake((CGRectGetWidth(self.view.frame) / 2.0f) - 64.0f,
                                    CGRectGetHeight(self.view.frame) - 16.0f - 64.0f,
                                    128.0f,
                                    64.0f);
    }
    
    self.healthViewPanel = [[HALHealthViewPanel alloc] initWithFrame:healthPanelRect];
    self.armoryViewPanel = [[HALArmoryViewPanel alloc] initWithFrame:armoryPanelRect];
    self.radarViewPanel = [[HALRadarViewPanel alloc] initWithFrame:radarRect];

    HALBouyPool *bouyPool = [HALBouyPool sharedBouyPool];
    for (HALBouy *bouy in [bouyPool all])
    {
        [[HALRadar sharedRadar] registerOnRadar:bouy];
    }
    
    UIColor *buttonsColor = [UIColor clearColor];
    
    self.exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.exitButton setFrame:exitButtonRect];
    [self.exitButton setBackgroundColor:buttonsColor];
    [self.exitButton setImage:[UIImage imageNamed:@"ExitButton"]
                     forState:UIControlStateNormal];
    
    self.schemaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.schemaButton setFrame:schemaButtonRect];
    [self.schemaButton setBackgroundColor:buttonsColor];
    [self.schemaButton setImage:[UIImage imageNamed:@"SchemaButton"]
                       forState:UIControlStateNormal];
 
    self.fireButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fireButton setFrame:fireButtonRect];
    [self.fireButton setBackgroundColor:buttonsColor];
    [self.fireButton setImage:[UIImage imageNamed:@"FireButton"]
                     forState:UIControlStateNormal];

    [self.view addSubview:self.healthViewPanel];
    [self.view addSubview:self.armoryViewPanel];
    [self.view addSubview:self.radarViewPanel];
    [self.view addSubview:self.exitButton];
    [self.view addSubview:self.schemaButton];
    [self.view addSubview:self.fireButton];

    [self.exitButton addTarget:self
                        action:@selector(didTouchExitButton)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.schemaButton addTarget:self
                          action:@selector(didTouchSchemaButton)
                forControlEvents:UIControlEventTouchUpInside];

    [self.fireButton addTarget:self
                        action:@selector(didTouchFireButton)
              forControlEvents:UIControlEventTouchUpInside];

    [self setSchema:HALSchemaDay];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    HALKernel *kernel = [HALKernel sharedKernel];
    HALRadar *radar = [HALRadar sharedRadar];

    [kernel reset];
    [radar start];
    [radar prepareBattleField];
    
    [self.healthViewPanel refreshDisplay];
    [self.armoryViewPanel refreshDisplay];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    HALRadar *radar = [HALRadar sharedRadar];

    [radar wipeOutBattleField];
    [radar stop];
}

- (void)didTouchExitButton
{
    HALApplicationDelegate *application = (HALApplicationDelegate *)[[UIApplication sharedApplication] delegate];
    [application quitGame];
}

- (void)didTouchSchemaButton
{
    switch (schema)
    {
        case HALSchemaDay:
            [self setSchema:HALSchemaNight];
            break;
            
        case HALSchemaNight:
            [self setSchema:HALSchemaDay];
            break;
    }
}

- (void)didTouchFireButton
{
    HALKernel *kernel = [HALKernel sharedKernel];
    HALNavigator *navigator = [HALNavigator sharedNavigator];
    HALPlayer *player = [[HALBouyPool sharedBouyPool] player];
    
    if ([kernel playerCanShot]) {
        [player shot:[navigator deviceHeading]
               range:player.fireRadius];
    }
}

- (void)setSchema:(HALSchema)newSchema
{
    schema = newSchema;
    
    switch (schema)
    {
        case HALSchemaDay:
            [self.radarViewPanel setBackgroundColor:[UIColor whiteColor]];
            break;
            
        case HALSchemaNight:
            [self.radarViewPanel setBackgroundColor:[UIColor blackColor]];
            break;
    }

    [self.radarViewPanel setSchema:schema];
}

- (void)playerHitByMissle
{
    UIColor *normalColor = [self.radarViewPanel backgroundColor];
    
    [self.radarViewPanel setBackgroundColor:[UIColor redColor]];
    
    [UIView beginAnimations:nil
                    context:nil];
    [UIView setAnimationDuration:0.25f];
    
    [self.radarViewPanel setBackgroundColor:normalColor];
    
    [UIView commitAnimations];
}

- (BOOL)prefersStatusBarHidden
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return YES;
    }
    else
    {
        CGFloat screenHeight = CGRectGetHeight(UIScreen.mainScreen.nativeBounds);
        if ((screenHeight == 1136) || (screenHeight == 1334) || (screenHeight == 1920) || (screenHeight == 2208))
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
}

@end
