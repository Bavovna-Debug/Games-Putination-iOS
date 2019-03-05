//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    HALGameOverReasonLife,
    HALGameOverReasonFuel,
    HALGameOverReasonOccupation
}
HALGameOverReason;

@interface HALApplicationDelegate : UIResponder

@property (nonatomic, strong) UIWindow *window;

- (void)mainMenu;

- (void)startGame;

- (void)quitGame;

- (void)gameOver:(HALGameOverReason)reason;

@end
