//
//  ScanScrollImageView.m
//  PictureScannerDemo
//
//  Created by lemo on 2017/8/7.
//  Copyright © 2017年 MyCompany. All rights reserved.
//

#import "ScanScrollImageView.h"

@implementation ScanScrollImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapAction:)];
        [_imageView addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)doTapAction:(UITapGestureRecognizer *)sender
{
    if (self.successBlock) {
        self.successBlock();
    }
}

@end
