//
//  YBDefaultViewController.m
//  WeatherReport
//
//  Created by yibin on 13-2-22.
//  Copyright (c) 2013年 us.yibin. All rights reserved.
//

#import "YBDefaultViewController.h"
#import "YBUtils.h"
#import "YBSingleWeatherViewController.h"
@interface YBDefaultViewController ()
{
    NSMutableArray *favoriteCitys;
}
@end

@implementation YBDefaultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    YBUtils *utils = [[YBUtils alloc] init];
    [utils LoadFavoriteCitys];
    favoriteCitys = utils.FavoriteCity;
    CGRect rect = self.view.bounds;
   
    [super viewDidLoad];
    self.navigationItem.title=@"scrollview";
    self.view.backgroundColor = [UIColor blackColor];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height-69)];
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, rect.size.height-69, rect.size.width, 20)];
    images = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg"];
    [self.view addSubview:scrollView];
    [self.view addSubview:pageControl];
    [self setupPage];
	// Do any additional setup after loading the view.
}

-(void)setupPage{
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.canCancelContentTouches = NO;
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollView.clipsToBounds = YES;
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.directionalLockEnabled = NO;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.alwaysBounceVertical = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    NSUInteger nimages = 0;
    CGFloat cx = 0;
//    for (NSString *imgPath in images) {
//        NSLog(@"%@",imgPath);
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        [imageView setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0]];
//        UIImage *img = [UIImage imageNamed:imgPath];
//        imageView.image = img;
//        CGRect rect = scrollView.frame;
//        rect.size.height = scrollView.frame.size.height;
//        rect.size.width = scrollView.frame.size.width;
//        rect.origin.x = cx;
//        rect.origin.y = 0;
//        imageView.frame = rect;
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        [scrollView addSubview:imageView];
//        cx+=scrollView.frame.size.width;
//        nimages++;
//    }
    
        for (NSDictionary *city in favoriteCitys) {
            YBSingleWeatherViewController *single = [[YBSingleWeatherViewController alloc] initWithNibName:nil bundle:nil];
            single.city = city;
            
            CGRect rect = scrollView.frame;
            rect.size.height = scrollView.frame.size.height;
            rect.size.width = scrollView.frame.size.width;
            rect.origin.x = cx;
            rect.origin.y = 0;
            single.view.frame = rect;
            
            [scrollView addSubview:single.view];
            cx+=scrollView.frame.size.width;
            nimages++;
        }
    
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    pageControl.numberOfPages = nimages;
    pageControl.currentPage = 0;
    pageControl.tag = 0;
    [scrollView setContentSize:CGSizeMake(cx, [scrollView  bounds].size.height)];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)_scrollView{
    if(pageControllIsChangingPage){
        return;
    }
    
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    pageControl.currentPage = page;
   
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView{
    pageControllIsChangingPage = NO;
}


-(void)changePage:(id)sender{
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width *pageControl.currentPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    pageControllIsChangingPage = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
