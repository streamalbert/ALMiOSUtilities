//
//  STFFixSelectionViewController.m
//  ALMiOSUtilities
//
//  Created by Weichuan Tian on 11/27/15.
//  Copyright © 2015 Weichuan Tian. All rights reserved.
//

#import "STFFixSelectionViewController.h"
#import "STFDataServiceManager.h"
#import "STFDataModelFix.h"

@interface STFFixSelectionViewController ()

@property (nonatomic, copy) STFDataModelFix *currentFix;

@end

@implementation STFFixSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    __weak STFFixSelectionViewController *weakSelf = self;
    [[STFDataServiceManager sharedManager] fetchCurrentFixWithCompletion:^(STFDataModelFix *currentFix, NSError *error) {
        if (!error) {
            STFFixSelectionViewController *strongSelf = weakSelf;
            if (strongSelf) {
                strongSelf.currentFix = currentFix;
            }
        }
        else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
