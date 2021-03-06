//
//  ProductCell.h
//  brandshow
//
//  Created by lance on 14-5-16.
//  Copyright (c) 2014年 harry.xie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductInf;
@class TouchView;

//产品UI
@interface ProductShopCell : UICollectionViewCell

@property (nonatomic,retain) IBOutlet UIView * container;
@property (nonatomic,retain) IBOutlet UIImageView * productPic;//商品主图
@property (nonatomic,retain) IBOutlet UILabel * productDesc;//商品标题

@property (nonatomic,retain) IBOutlet UILabel * labelTitle;

-(void) initLayout:(ProductInf *)inf indexPath:(NSIndexPath *)indexPath width:(int)columnWidth;

//计算图片高度并调整标题的布局
+(float) heightForProductInf:(ProductInf *)inf width:(int)columnWidth;

@end
