//
//  SettingsButton.m
//  RC C9.3
//
//  Created by lamsion.chen on 11/18/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import "SettingsButton.h"
#import "RCColor.h"

@implementation SettingsButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.titleLabel.frame = CGRectMake(frame.origin.x, 2*frame.size.height/3, frame.size.width, frame.size.height/3);
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, -70, 0)];
        
    }
    return self;
}



- (void) setTitle:(NSString *)title setImage:(NSString *)img forState:(UIControlState)state
{
    [self setTitle:title forState:state];
    [self setImage:[UIImage imageNamed:img] forState:state];
    [self setImage:[UIImage imageNamed:[img stringByAppendingString:@"_S"]] forState:UIControlStateHighlighted];
    [self setImage:[UIImage imageNamed:[img stringByAppendingString:@"_S"]] forState:UIControlStateSelected];
    [self setImage:[UIImage imageNamed:img] forState:state];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.titleLabel.numberOfLines = 0;
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self setTitleColor:[RCColor RCOrange:1.0] forState:UIControlStateSelected];
    [self setTitleColor:[RCColor RCOrange:1.0] forState:UIControlStateHighlighted];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    
}


@end
