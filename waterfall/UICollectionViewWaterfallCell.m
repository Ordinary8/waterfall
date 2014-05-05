//
//  UICollectionViewWaterfallCell.m
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import "UICollectionViewWaterfallCell.h"
#import "UIImageView+WebCache.h"
#import "CommunityInf.h"

@interface UICollectionViewWaterfallCell()

@end

@implementation UICollectionViewWaterfallCell

@synthesize iconBrand;
@synthesize labelBrand;
@synthesize iconAdd;
@synthesize iconFavritor;
@synthesize iconShare;

@synthesize container;
@synthesize labelTitle;
@synthesize picBtn;
@synthesize textContent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {// Initialization code
        int icons=25;//主要解决顶层的icon布局
        int span=2;
        
        UIImage * bgImage=[UIImage imageNamed:@"enviro_round_bg.png"];
        UIImageView *bgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, icons+2, icons+2)];
        bgView.image=bgImage;
        [self.contentView addSubview:bgView];
        
        iconBrand=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, icons, icons)];
        CALayer *layer=[iconBrand layer];
        [layer setMasksToBounds:YES];
        //设置layer层以半径显示
        [layer setCornerRadius:iconBrand.frame.size.width/2.0];
        [self.contentView addSubview:iconBrand];
        //品牌名
        labelBrand=[[UILabel alloc] initWithFrame:CGRectMake(icons+2+span, 0, 100, icons)];
        //labelBrand.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        labelBrand.lineBreakMode=NSLineBreakByCharWrapping;
        labelBrand.numberOfLines=1;
        labelBrand.textColor=[UIColor blackColor];
        labelBrand.font=[UIFont systemFontOfSize:16];
        labelBrand.textAlignment=NSTextAlignmentLeft;
        labelBrand.backgroundColor=[UIColor clearColor];
        
        [self.contentView addSubview:labelBrand];
        
        iconAdd=[[UIButton alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-3*(icons+span), 0, icons, icons)];
        [iconAdd setImage:[UIImage imageNamed:@"ic_add_unity.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:iconAdd];
        
        iconFavritor=[[UIButton alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-2*(icons+span), 0, icons, icons)];
        [iconFavritor setImage:[UIImage imageNamed:@"ic_favitor_unity.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:iconFavritor];
        
        iconShare=[[UIButton alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-1*(icons+span), 0, icons, icons)];
        [iconShare setImage:[UIImage imageNamed:@"ic_share_unity.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:iconShare];
        
        ////////////////////////////////
        container=[[UIView alloc] initWithFrame:CGRectMake(0, icons+2, self.contentView.frame.size.width, 30)];
        container.backgroundColor=[UIColor whiteColor];
        [container.layer setCornerRadius:4];
        container.clipsToBounds=YES;
        
        [self.contentView addSubview:container];
        
        labelTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 30)];
        labelTitle.backgroundColor=[UIColor whiteColor];
        labelTitle.lineBreakMode=NSLineBreakByCharWrapping;
        labelTitle.numberOfLines=1;
        labelTitle.textColor=[UIColor blackColor];
        labelTitle.font=[UIFont systemFontOfSize:16];
        [labelTitle.layer setCornerRadius:1];
        labelTitle.textAlignment=NSTextAlignmentCenter;

        [container addSubview:labelTitle];
        
        UIImage * image=[UIImage imageNamed:@"default_icon.jpg"];
        
        picBtn=[[UIImageView alloc] initWithFrame:CGRectMake(0, 30, self.contentView.frame.size.width, image.size.height)];
        picBtn.contentMode=UIViewContentModeScaleAspectFill;
        picBtn.clipsToBounds = YES;
        
        [container addSubview:picBtn];
        
        textContent=[[UITextView alloc] initWithFrame:CGRectZero];
        textContent.frame=CGRectMake(0, picBtn.frame.origin.y+picBtn.frame.size.height, self.contentView.bounds.size.width, 30);
        textContent.textAlignment=NSTextAlignmentLeft;
        textContent.backgroundColor=[UIColor whiteColor];
        textContent.textColor=[UIColor blackColor];
        [textContent.layer setCornerRadius:1];
        textContent.font=[UIFont systemFontOfSize:16];
        textContent.editable=NO;
        textContent.scrollEnabled=NO;

        [container addSubview:textContent];
        
    }
    return self;
}

//调整单元格布局
-(void) initLayout:(CommunityInf *)inf
{
    int labelPadding=10;
    CGSize size=[self calLabel:labelTitle string:inf.title];
    CGRect rect=CGRectMake(0, labelTitle.frame.origin.y, labelTitle.frame.size.width, size.height+labelPadding*2);
    labelTitle.frame=rect;
    CGRect picRect = picBtn.frame;
    picRect.origin.y=labelTitle.frame.origin.y+labelTitle.frame.size.height;
    picRect.size.height=inf.picHeight;
    picBtn.frame=picRect;
    CGRect contentRect=textContent.frame;
    contentRect.origin.y=picBtn.frame.origin.y+inf.picHeight;
    contentRect.size.height=[self calTextString:inf.content width:textContent.frame.size.width].height+textContent.contentInset.top+textContent.contentInset.bottom+8*2;//有个默认内边距
    textContent.frame=contentRect;
    CGRect containerRect=container.frame;
    containerRect.size.height=labelTitle.frame.size.height+picBtn.frame.size.height+textContent.frame.size.height;
    container.frame=containerRect;
}

+(float) heightForCommunityInf:(CommunityInf *)inf width:(int)columnWidth
{
    int padding=10;
    int inset=8;
    CGSize titleSize=[self calLabelString:inf.title];
    titleSize.height=titleSize.height+padding*2;
    CGSize contentSize=[self calTextString:inf.content width:columnWidth];
    contentSize.height=contentSize.height+inset*2;
    return inf.picHeight+titleSize.height+contentSize.height+27;
}

//计算label的高度
-(CGSize)calLabel:(UILabel *)label string:(NSString *)str
{
    UIFont *font=[UIFont systemFontOfSize:16];
    CGSize size=CGSizeMake(320,2000);
    CGSize labelSize=[str sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];//多行高度
    //CGSize singleLineStringSize=[str sizeWithFont:font];//单行高度
    return labelSize;
}


+(CGSize)calLabelString:(NSString *)str
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];//必须是这组值,这个frame是初设的，没关系，后面还会重新设置其size。
    [label setNumberOfLines:0];  //必须是这组值
    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize size = CGSizeMake(320,2000);
    CGSize labelsize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    label.frame = CGRectMake(0.0, 0.0, labelsize.width, labelsize.height );
    label.backgroundColor = [UIColor purpleColor];
    label.textColor = [UIColor blackColor];
    label.text = str;
    label.font = font;
    
    return label.frame.size;
}
//计算文本大小---这里必须要提供宽度
-(CGSize) calTextString:(NSString *)str width:(int)width
{
    CGSize newSize = [str sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(width,9999)lineBreakMode:NSLineBreakByCharWrapping];
    //NSLog(@"文本框宽度--->%d   %f",width,newSize.height);
    return newSize;
}

+(CGSize) calTextString:(NSString *)str width:(int)width
{
    CGSize newSize = [str sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(width,9999)lineBreakMode:NSLineBreakByCharWrapping];
    return newSize;
}


#pragma mark - Life Cycle
- (void)dealloc
{
    [labelTitle removeFromSuperview];
    [picBtn removeFromSuperview];
    [textContent removeFromSuperview];
    labelTitle=nil;
    picBtn=nil;
    textContent=nil;
}

@end
