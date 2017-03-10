//
//  ZoomImageView.h
//  ZoomImageViewDemo
//
//  Created by zhangbinbin on 16/4/6.
//  Copyright © 2016年 zhangbinbin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ZoomImageViewEventBlock)(NSDictionary *body);

@interface ZoomImageView : UIScrollView

@property (nonatomic, copy) NSString* imagePath;//image path
@property (nonatomic, copy) ZoomImageViewEventBlock onSingleTap;//单击回调
@property (nonatomic, copy) ZoomImageViewEventBlock onLongPress;//长按回调

@end
