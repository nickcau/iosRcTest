//
//  NoticeWindow.h
//  RCPrototype
//
//  Created by lamsion.chen on 4/22/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoticeWindowDelegate <NSObject>

- (void)scrollToUnread;

@end

@interface NoticeWindow : UIViewController 

@property (nonatomic,retain) UIButton *noticeView;
@property (nonatomic, assign) id<NoticeWindowDelegate> delegate;


@end
