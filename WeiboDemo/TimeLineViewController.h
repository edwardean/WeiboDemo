//
//  TimeLineViewController.h
//  WeiboDemo
//
//  Created by Edward on 13-5-4.
//  Copyright (c) 2013年 Lihang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEngine.h"
#import "WBSendView.h"
@interface TimeLineViewController : UIViewController <WBEngineDelegate,WBSendViewDelegate>

@property (nonatomic, retain) WBEngine *engine;
- (id) initWithWeiboEngine:(WBEngine *)engine;
@end
