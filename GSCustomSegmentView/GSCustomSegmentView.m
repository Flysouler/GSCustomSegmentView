//
//  GSCustomSegmentView.m
//  GSCustomSegmentView
//
//  Created by guoshuai on 16/5/3.
//  Copyright © 2016年 swiftTest. All rights reserved.
//

#import "GSCustomSegmentView.h"


#define SHAKETIME 0.5

#define TITLE_FONT 16

#define COMMON_TAG 11

@interface GSCustomSegmentView ()

// 控件宽度,
@property (nonatomic, assign) CGFloat viewWidth;
/**
 *  控件高度
 */
@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, strong) NSMutableArray *labMenuArray;

/**
 *  每个 label 的宽度
 */
@property (nonatomic, assign) CGFloat labelWidth;
/**
 *  label 的高度
 */
@property (nonatomic, assign)  CGFloat labelHeight;

/**
 *  选择之后高亮显示的 view
 */
@property (nonatomic, strong) UIView *heightView;

@property (nonatomic, strong) UIView *clipView;

/**
 *  白色 view 所在位置
 */
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) NSMutableArray *topLabelMenuArr;


@property (nonatomic, strong) NSMutableArray *btnsArr;

/**
 *  block
 */
@property (nonatomic, copy) selectedOptionBlock optionBlock;

@end

@implementation GSCustomSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _viewWidth = frame.size.width;
        _viewHeight = frame.size.height;
        
        _shakeAnimationTime = SHAKETIME;
        
    }
    return self;
}

- (void)initData {
    if (!_titles) {
        _titles = [NSArray arrayWithObjects:@"title1", @"title2", @"title3", nil];
    }
    
    if (!_normalTitleColor) {
        _normalTitleColor = [UIColor blackColor];
    }
    
    if (!_selectedTitleColor) {
        _selectedTitleColor = [UIColor whiteColor];
    }

    if (!_heightColor) {
        _heightColor = [UIColor redColor];
    }
    
    if (!_titlesFont) {
        _titlesFont = [UIFont systemFontOfSize:TITLE_FONT];
    }
    
    if (!_labMenuArray) {
        _labMenuArray = [NSMutableArray arrayWithCapacity:_titles.count];
    }
    
    if (!_topLabelMenuArr) {
        _topLabelMenuArr = [NSMutableArray arrayWithCapacity:_titles.count];
    }
    
    if (!_btnsArr) {
        _btnsArr = [[NSMutableArray alloc] initWithCapacity:_titles.count];
    }
    
    _labelWidth = _viewWidth / _titles.count;
    _labelHeight = _viewHeight;
}

- (void)initLabel {
    for (NSString *title in _titles) {
        UILabel *label = [self createdLabelWithColor:_normalTitleColor title:title];
        [self addSubview:label];
        
        [_labMenuArray addObject:label];
    }
    
    _heightView = [[UIView alloc] init];
    _heightView.backgroundColor = _heightColor;
    _heightView.layer.cornerRadius = 10;
    _heightView.layer.masksToBounds = YES;
    [self addSubview:_heightView];
}

- (void)initTopView {
    _topView = [[UIView alloc] init];
    _topView.clipsToBounds = YES;
    [self addSubview:_topView];
    
    _clipView = [[UIView alloc] init];
    for (NSString *title in _titles) {
        UILabel *label = [self createdLabelWithColor:_selectedTitleColor title:title];
        [_clipView addSubview:label];
        
        [_topLabelMenuArr addObject:label];
    }
    
    [_topView addSubview:_clipView];
    
    
}

- (void)addButtons {
    for (NSInteger index = 0; index < _titles.count; index++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = index*COMMON_TAG;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnsArr addObject:btn];
        
        [self addSubview:btn];
        
    }
}

- (void)buttonClick:(UIButton *)btn {
    NSInteger tag = btn.tag / COMMON_TAG;
    if (_optionBlock && tag < _titles.count) {
        _optionBlock(tag, _titles[tag]);
    }
    
    CGRect framess = [self returnViewRectWithIndex:tag];
    CGRect changeFrame = [self returnViewRectWithIndex:-tag];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:_shakeAnimationTime animations:^{
        _heightView.frame = framess;
        _topView.frame = framess;
        _clipView.frame = changeFrame;
        
    } completion:^(BOOL finished) {
        [weakSelf shankeAnimatWithView:_heightView duration:0.1];
        
    }];
    
}

- (void)shankeAnimatWithView:(UIView *)view duration:(CGFloat)duration {
    CALayer *viewlayer = view.layer;
    
    CGPoint position = viewlayer.position;
    CGPoint point1 = CGPointMake(position.x + 2, position.y);
    CGPoint point2 = CGPointMake(position.x - 2, position.y);
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
    anima.fromValue = [NSValue valueWithCGPoint:point1];
    anima.toValue = [NSValue valueWithCGPoint:point2];
    anima.duration = duration;
    anima.autoreverses = YES;
    anima.repeatCount = 1;
    
    [viewlayer addAnimation:anima forKey:@"shakeAnima"];
}

- (void)selectedOptionBlock:(selectedOptionBlock)block {
    if (block) {
        _optionBlock = block;
    }
}

- (CGRect)returnViewRectWithIndex:(NSInteger)index {
    return CGRectMake(_labelWidth*index, 0, _labelWidth, _labelHeight);
}

- (UILabel *)createdLabelWithColor:(UIColor *)color title:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.font = _titlesFont;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = color;
    
    return label;
}




- (void)layoutSubviews {
    
    // 初始化数据
    [self initData];
    // 添加 label
    [self initLabel];
    // 添加顶层的 view
    [self initTopView];
    
    // 添加按钮 响应点击事件
    [self addButtons];

    CGRect rect = CGRectMake(0, 0, _labelWidth, _labelHeight);
    _heightView.frame = rect;
    _topView.frame = rect;
    _clipView.frame = rect;
    
    for (NSInteger index = 0; index < _titles.count; index++) {
        CGRect frame = CGRectMake(_labelWidth*index, 0, _labelWidth, _labelHeight);
        
        UILabel *blackLabel = _labMenuArray[index];
        blackLabel.frame = frame;
        
        UILabel *whiteLab = _topLabelMenuArr[index];
        whiteLab.frame = frame;
        
        UIButton *btn = _btnsArr[index];
        btn.frame = frame;
    }
}




@end
