//
//  UICollectionViewWaterfallLayout.h
//
//  Created by Nelson on 12/11/19.
//  Copyright (c) 2012 Nelson Tai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICollectionViewWaterfallLayout;

//自定义的实现瀑布流的委托
@protocol UICollectionViewDelegateWaterfallLayout <UICollectionViewDelegate>

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

//组装单元格的容器
@interface UICollectionViewWaterfallLayout : UICollectionViewLayout

@property (nonatomic, weak) id<UICollectionViewDelegateWaterfallLayout> delegate;
//返回列数
@property (nonatomic, assign) NSUInteger columnCount; // How many columns
//返回每列的宽度
@property (nonatomic, assign) CGFloat itemWidth; // Width for every column
//设置单元外边距
@property (nonatomic, assign) UIEdgeInsets sectionInset; // The margins used to lay out content in a section

@end
