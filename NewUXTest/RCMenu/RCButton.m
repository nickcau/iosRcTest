//
//  RCButton.m
//  RC C1
//
//  Created by lamsion.chen on 9/11/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import "RCButton.h"
#import "RCColor.h"

@implementation RCButton

@synthesize rctitle = _rctitle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _rctitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.bounds.size.width, 12)];
        [_rctitle setFont:[UIFont systemFontOfSize:11]];
        [self addSubview:_rctitle];
        [_rctitle setTextAlignment:NSTextAlignmentCenter];
        
        _badge = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2 + 8, -5, 14, 14)];
        [_badge setTextColor:[UIColor whiteColor]];
        [_badge setFont:[UIFont systemFontOfSize:10]];
        [_badge setBackgroundColor:[RCColor RCBadgeRed:1]];
        [_badge.layer setCornerRadius:_badge.bounds.size.width/2];
        [_badge setTextAlignment:NSTextAlignmentCenter];
        [_badge.layer setMasksToBounds:YES];
        [self addSubview:_badge];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
