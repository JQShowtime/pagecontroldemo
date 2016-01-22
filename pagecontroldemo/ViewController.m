//
//  ViewController.m
//  pagecontroldemo
//
//  Created by roboca on 15/6/16.
//  Copyright (c) 2015年 roboca. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize myScrollView;
@synthesize myPageControl;
@synthesize imageArray;
@synthesize myTimer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    imageArray=[NSMutableArray arrayWithObjects: [UIImage imageNamed:@"lead_1"],[UIImage imageNamed:@"lead_2"],[UIImage imageNamed:@"lead_3.png"],nil];
    [self configScrollView];
}

-(void)touchscrollview
{
    NSLog(@"touch at %ld",(long)myPageControl.currentPage);
}

-(void)configScrollView
{

     //初始化UIScrollView，设置相关属性，均可在storyBoard中设置
     CGRect frame=CGRectMake(0, 0, 320, 568);
     myScrollView = [[UIScrollView alloc]initWithFrame:frame];    //scrollView的大小
     myScrollView.backgroundColor=[UIColor clearColor];
     myScrollView.pagingEnabled=YES;//以页为单位滑动，即自动到下一页的开始边界
     myScrollView.showsVerticalScrollIndicator=NO;
     myScrollView.showsHorizontalScrollIndicator=NO;//隐藏垂直和水平显示条
    [self.view addSubview:myScrollView];
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchscrollview)];
    tapgesture.cancelsTouchesInView = NO;
    [myScrollView addGestureRecognizer:tapgesture];

    self.myScrollView.delegate=self;
    UIImageView *firstView=[[UIImageView alloc] initWithImage:[imageArray lastObject]];
    CGFloat Width=self.myScrollView.frame.size.width;
    CGFloat Height=self.myScrollView.frame.size.height;
    firstView.frame=CGRectMake(0, 0, Width, Height);
    [self.myScrollView addSubview:firstView];
    //set the last as the first
    
    for (int i=0; i<[imageArray count]; i++) {
        UIImageView *subViews=[[UIImageView alloc] initWithImage:[imageArray objectAtIndex:i]];
        subViews.frame=CGRectMake(Width*(i+1), 0, Width, Height);
        [self.myScrollView addSubview: subViews];
    }
    
    UIImageView *lastView=[[UIImageView alloc] initWithImage:[imageArray objectAtIndex:0]];
    lastView.frame=CGRectMake(Width*(imageArray.count+1), 0, Width, Height);
    [self.myScrollView addSubview:lastView];
    //set the first as the last
    
    [self.myScrollView setContentSize:CGSizeMake(Width*(imageArray.count+2), Height)];
    [self.view addSubview:self.myScrollView];
    [self.myScrollView scrollRectToVisible:CGRectMake(Width, 0, Width, Height) animated:YES];
    //show the real first image,not the first in the scrollView
    
    myPageControl = [[UIPageControl alloc] init];
    myPageControl.center = CGPointMake(self.view.frame.size.width/2, 60);
    myPageControl.numberOfPages=imageArray.count;
    myPageControl.currentPage=0;
    myPageControl.enabled=YES;
    [self.view addSubview:myPageControl];
    [myPageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    
    myTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
}

-(void)scrollToNextPage:(id)sender
{
    NSUInteger pageNum = myPageControl.currentPage;
    CGSize viewSize=self.myScrollView.frame.size;
    CGRect rect=CGRectMake((pageNum+2)*viewSize.width, 0, viewSize.width, viewSize.height);
    [self.myScrollView scrollRectToVisible:rect animated:YES];
    pageNum++;
    if (pageNum==imageArray.count) {
        [self performSelector:@selector(scrolltofront) withObject:nil afterDelay:0.3f];
    }
}

-(void)scrolltofront
{
    CGSize viewSize=self.myScrollView.frame.size;
    CGRect newRect=CGRectMake(viewSize.width, 0, viewSize.width, viewSize.height);
    [self.myScrollView scrollRectToVisible:newRect animated:NO];
}

#pragma mark 图片切换
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth=self.myScrollView.frame.size.width;
    int currentPage=floor((self.myScrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    if (currentPage==0) {
        myPageControl.currentPage=imageArray.count-1;
    }else if(currentPage==imageArray.count+1){
        myPageControl.currentPage=0;
    }
    myPageControl.currentPage=currentPage-1;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [myTimer invalidate];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    myTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth=self.myScrollView.frame.size.width;
    CGFloat pageHeigth=self.myScrollView.frame.size.height;
    int currentPage=floor((self.myScrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    NSLog(@"the current offset==%f",self.myScrollView.contentOffset.x);
    NSLog(@"the current page==%d",currentPage);
    
    if (currentPage==0) {
        [self.myScrollView scrollRectToVisible:CGRectMake(pageWidth*imageArray.count, 0, pageWidth, pageHeigth) animated:NO];
        myPageControl.currentPage=imageArray.count-1;
        NSLog(@"pageControl currentPage==%ld",(long)myPageControl.currentPage);
        NSLog(@"the last image");
        return;
    }else  if(currentPage==[imageArray count]+1){
        [self.myScrollView scrollRectToVisible:CGRectMake(pageWidth, 0, pageWidth, pageHeigth) animated:NO];
        myPageControl.currentPage=0;
        NSLog(@"pageControl currentPage==%ld",(long)myPageControl.currentPage);
        NSLog(@"the first image");
        return;
    }
    myPageControl.currentPage=currentPage-1;
    NSLog(@"pageControl currentPage==%ld",(long)myPageControl.currentPage);
    
}

- (void)changePage:(id)sender
{
    NSUInteger pageNum=myPageControl.currentPage;
    CGSize viewSize=self.myScrollView.frame.size;
    [myScrollView scrollRectToVisible:CGRectMake((pageNum+1)*viewSize.width, 0, viewSize.width, viewSize.height) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end