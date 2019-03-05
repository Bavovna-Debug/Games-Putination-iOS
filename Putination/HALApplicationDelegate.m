//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "HALApplicationDelegate.h"
#import "HALKernel.h"
#import "HALMainViewController.h"
#import "HALNavigator.h"
#import "HALRadar.h"
#import "HALRadarViewController.h"

@interface HALApplicationDelegate () <UIApplicationDelegate>

@property (nonatomic, strong) HALMainViewController *mainViewController;
@property (nonatomic, strong) HALRadarViewController *radarViewController;

@end

@implementation HALApplicationDelegate

@synthesize mainViewController = _mainViewController;
@synthesize radarViewController = _radarViewController;

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[application setStatusBarHidden:NO];

    [application setIdleTimerDisabled:YES];

    NSString *deviceVersion = [[UIDevice currentDevice] systemVersion];
    UIColor *backgroundColor;
    if ([deviceVersion floatValue] < 7.0f) {
        backgroundColor = [UIColor lightGrayColor];
    } else {
        backgroundColor = [UIColor colorWithRed:0.867f
                                          green:0.890f
                                           blue:0.867f
                                          alpha:1.0f];
    }

    [[HALNavigator sharedNavigator] startNavigation];

    self.mainViewController = [[HALMainViewController alloc] init];
    [self.mainViewController.view setBackgroundColor:backgroundColor];

    self.radarViewController = [[HALRadarViewController alloc] init];
    [self.radarViewController.view setBackgroundColor:backgroundColor];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[HALRadar sharedRadar] wipeOutBattleField];
}

- (void)mainMenu
{
    [self.window setRootViewController:self.mainViewController];
}

- (void)startGame
{
    [self.window setRootViewController:self.radarViewController];
}

- (void)quitGame
{
    [self.window setRootViewController:self.mainViewController];
}

- (void)gameOver:(HALGameOverReason)reason
{
    [self quitGame];
    
    NSString *title;
    NSString *message;
    NSString *buttonLabel;
    
    switch (reason)
    {
        case HALGameOverReasonLife:
            title = NSLocalizedString(@"GAME_OVER_BECAUSE_OF_LIFE", nil);
            break;

        case HALGameOverReasonFuel:
            title = NSLocalizedString(@"GAME_OVER_BECAUSE_OF_FUEL", nil);
            break;

        case HALGameOverReasonOccupation:
            title = NSLocalizedString(@"GAME_OVER_ALL_CITIES_CAPTURED", nil);
            break;

        default:
            return;
    }

    message = NSLocalizedString(@"GAME_OVER_MESSAGE", nil);
    buttonLabel = NSLocalizedString(@"GAME_OVER_BUTTON_LABEL", nil);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:buttonLabel
                                              otherButtonTitles:nil,
                              nil];
    alertView.alertViewStyle = UIAlertViewStyleDefault;
    [alertView show];
    
    return;
}

@end
