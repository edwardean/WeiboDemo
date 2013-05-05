//
//  ViewController.m
//  WeiboDemo
//
//  Created by Edward on 13-5-3.
//  Copyright (c) 2013年 Lihang. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"


@interface ViewController ()

@end

@implementation ViewController

- (WBEngine *)getWeiboEngine {
    WBEngine *engine = [(AppDelegate *)[UIApplication sharedApplication].delegate engine];
    return engine;
}
- (void)viewDidLoad
{
    bug;
    [super viewDidLoad];
    self.engine = [self getWeiboEngine];
    [_engine setRootViewController:self];
    [_engine setDelegate:self];
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([_engine isLoggedIn] && ![_engine isAuthorizeExpired]) {
        [self presentTimeLineVC:YES];
    }
}
- (void)presentTimeLineVC:(BOOL)animated {
    bug;
    TimeLineViewController *timeline = [[TimeLineViewController alloc]initWithWeiboEngine:_engine];
    [_indicator stopAnimating];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:timeline];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"发微博" style:UIBarButtonItemStyleBordered target:timeline action:@selector(sendNewWeibo)];
    timeline.navigationItem.rightBarButtonItem = rightButton;
    [self presentViewController:navigationController animated:animated completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    bug;
    [_engine logIn];
}


- (void) dealloc {
    [_engine setDelegate:nil];
    [_engine release];
    [_indicator release];
    [super dealloc];
}

#pragma mark - WBEngineDelegate

- (void)engineAlreadyLoggedIn:(WBEngine *)engine {
    bug;
//    TimeLineViewController *timeline = [[TimeLineViewController alloc]initWithWeiboEngine:engine];
//    [_indicator stopAnimating];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:timeline];
//    [self presentModalViewController:navigationController animated:YES];
//    
    if ([engine isUserExclusive]) {
        NSLog(@"只允许唯一用户");
    }
}

- (void)engineDidLogIn:(WBEngine *)engine {
    bug;
    [_indicator stopAnimating];
    NSLog(@"登陆成功");
    [self presentTimeLineVC:YES];
}

- (void)engineDidLogOut:(WBEngine *)engine {
    NSLog(@"退出成功");
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error {
    bug;
    [_indicator stopAnimating];
    NSLog(@"登陆失败: %@",error);
}

- (void)engineNotAuthorized:(WBEngine *)engine {
    NSLog(@"未授权");
}

- (void)engineAuthorizeExpired:(WBEngine *)engine {
    NSLog(@"授权到期，请重新登陆");
}
@end
