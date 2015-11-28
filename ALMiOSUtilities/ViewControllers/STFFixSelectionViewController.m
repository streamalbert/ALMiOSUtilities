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

#import <MBProgressHUD/MBProgressHUD.h>

@interface STFFixSelectionViewController ()

@property (nonatomic, copy) STFDataModelFix *currentFix;

@end

@implementation STFFixSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Getting fixed...";
    __weak STFFixSelectionViewController *weakSelf = self;
    [[STFDataServiceManager sharedManager] fetchCurrentFixWithCompletion:^(STFDataModelFix *currentFix, NSError *error) {
        STFFixSelectionViewController *strongSelf = weakSelf;
        if (strongSelf) {
            // called back on main thread
            [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
            if (!error) {
                strongSelf.currentFix = currentFix;
            }
            else {
                NSLog(@"%@", error);
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
