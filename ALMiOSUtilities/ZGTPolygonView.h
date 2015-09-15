//
//  ZGTPolygonView.h
//  ALMiOSUtilities
//
//  Created by Weichuan Tian on 8/24/15.
//  Copyright (c) 2015 Weichuan Tian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGTPolygonView : UIView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image numberOfSides:(NSUInteger)numberOfSides sideColor:(UIColor *)sideColor sideThicknessInPixels:(CGFloat)sideThickness;

@end
