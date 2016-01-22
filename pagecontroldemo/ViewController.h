//
//  ViewController.h
//  pagecontroldemo
//
//  Created by roboca on 15/6/16.
//  Copyright (c) 2015年 roboca. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *myScrollView;
@property (strong, nonatomic) UIPageControl *myPageControl;

@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) NSTimer *myTimer;

@end

