//
//  ScanPictureViewController.m
//  PictureScannerDemo
//
//  Created by lemo on 2017/8/7.
//  Copyright © 2017年 MyCompany. All rights reserved.
//

#import "ScanPictureViewController.h"
#import "ScanScrollImageView.h"

@interface ScanPictureViewController ()<UIScrollViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong)UIScrollView *mainScrollView;
@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong) ScanScrollImageView *lastImageView;

@property (nonatomic, strong) ScanScrollImageView * imgView;

@end

@implementation ScanPictureViewController

- (UIScrollView *)mainScrollView{
    if (_mainScrollView == nil) {
        self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        self.mainScrollView.delegate = self;
        self.mainScrollView.contentSize = CGSizeMake(KScreenWidth * _imageArray.count, KScreenHeight);
        self.mainScrollView.pagingEnabled = YES;
        self.mainScrollView.userInteractionEnabled = YES;
        self.mainScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _mainScrollView;
}

- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, KScreenHeight - 30, KScreenWidth, 30)];
        self.pageControl.numberOfPages = _imageArray.count;
        self.pageControl.currentPage = _currentIndex;
        [self.pageControl addTarget:self action:@selector(clickPageControlAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pageControl;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self creatSubViews];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScrollViewAction:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)creatSubViews{
    [self.view addSubview:self.mainScrollView];
    NSLog(@"self.imageArray:%@",self.imageArray);
    for (int i = 0; i < self.imageArray.count; i++) {
        ScanScrollImageView *scrollImageView = [[ScanScrollImageView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight)];
        scrollImageView.imageView.image = [UIImage imageNamed:_imageArray[i]];
        scrollImageView.delegate = self;
        scrollImageView.maximumZoomScale = 2.0;
        scrollImageView.minimumZoomScale = 0.5;
        
        //保存到本地相册
        scrollImageView.userInteractionEnabled=YES;
        UILongPressGestureRecognizer * longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapAction:)];
        [scrollImageView addGestureRecognizer:longTap];
        
        scrollImageView.successBlock = ^(){
            [UIView animateWithDuration:0.5 animations:^{
                self.view.alpha = 0;
            } completion:^(BOOL finished) {
                [self.view removeFromSuperview];
            }];
        };
        [self.mainScrollView addSubview:scrollImageView];
    }
    if (_currentIndex != 0) {
        _lastImageView = self.mainScrollView.subviews[_currentIndex];
    }
    self.mainScrollView.contentOffset = CGPointMake(KScreenWidth * _currentIndex, 0);
    
    
    if (_imageArray.count > 1) {
        [self.view addSubview:self.pageControl];
    }
}


#pragma mark -
- (void)touchScrollViewAction:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (void)clickPageControlAction:(UIPageControl *)pageControl{
    [self.mainScrollView setContentOffset:CGPointMake(KScreenWidth * pageControl.currentPage, 0) animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.mainScrollView) {
        NSInteger currentIndex = (long)(scrollView.contentOffset.x / KScreenWidth);
        self.pageControl.currentPage = currentIndex;
        
        ScanScrollImageView *imageScrollView = scrollView.subviews[currentIndex];
        if (imageScrollView != _lastImageView) {
            _lastImageView.zoomScale = 1;
            _lastImageView = imageScrollView;
        }
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    UIView *view = nil;
    if (scrollView.zoomScale <= 1) {
        view = scrollView.subviews[0];
        view.center = CGPointMake(scrollView.bounds.size.width / 2, scrollView.bounds.size.height / 2);
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    UIView *view = nil;
    if (scrollView != self.mainScrollView) {
        view = scrollView.subviews[0];
    }
    return view;
}

#pragma mark 长按保存图片到本地
- (void)longTapAction:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        //            保存到相册
        _imgView = (ScanScrollImageView *)gesture.view;
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"是否保存到相册"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"保存"
                                      otherButtonTitles:nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
        
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //            第一个参数是要保存的图片对象，第二个参数是操作后由self调用第三个参数的方法，第四个参数是传递给回调方法的信息
        UIImageWriteToSavedPhotosAlbum(_imgView.imageView.image, self, @selector(image:finishedSaveWithError:contextInfo:), nil);
        
    }
}
//保存图片到相册的回调方法
- (void)image:(UIImage *)image finishedSaveWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (error) {
        NSLog(@"保存失败：%@",error.localizedDescription);
    }else{
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"保存成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }
}


@end
