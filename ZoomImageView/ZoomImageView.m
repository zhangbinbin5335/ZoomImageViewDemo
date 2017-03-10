//
//  ZoomImageView.m
//  ZoomImageViewDemo
//
//  Created by zhangbinbin on 16/4/6.
//  Copyright © 2016年 zhangbinbin. All rights reserved.
//

#import "ZoomImageView.h"

@interface ZoomImageView ()<UIScrollViewDelegate>
// show image
@property (nonatomic, strong) UIImageView* imageView;

@end

@implementation ZoomImageView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        
        self.maximumZoomScale = 3.0;//default 3.0
        self.delegate = self;
        [self addSubview:self.imageView];
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    _imageView.frame = [self centerFrameFromImage:_imageView.image];
}

-(void)dealloc{
    self.delegate = nil;
    NSLog(@"dealloc");
}

#pragma mark -- get&set
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(doubleTapClick:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.numberOfTouchesRequired = 1;
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(singleTapClick:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        
        //双击失败之后，才会出发单击事件
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(longPress:)];
        
        _imageView.gestureRecognizers = @[doubleTap,singleTap,longPress];
    }
    return _imageView;
}

-(void)setContentMode:(UIViewContentMode)contentMode{
    
  [super setContentMode:contentMode];
  
  _imageView.contentMode = contentMode;
}

-(void)setImagePath:(NSString *)imagePath{
    
    UIImage* image = [UIImage imageWithContentsOfFile:imagePath];
    
    if (image) {
        _imageView.image = image;
    }
}

# pragma mark - UIScrollViewDelegate
- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

- (void) scrollViewDidZoom:(UIScrollView *)scrollView{
    [self centerScrollViewContents];
}

#pragma mark -- Gesture Evetn
- (void) doubleTapClick:(UIGestureRecognizer*)sender{
    CGPoint point = [sender locationInView:_imageView];
    
    [self zoomInZoomOut:point];
}

- (void) singleTapClick:(UIGestureRecognizer*)sender{
  __weak ZoomImageView* weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    
    ZoomImageView* strongSelf = weakSelf;
    if (strongSelf -> _onSingleTap)
    {
      strongSelf -> _onSingleTap(@{});
    }
  });
}

-(void)longPress:(UILongPressGestureRecognizer*)sender{
  if (sender.state == UIGestureRecognizerStateEnded){
    __weak ZoomImageView* weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
      
      ZoomImageView* strongSelf = weakSelf;
      if (strongSelf -> _onLongPress)
      {
        strongSelf -> _onLongPress(@{});
      }
    });
  }
}

#pragma mark -- 实现缩放功能
- (void) zoomInZoomOut:(CGPoint)point
{
    CGFloat newZoomScale = self.zoomScale > (self.maximumZoomScale/2)?
                            self.minimumZoomScale:
                            self.maximumZoomScale;
    
    CGSize scrollViewSize = self.bounds.size;
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = point.x - (w / 2.0f);
    CGFloat y = point.y - (h / 2.0f);
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self zoomToRect:rectToZoomTo animated:YES];
}

#pragma mark - Compute the new size of image relative to width(window)
- (CGRect) centerFrameFromImage:(UIImage*) image
{
    if(!image) return CGRectZero;

    CGSize size =  image.size ;
    CGSize scrollViewSize = self.bounds.size;

    CGFloat W = 0.0;
    CGFloat H = 0.0;

    if(size.width > scrollViewSize.width ||
      size.height > scrollViewSize.height){

      CGFloat ratio = MIN(scrollViewSize.width / size.width,
                          scrollViewSize.height / size.height);

      W = ratio * size.width * self.zoomScale;
      H = ratio * size.height * self.zoomScale;
    }else if (size.width < scrollViewSize.width &&
            size.height > scrollViewSize.height) {
      W = size.width;
      H = size.height * W / size.width;
    }else if (size.height < scrollViewSize.height &&
            size.width > scrollViewSize.width) {
      H = size.height;
      W = size.width * H / size.height;
    }else{
      W = scrollViewSize.width;
      H = size.height * W / size.width;
    }

    //长宽比特别大的情况，调整缩放倍数
    CGFloat scale = MAX(self.maximumZoomScale,
                      MAX(scrollViewSize.width/W, scrollViewSize.height/H));
    self.maximumZoomScale  = scale;

    return  CGRectMake(MAX(0, (scrollViewSize.width-W)/2),
                     MAX(0, (scrollViewSize.height-H)/2),
                     W,
                     H);
}

- (void)centerScrollViewContents{
    
    CGSize boundsSize = self.bounds.size;
    CGRect contentsFrame = _imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    _imageView.frame = contentsFrame;
}

@end
