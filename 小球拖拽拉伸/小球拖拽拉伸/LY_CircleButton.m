//
//  LY_CircleButton.m
//  小球拖拽拉伸
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import "LY_CircleButton.h"

@interface LY_CircleButton()

//小圆
@property (nonatomic,strong) UIView *smallCircleView;

//轨迹layer
@property (nonatomic,strong) CAShapeLayer *shapeLayer;

//轨迹
@property (nonatomic,strong) UIBezierPath *path;

//gif数组
@property (nonatomic,strong) NSMutableArray<UIImage *> *images;


@end

@implementation LY_CircleButton


-(void)layoutSubviews{
    [super layoutSubviews];
    [self initUI];

}
/**
 *  初始化button控件以及属性设置
 */
-(void)initUI
{
    if(_maxDistance == 0){
        _maxDistance = 100;
    }
    self.layer.cornerRadius = self.bounds.size.width*0.5;
    self.layer.masksToBounds = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
    [self addGestureRecognizer:pan];
    
    self.smallCircleView.bounds = self.bounds;
    _smallCircleView.center = self.center;
    _smallCircleView.layer.cornerRadius = _smallCircleView.bounds.size.width / 2;
    
    [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - 懒加载
-(UIView *)smallCircleView{
    if(!_smallCircleView){
        _smallCircleView = [[UIView alloc] init];
        _smallCircleView.backgroundColor = self.backgroundColor;
        [self.superview insertSubview:_smallCircleView atIndex:0];//视图加到button父视图最底部
    }
    return _smallCircleView;
}
-(CAShapeLayer *)shapeLayer{
    if(!_shapeLayer){
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = self.backgroundColor.CGColor;
        [self.superview.layer insertSublayer:_shapeLayer below:_smallCircleView.layer];
    }
    return _shapeLayer;
}
-(NSMutableArray<UIImage *> *)images
{
    if(!_images){
        _images = [NSMutableArray array];
        for(int i = 1 ; i < 9 ; i++){
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
            [_images addObject:image];
        }
    }
    return _images;
}

-(void)setMaxDistance:(NSInteger)maxDistance{
    _maxDistance = maxDistance;
}
-(void)panGR:(UIPanGestureRecognizer *)sender
{
    CGPoint point = [sender translationInView:self.superview];
    
    CGFloat centerX = sender.view.center.x + point.x;
    CGFloat centerY = sender.view.center.y + point.y;
    
    sender.view.center = CGPointMake(centerX, centerY);
    
    [sender setTranslation:CGPointMake(0, 0) inView:self.superview];
    
    
    CGFloat distance = [self distanceWithPointA:self.center pointB:_smallCircleView.center];
    if(distance < _maxDistance){
        CGFloat radius = sender.view.bounds.size.width > sender.view.bounds.size.height ? sender.view.bounds.size.width *0.5 : sender.view.bounds.size.height*0.5;
        _smallCircleView.bounds = CGRectMake(0, 0, radius-distance/10, radius-distance/10);
        _smallCircleView.layer.cornerRadius = (radius-distance/10)*0.5;
        if(_smallCircleView.hidden == NO && distance>0){
            self.shapeLayer.path = [self pathWithBigCirCleView:self smallCirCleView:_smallCircleView].CGPath;
        }
    }else{
        [_shapeLayer removeFromSuperlayer];
        _shapeLayer = nil;
        _smallCircleView.hidden = YES;
    }
    
    if(sender.state == UIGestureRecognizerStateEnded){
        if(distance > _maxDistance){
            NSLog(@"拖动 ->销毁了");
            [self startDestroyAnimations];
            [self allKill];
        }else{
            [_shapeLayer removeFromSuperlayer];
            _shapeLayer = nil;
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.center = _smallCircleView.center;
            } completion:^(BOOL finished) {
                _smallCircleView.hidden = NO;
            }];
            
        }
    }
    
}


-(void)click
{
    self.clickName(self);
    [self startDestroyAnimations];
    [self allKill];
}

-(CGFloat)distanceWithPointA:(CGPoint)pointA pointB:(CGPoint)pointB{
    CGFloat x = pointA.x-pointB.x;
    CGFloat y = pointA.y-pointB.y;
    return sqrtf(x*x+y*y);
}

-(UIBezierPath *)pathWithBigCirCleView:(UIView *)bigCirCleView smallCirCleView:(UIView *)smallCirCleView
{
    CGPoint bigCenter = bigCirCleView.center;
    CGFloat bigX = bigCenter.x;
    CGFloat bigY = bigCenter.y;
    CGFloat bigRadius = bigCirCleView.bounds.size.width*0.5;
    
    CGPoint smallCenter = smallCirCleView.center;
    CGFloat smallX = smallCenter.x;
    CGFloat smallY = smallCenter.y;
    CGFloat smallRadius = smallCirCleView.bounds.size.width*0.5;
    
    CGFloat d = [self distanceWithPointA:smallCenter pointB:bigCenter];
    CGFloat sina = (bigX-smallX)/d;
    CGFloat cosa = (bigY-smallY)/d;
    
    CGPoint pointA = CGPointMake(smallX-smallRadius*cosa, smallY+smallRadius*sina);
    CGPoint pointB = CGPointMake(smallX+smallRadius*cosa, smallY-smallRadius*sina);
    CGPoint pointC = CGPointMake(bigX+bigRadius*cosa, bigY-bigRadius*sina);
    CGPoint pointD = CGPointMake(bigX-bigRadius*cosa, bigY+bigRadius*sina);
    
    CGPoint pointO = CGPointMake(pointA.x+d/2*sina, pointA.y+d/2*cosa);
    CGPoint pointP = CGPointMake(pointB.x+d/2*sina, pointB.y+d/2*cosa);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // A
    [path moveToPoint:pointA];
    // AB
    [path addLineToPoint:pointB];
    // 绘制BC曲线
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    // CD
    [path addLineToPoint:pointD];
    // 绘制DA曲线
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    return path;
    
}

-(void)startDestroyAnimations
{
    UIImageView *animaImageView = [[UIImageView alloc]initWithFrame:self.frame];
    animaImageView.animationImages = self.images;//images是装image的数组
    animaImageView.animationRepeatCount=1;
    animaImageView.animationDuration=0.5;
    [animaImageView startAnimating];
    [self.superview addSubview:animaImageView];
}
-(void)allKill
{
    [self removeFromSuperview];
    [_smallCircleView removeFromSuperview];
    [_shapeLayer removeFromSuperlayer];
    _smallCircleView = nil;
    _shapeLayer = nil;
}

@end
