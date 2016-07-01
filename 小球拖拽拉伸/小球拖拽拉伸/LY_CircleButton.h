//
//  LY_CircleButton.h
//  小球拖拽拉伸
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^blockName)(UIButton *button);
@interface LY_CircleButton : UIButton

/**
 *  最大拖动范围,默认为100
 */
@property (nonatomic,assign) NSInteger maxDistance;
/**
 *  点击事件block
 */
@property (nonatomic,assign) blockName clickName;

@end
