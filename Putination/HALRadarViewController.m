//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
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

    NSString *deviceVersion = [[UIDevice currentDevice] systemVersion];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat statusBar;
    if ([deviceVersion floatValue] < 7.0f) {
        statusBar = 0;
    } else {
        statusBar = 20;
    }

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        healthPanelRect = CGRectMake(0,
                                     statusBar,
                                     768,
                                     32);
        armoryPanelRect = CGRectMake(0,
                                     statusBar + 32,
                                     768,
                                     48);
        radarRect = CGRectMake(0,
                               statusBar + 80,
                               768,
                               1024 - statusBar - 32 - 48);
        exitButtonRect = CGRectMake(32,
                                    screenSize.height - 32 - 128,
                                    128,
                                    128);
        schemaButtonRect = CGRectMake(608,
                                      screenSize.height - 32 - 128,
                                      128,
                                      128);
        fireButtonRect = CGRectMake(256,
                                    screenSize.height - 32 - 128,
                                    256,
                                    128);
    } else {
        healthPanelRect = CGRectMake(0,
                                     statusBar,
                                     320,
                                     24);
        armoryPanelRect = CGRectMake(0,
                                     statusBar + 24,
                                     320,
                                     24);
        radarRect = CGRectMake(0,
                               statusBar + 48,
                               320,
                               screenSize.height - statusBar - 24 - 24);
        exitButtonRect = CGRectMake(16,
                                    screenSize.height - 16 - 64,
                                    64,
                                    64);
        schemaButtonRect = CGRectMake(240,
                                      screenSize.height - 16 - 64,
                                      64,
                                      64);
        fireButtonRect = CGRectMake(96,
                                    screenSize.height - 16 - 64,
                                    128,
                                    64);
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
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
            break;
            
        case HALSchemaNight:
            [self.radarViewPanel setBackgroundColor:[UIColor blackColor]];
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
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

@end
