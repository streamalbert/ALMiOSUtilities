//
//  ZGTPolygonView.m
//  ALMiOSUtilities
//
//  Created by Weichuan Tian on 8/24/15.
//  Copyright (c) 2015 Weichuan Tian. All rights reserved.
//

#import "ZGTPolygonView.h"
#import "UIBezierPath+ZEPolygon.h"

@interface ZGTPolygonView ()

@property (nonatomic) NSUInteger numberOfSides;
@property (nonatomic) UIColor *sideColor;
@property (nonatomic) NSUInteger sideThicknessInPixels;

@end

@implementation ZGTPolygonView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image numberOfSides:(NSUInteger)numberOfSides sideColor:(UIColor *)sideColor sideThicknessInPixels:(CGFloat)sideThickness
{
    if (self = [super initWithFrame:frame]) {
//        _numberOfSides = numberOfSides;
//        _sideColor = sideColor;
//        _sideThicknessInPixels = sideThickness;

        UIImageView *maskedImageView = [[UIImageView alloc] initWithImage:image ? : [UIImage imageNamed:@"ZugataLogo.jpg"]];
        maskedImageView.contentMode = UIViewContentModeScaleAspectFill;
        UIBezierPath *nonagon = [UIBezierPath bezierPathWithPolygonInRect:CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) numberOfSides:numberOfSides];

        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = nonagon.CGPath;
        maskedImageView.layer.mask = shapeLayer;

        CAShapeLayer *shape = [CAShapeLayer layer];
        shape.frame = maskedImageView.bounds;
        shape.path = nonagon.CGPath;
        shape.lineWidth = sideThickness;
        shape.strokeColor = sideColor.CGColor;
        shape.fillColor = [UIColor clearColor].CGColor;
        [maskedImageView.layer addSublayer:shape];

        [self addSubview:maskedImageView];
    }
    return self;
}


@end
