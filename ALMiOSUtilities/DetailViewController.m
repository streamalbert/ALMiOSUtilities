//
//  DetailViewController.m
//  ALMiOSUtilities
//
//  Created by Weichuan Tian on 8/23/15.
//  Copyright (c) 2015 Weichuan Tian. All rights reserved.
//

#import "DetailViewController.h"
#import "ZGTPolygonView.h"
#import "UIBezierPath+ZEPolygon.h"

@interface DetailViewController ()

@property (nonatomic) ZGTPolygonView *polygonView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];

    self.polygonView = [[ZGTPolygonView alloc] initWithFrame:CGRectMake(0.0, 100.0, 200.0, 200.0) image:nil numberOfSides:6 sideColor:[UIColor yellowColor] sideThicknessInPixels:10.0f];
    [self.view addSubview:self.polygonView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
