//
//  ViewController.m
//  ZoomImageViewDemo
//
//  Created by zhangbinbin on 2017/3/10.
//  Copyright © 2017年 zhangbinbin. All rights reserved.
//

#import "ViewController.h"

#import "ZoomImageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUI];
}

#pragma mark -- UI
-(void)loadUI{
    
    UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    
    CGSize scrollViewSize = scrollView.bounds.size;
    
    ZoomImageView* zoom1 = [[ZoomImageView alloc]initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          scrollViewSize.width,
                                                                          scrollViewSize.height)];
    zoom1.imagePath = [[NSBundle mainBundle]pathForResource:@"test1" ofType:@"jpeg"];
    
    ZoomImageView* zoom2 = [[ZoomImageView alloc]initWithFrame:CGRectMake(scrollViewSize.width,
                                                                          0,
                                                                          scrollViewSize.width,
                                                                          scrollViewSize.height)];
    zoom2.imagePath = [[NSBundle mainBundle]pathForResource:@"test2" ofType:@"JPG"];
    
    ZoomImageView* zoom3 = [[ZoomImageView alloc]initWithFrame:CGRectMake(scrollViewSize.width * 2,
                                                                          0,
                                                                          scrollViewSize.width,
                                                                          scrollViewSize.height)];
    zoom3.imagePath = [[NSBundle mainBundle]pathForResource:@"test3" ofType:@"jpeg"];
    
    [scrollView addSubview:zoom1];
    [scrollView addSubview:zoom2];
    [scrollView addSubview:zoom3];
    
    scrollView.contentSize = CGSizeMake(scrollViewSize.width * 3, scrollViewSize.height);
    scrollView.pagingEnabled = YES;
    
    [self.view addSubview:scrollView];
}

@end
