//
//  AppDelegate.h
//  WeiboDemo
//
//  Created by Edward on 13-5-3.
//  Copyright (c) 2013年 Lihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) WBEngine *engine;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
