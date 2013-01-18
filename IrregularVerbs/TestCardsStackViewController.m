//
//  TestCardsStackViewController.m
//  IrregularVerbs
//
//  Created by Rafa Barberá Córdoba on 16/01/13.
//  Copyright (c) 2013 Oswaldo Rubio. All rights reserved.
//

#import "TestCardsStackViewController.h"
#import "TestCardViewController.h"
#import "VerbsStore.h"
#import "Verb.h"

@interface TestCardsStackViewController ()

@property (nonatomic, strong) NSArray *testVerbs;

@end

@implementation TestCardsStackViewController

- (id)init {
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:@{UIPageViewControllerOptionInterPageSpacingKey:@12.0f}];
    if (self) {
        self.dataSource = self;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.testVerbs = [[VerbsStore sharedStore] testSubSet];
    self.title = [[VerbsStore sharedStore] selectedTestType];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setViewControllers:@[[self testCardViewAtIndex:0]]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    for (Verb *verb in self.testVerbs) {
        [verb resetCurrentTest];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([viewController isMemberOfClass:[TestScoreCardViewController class]]) {
        return nil;
    }
    if ([viewController isMemberOfClass:[TestCardViewController class]]) {
        TestCardViewController *current = (TestCardViewController *)viewController;
        UIViewController *next = [self testCardViewAtIndex:[self.testVerbs indexOfObject:current.verb]+1];
        if (!next) {
            TestScoreCardViewController * tsc = [[TestScoreCardViewController alloc] init];
            tsc.dataSource = self;
            return tsc;
        }
        return next;
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ([viewController isMemberOfClass:[TestScoreCardViewController class]]) {
        return [self testCardViewAtIndex:self.testVerbs.count-1];
    }
    if ([viewController isMemberOfClass:[TestCardViewController class]]) {
        TestCardViewController *current = (TestCardViewController *)viewController;
        return [self testCardViewAtIndex:[self.testVerbs indexOfObject:current.verb]-1];
    }
    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.testVerbs.count+1;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    TestCardViewController *current = (TestCardViewController *)pageViewController.childViewControllers[0];
    return [self.testVerbs indexOfObject:current.verb];
}

- (UIViewController *)testCardViewAtIndex:(int)index {
    TestCardViewController *vc=nil;
    if((index>=0)&&(index< self.testVerbs.count)){
        vc = [[TestCardViewController alloc] init];
        vc.verb = self.testVerbs[index];
    }
    return vc;   
}

- (NSArray *)verbsForTestScoreCardView:(TestScoreCardViewController *)testScoreCardView {
    return self.testVerbs;
}

@end