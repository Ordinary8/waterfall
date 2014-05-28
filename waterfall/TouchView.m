//
//  TouchView.m
//  brandshow
//
//  Created by lance on 14-5-9.
//  Copyright (c) 2014年 harry.xie. All rights reserved.
//

#import "TouchView.h"
#import "UIColor+Util.m"

@interface TouchView()

@property (nonatomic,retain) UIColor * beganbgColor;
@property (nonatomic,retain) UIColor * endbgColor;

@end

@implementation TouchView

@synthesize beganbgColor;
@synthesize endbgColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self touchesBegan:nil withEvent:nil];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (beganbgColor==nil) {
        self.backgroundColor=[UIColor whiteColor];
    }else{
        self.backgroundColor=beganbgColor;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (endbgColor==nil) {
        self.backgroundColor=[UIColor whiteColor];
    }else{
        self.backgroundColor=endbgColor;
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (endbgColor==nil) {
        self.backgroundColor=[UIColor whiteColor];
    }else{
        self.backgroundColor=endbgColor;
    }
}

-(void) setTouchBeganBackgroundColor:(UIColor *)touchBeganColor
{
    beganbgColor=touchBeganColor;
}
-(void) setTouchEndBackgroundColor:(UIColor *)touchEndColor
{
    endbgColor=touchEndColor;
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
