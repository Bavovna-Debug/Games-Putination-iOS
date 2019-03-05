//
//  Putination
//
//  Copyright (c) 2014 Meine Werke. All rights reserved.
//

#import "HALHelpViewController.h"
#import "HALIntroductionViewController.h"
#import "HALMainViewController.h"
#import "HALPageViewController.h"

@interface HALMainViewController ()

@property (strong, nonatomic) UIPageViewController *pageController;
@property (nonatomic, strong) HALIntroductionViewController *introductionViewController;
@property (nonatomic, strong) HALHelpViewController *helpViewController;

@end

@implementation HALMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    assert(self.pageController == nil);
    assert(self.introductionViewController == nil);
    assert(self.helpViewController == nil);

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.introductionViewController = [[HALIntroductionViewController alloc] init];
    
    self.helpViewController = [[HALHelpViewController alloc] init];
    
    self.pageController =
    [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                  options:nil];
    
    self.pageController.dataSource = self;
    
    HALPageViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:YES
                                 completion:nil];
    
    [self addChildViewController:self.pageController];
    
    [[self view] addSubview:[self.pageController view]];
    
    [self.pageController didMoveToParentViewController:self];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [(HALPageViewController *)viewController index];
    
    if (index == 0)
        return nil;
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [(HALPageViewController *)viewController index];
    
    index++;
    
    if (index == 2) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (HALPageViewController *)viewControllerAtIndex:(NSUInteger)index
{
    switch (index)
    {
        case 0:
            return self.introductionViewController;
            break;

        case 1:
            return self.helpViewController;
            break;

        default:
            return nil;
    }
}

@end
