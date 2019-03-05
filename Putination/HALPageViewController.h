//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HALPageNavigationView.h"

@interface HALPageViewController : UIViewController

@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) CGRect navigationFrame;
@property (assign, nonatomic) CGRect applicationFrame;

@property (strong, nonatomic) HALPageNavigationView *pageNavigationView;

@end
