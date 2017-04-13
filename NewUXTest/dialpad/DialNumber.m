//
//  DialNumber.m
//  Menu-Tail
//
//  Created by lamsion.chen on 12/6/14.
//  Copyright (c) 2014 lamsion.chen. All rights reserved.
//

#import "DialNumber.h"
#import "RCColor.h"

@implementation DialNumber

- (UIView *) initDialNumber:(NSString *)num withSub:(NSString *)title withSize:(int)size
{
    self = [super init];
    if (self) {
        // Custom initialization
        CGFloat numberSize = size;
        
        if ([num isEqualToString:@"none"] ) {
            [self setFrame:CGRectMake(0, 0, numberSize, numberSize)];
            [self.layer setCornerRadius:numberSize/2];
            [self.layer setBorderColor:[RCColor RCBorderBlue:1]];
            [self.layer setBorderWidth:1];
            
            
            UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, numberSize, numberSize)];
            [subLabel setTextAlignment:NSTextAlignmentCenter];
            [subLabel setText:title];
            [subLabel setTextColor:[RCColor RCBlue:1.0]];
            if ([title isEqualToString:@"#"]) {
                [subLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:32]];
            }else{
                [subLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:44]];
                [subLabel setCenter:CGPointMake(numberSize/2, numberSize*0.6)];
            }
            
            
            [self addSubview:subLabel];

        }else if ([num isEqualToString:@"dial"]){
            [self setFrame:CGRectMake(0, 0, numberSize, numberSize)];
            UIButton *dialBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, numberSize, numberSize)];
            [dialBtn setBackgroundColor:[UIColor colorWithRed:76/255.0f green:217/255.0f blue:100/255.0f alpha:1.0f]];
            [dialBtn setImage:[UIImage imageNamed:@"phone_icon"] forState:UIControlStateNormal];
            [dialBtn.layer setCornerRadius:numberSize/2];
    
//            [dialBtn setCenter:CGPointMake(1.5*numberSize/2, numberSize/2)];
            [self addSubview:dialBtn];
        }else{
            
            [self setFrame:CGRectMake(0, 0, numberSize, numberSize)];
            [self.layer setCornerRadius:numberSize/2];
            [self.layer setBorderColor:[RCColor RCBorderBlue:1]];
            [self.layer setBorderWidth:1];
            
            UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, numberSize, numberSize*0.75)];
            [numLabel setTextAlignment:NSTextAlignmentCenter];
            [numLabel setText:num];
            [numLabel setTextColor:[RCColor RCBlue:1.0]];
            [numLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:32]];
            
            
            UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, numberSize*0.6, numberSize, numberSize*0.25)];
            [subLabel setTextAlignment:NSTextAlignmentCenter];
            [subLabel setText:title];
            [subLabel setTextColor:[RCColor RCBlue:1.0]];
            [subLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
            
            
            [self addSubview:numLabel];
            [self addSubview:subLabel];
            
        }
        
        
    }
    return self;
}

@end
