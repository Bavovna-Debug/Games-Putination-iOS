//
//  Putination
//
//  Copyright © 2014-2019 Meine Werke. All rights reserved.
//

#import "HALPageNavigationView.h"
#import "HALPageViewController.h"

@implementation HALPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self == nil)
        return nil;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    assert(self.pageNavigationView == nil);

    CGRect bounds = [[UIScreen mainScreen] bounds];

    CGFloat navigationHeight = 80.0f;
    
    self.navigationFrame = CGRectMake(bounds.origin.x,
                                      bounds.origin.y + bounds.size.height - navigationHeight,
                                      bounds.size.width,
                                      navigationHeight);
    
    self.applicationFrame = CGRectMake(bounds.origin.x,
                                       bounds.origin.y,
                                       bounds.size.width,
                                       bounds.size.height - navigationHeight);
    
    self.pageNavigationView = [[HALPageNavigationView alloc] initWithFrame:self.navigationFrame];
    
    [self.view addSubview:self.pageNavigationView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

}

@end
