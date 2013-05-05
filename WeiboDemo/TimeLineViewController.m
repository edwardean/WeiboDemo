//
//  TimeLineViewController.m
//  WeiboDemo
//
//  Created by Edward on 13-5-4.
//  Copyright (c) 2013年 Lihang. All rights reserved.
//

#import "TimeLineViewController.h"
#import "NSString+SBJSON.h"
@interface TimeLineViewController ()

@end

@implementation TimeLineViewController

- (id) initWithWeiboEngine:(WBEngine *)engine {
    if (self = [super init]) {
        self.engine = engine;
        [_engine setDelegate:self];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sendNewWeibo {
    WBSendView *weiboSendView = [[WBSendView alloc] initWithAppKey:_engine.appKey appSecret:_engine.appSecret text:@"爱编程，爱iOS，爱生活" image:[UIImage imageNamed:@"bg"]];
    
    [weiboSendView setDelegate:self];
    [weiboSendView show:YES];
    [weiboSendView release];
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result {
    
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error {
    NSLog(@"请求失败:%@",error);
}

#pragma mark - SendViewDelegate

- (void)sendView:(WBSendView *)view didFailWithError:(NSError *)error {
[view hide:YES];
}

- (void)sendViewDidFinishSending:(WBSendView *)view{
    [view hide:YES];
}

- (void)sendViewNotAuthorized:(WBSendView *)view {
    [view hide:YES];
}

- (void)sendViewAuthorizeExpired:(WBSendView *)view {
    [view hide:YES];
}
@end
