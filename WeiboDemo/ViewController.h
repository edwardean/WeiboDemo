//
//  ViewController.h
//  WeiboDemo
//
//  Created by Edward on 13-5-3.
//  Copyright (c) 2013年 Lihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "WBSendView.h"
#import "WBLogInAlertView.h"
#import "TimeLineViewController.h"
@interface ViewController : UIViewController <WBEngineDelegate,WBLogInAlertViewDelegate,UIAlertViewDelegate>

@property (nonatomic, retain) WBEngine *engine;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) TimeLineViewController *timeLineVC;
- (IBAction)login:(id)sender;
@end
