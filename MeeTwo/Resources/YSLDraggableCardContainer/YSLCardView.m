//
//  YSLCardView.m
//  Crew-iOS
//
//  Created by yamaguchi on 2015/10/23.
//  Copyright © 2015年 h.yamaguchi. All rights reserved.
//

#import "YSLCardView.h"

@implementation YSLCardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupCardView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCardView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupCardView];
    }
    return self;
}

- (void)setupCardView {
    // Shadow
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOpacity = 0.33;
//    self.layer.shadowOffset = CGSizeMake(0, 0);
//    self.layer.shadowRadius = 0.5;
    
    self.layer.borderColor = [[UIColor colorWithRed:185.0/255.0 green:227.0/255.0 blue:232.0/255.0 alpha:1.0] CGColor];
    self.layer.borderWidth = 1.0f;
    //self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.cornerRadius = 7.0;
}

@end
