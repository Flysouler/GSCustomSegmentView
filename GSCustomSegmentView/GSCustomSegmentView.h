//
//  GSCustomSegmentView.h
//  GSCustomSegmentView
//
//  Created by guoshuai on 16/5/3.
//  Copyright © 2016年 swiftTest. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^selectedOptionBlock)(NSInteger index, NSString *title);

@interface GSCustomSegmentView : UIView
/**
 *  标题数组: 用来设置每个选项的标题名称的
 */
@property (nonatomic, strong) NSArray *titles;

/**
 *  标题的正常颜色
 */
@property (nonatomic, strong) UIColor *normalTitleColor;

/**
 *  标题高亮的颜色
 */
@property (nonatomic, strong) UIColor *selectedTitleColor;

/**
 *  高亮时的背景颜色
 */
@property (nonatomic, strong) UIColor *heightColor;

/**
 *  标题字号
 */
@property (nonatomic, strong) UIFont *titlesFont;


/**
 *  动画时间
 */
@property (nonatomic, assign) CGFloat shakeAnimationTime;


/**
 *  选择某一选项所执行的动作
 */
- (void)selectedOptionBlock:(selectedOptionBlock)block;

@end
