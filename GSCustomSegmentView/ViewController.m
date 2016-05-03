//
//  ViewController.m
//  GSCustomSegmentView
//
//  Created by guoshuai on 16/5/3.
//  Copyright © 2016年 swiftTest. All rights reserved.
//

#import "ViewController.h"

#import "GSCustomSegmentView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    GSCustomSegmentView *vess = [[GSCustomSegmentView alloc] initWithFrame:(CGRect){0,
        100,
        self.view.bounds.size.width,
        50}];
    vess.titlesFont = [UIFont systemFontOfSize:20];
    vess.titles = @[@"标题1", @"标题2", @"标题3", @"标题四", @"标题5"];
    [self.view addSubview:vess];
    [vess selectedOptionBlock:^(NSInteger index, NSString *title) {
        NSLog(@"%ld, title: %@", index, title);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
