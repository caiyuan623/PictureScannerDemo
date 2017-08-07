//
//  ScanScrollImageView.h
//  PictureScannerDemo
//
//  Created by lemo on 2017/8/7.
//  Copyright © 2017年 MyCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SuccessTapBlock)();

@interface ScanScrollImageView : UIScrollView

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic,  copy)SuccessTapBlock successBlock;

@end
