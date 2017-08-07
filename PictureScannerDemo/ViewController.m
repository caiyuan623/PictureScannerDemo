//
//  ViewController.m
//  PictureScannerDemo
//
//  Created by lemo on 2017/8/7.
//  Copyright © 2017年 MyCompany. All rights reserved.
//

#import "ViewController.h"
#import "ScanPictureViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray * imgArray;

@end

@implementation ViewController

-(NSMutableArray *)imageArray{
    if(!_imageArray){
        _imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageArray;
}

- (NSArray *)imgArray{
    if (!_imgArray) {
        _imgArray = @[@"1",@"2",@"3",@"640"];
    }
    return _imgArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //图片view
    CGFloat imgWidth = (KScreenWidth - 3*kLeftGap)/3;
    
    for(int i = 0; i < self.imgArray.count; i++){
        
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kLeftGap + (7.5 + imgWidth) * (i % 3), 50 + 12 + (i / 3)*(imgWidth + 7.5), imgWidth, imgWidth)];
        imgView.image = [UIImage imageNamed:self.imgArray[i]];
       
        UITapGestureRecognizer * tt = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigImage:)];
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:tt];
        imgView.tag = 100 + i;
        [self.view addSubview:imgView];
    
    }
}


- (void)showBigImage:(UITapGestureRecognizer *)tap{
  
    ScanPictureViewController *scanVC = [[ScanPictureViewController alloc] init];
     scanVC.imageArray = self.imgArray;
    scanVC.currentIndex = tap.view.tag - 100;
    scanVC.view.alpha = 0;    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:scanVC.view];
    
    [self addChildViewController:scanVC];
    
    [UIView animateWithDuration:0.5 animations:^{
        scanVC.view.alpha = 1;
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
