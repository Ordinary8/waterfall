//
//  UICollectionViewWaterfallCell.h
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommunityInf;

@interface UICollectionViewWaterfallCell : UICollectionViewCell

//品牌logo
@property (nonatomic, strong) UIImageView *iconBrand;
//品牌名
@property (nonatomic, strong) UILabel *labelBrand;
//+图标
@property (nonatomic, strong) UIButton * iconAdd;
//添加喜欢
@property (nonatomic, strong) UIButton * iconFavritor;
//分享
@property (nonatomic, strong) UIButton * iconShare;

//标题 主图 信息内容的容器
@property (nonatomic,strong) UIView * container;
//信息标题
@property (nonatomic, strong) UILabel *labelTitle;
//主图
@property (nonatomic, strong) UIImageView * picBtn;
//信息内容
@property (nonatomic, strong) UITextView* textContent;

//根据社区信息初始化布局
-(void) initLayout:(CommunityInf *)inf;
/** 根据社区信息计算高度 */
+(float) heightForCommunityInf:(CommunityInf *)inf width:(int)columnWidth;

@end
