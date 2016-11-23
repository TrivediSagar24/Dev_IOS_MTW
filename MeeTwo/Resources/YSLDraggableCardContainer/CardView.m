//
//  CardView.m
//  YSLDraggingCardContainerDemo
//
//  Created by yamaguchi on 2015/11/09.
//  Copyright © 2015年 h.yamaguchi. All rights reserved.
//

#import "CardView.h"

@implementation CardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _imageView = [[UIImageView alloc]init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.8);
    [self addSubview:_imageView];
    
    _button = [[UIButton alloc]init];
    _button.frame = CGRectMake(_imageView.frame.size.width-35, _imageView.frame.size.height-35, 30, 30);
    
    [_button setImage:[UIImage imageNamed:@"Icon-Profile"] forState:UIControlStateNormal];
    
    [self addSubview:_button];
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:_imageView.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(7.0, 7.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _imageView.bounds;
    maskLayer.path = maskPath.CGPath;
    _imageView.layer.mask = maskLayer;
    
    _selectedView = [[UIView alloc]init];
    _selectedView.frame = _imageView.frame;
    _selectedView.backgroundColor = [UIColor clearColor];
    _selectedView.alpha = 0.0;
    [_imageView addSubview:_selectedView];
    
    _label = [[UILabel alloc]init];
    _label.backgroundColor = [UIColor clearColor];
    _label.frame = CGRectMake(0, self.frame.size.height * 0.8, self.frame.size.width, self.frame.size.height * 0.13);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont fontWithName:@"inglobal-Bold" size:25];
    [self addSubview:_label];
    
    _detailLabel = [[UILabel alloc]init];
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.frame = CGRectMake(0, self.frame.size.height * 0.90, self.frame.size.width, self.frame.size.height * 0.1);
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.font = [UIFont fontWithName:@"inglobal" size:17];
    [self addSubview:_detailLabel];
}

@end
