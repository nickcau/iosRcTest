//
//  NoticeWindow.m
//  RCPrototype
//
//  Created by lamsion.chen on 4/22/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import "RCOverlayWindow.h"
#import "RCColor.h"

@interface RCOverlayWindow ()

@property (nonatomic) Boolean notifyFlag;

@end


@implementation RCOverlayWindow


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Place the window on the correct level and position
        self.windowLevel = UIWindowLevelStatusBar + 2;
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.noticeView = [[UIButton alloc] initWithFrame:CGRectMake(self.screen.bounds.size.width, 0, 130, 20)];
        [self.noticeView setBackgroundColor:[RCColor RCBlue:1.0f]];
        
        
        UIImage *msgNotify = [UIImage imageNamed:@"photo2"];
        UIImageView *notifyImageView = [[UIImageView alloc] initWithImage:msgNotify];
        [notifyImageView setFrame:CGRectMake(10, 5, 50, 50)];
        notifyImageView.layer.masksToBounds = YES;
        [notifyImageView.layer setCornerRadius:25];
        
//        [self.noticeView.layer setCornerRadius:10];
        [self.noticeView addSubview:notifyImageView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 6, 200, 20)];
        [nameLabel setTextColor:[UIColor whiteColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setFont:[UIFont systemFontOfSize:16]];
        
        nameLabel.text = @"Julie Smith";
        
        UILabel *contenLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 23, self.screen.bounds.size.width - 80, 40)];
        [contenLabel setTextColor:[UIColor whiteColor]];
        [contenLabel setTextAlignment:NSTextAlignmentLeft];
        [contenLabel setFont:[UIFont systemFontOfSize:12]];
        [contenLabel setNumberOfLines:0];
        [contenLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [contenLabel setAlpha:0.7];
        
        contenLabel.text = @"Sending my loan documents to you, please wait a moment.";
        
        self.notifyFlag = FALSE;
        
        [self.noticeView addSubview:nameLabel];
        [self.noticeView addSubview:contenLabel];
        [self addSubview:self.noticeView];
        
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    //NSLog(@"point is:%f",point.y);
    // if the menu is animating, prevent touches
    return CGRectContainsPoint(self.noticeView.frame, point);
    
}


@end
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
