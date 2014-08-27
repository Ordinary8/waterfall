//
//  MallAct.m
//  brandshow
//
//  Created by lance on 14-5-20.
//  Copyright (c) 2014年 harry.xie. All rights reserved.
//

#import "MallAct.h"
#import "AppDelegate.h"
#import "NetHttpRequest.h"
#import "ProductShopCell.h"
#import "ProductInf+Util.h"
#import "UIColor+Util.h"
#import "FileHandle.h"
#import "Toast+UIView.h"
#import "NSString+Util.h"

#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

#import "UICollectionViewWaterfallLayout.h"

#define FALLCOLUMN_COUNT 4
#define COLLECTION_HEIGHT 200.0f

#define COLUMN_WIDTH 220

#define PSIZE 9

@interface MallAct ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewWaterfallLayoutDelegate>
{
}

@property (nonatomic,assign) BOOL flag;
@property (nonatomic,retain) IBOutlet UICollectionView *productCollect;
@property (nonatomic,retain) NSMutableArray * dynamicProductInfs;//动态商城数据---随加载动态变化
@property (nonatomic,retain) NSMutableArray * tempProductInfs;//临时请求数据

//请求商城的页码---根据请求数决定
@property(nonatomic,assign) int pindex;
//商城产品总数
@property(nonatomic,assign) int pgcount;

@end

@implementation MallAct

@synthesize productCollect;
@synthesize dynamicProductInfs;

@synthesize pindex;
@synthesize pgcount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dynamicProductInfs=[NSMutableArray array];
    
    [productCollect registerClass:[ProductShopCell class] forCellWithReuseIdentifier:NSStringFromClass([ProductShopCell class])];
    UICollectionViewWaterfallLayout *layout=(UICollectionViewWaterfallLayout *)productCollect.collectionViewLayout;
    //设置内边距
    layout.sectionInset = UIEdgeInsetsMake(20,20,20,20);
    layout.columnCount=FALLCOLUMN_COUNT;
    layout.minimumLineSpacing=20;
    layout.itemWidth=COLUMN_WIDTH;
    layout.delegate = self;
    
    [self setupRefresh];
    
}

- (void)setupRefresh
{
    __unsafe_unretained typeof(self) vc = self;
    [self.productCollect addHeaderWithCallback:^{
        if (vc.flag) {//如果在下载中---不允许更新数据
            [vc.productCollect headerEndRefreshing];
            return;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            vc.tempProductInfs=[vc getGoodsData:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [vc.productCollect headerEndRefreshing];
                [vc.dynamicProductInfs removeAllObjects];
                if (vc.tempProductInfs.count>0) {
                    [vc.dynamicProductInfs addObjectsFromArray:vc.tempProductInfs];
                    [vc syncProductInfs];
                }
                [vc.productCollect reloadData];
            });
        });
    }];
    [self.productCollect addFooterWithCallback:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            vc.tempProductInfs=[vc getGoodsData:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [vc.productCollect footerEndRefreshing];
                if (vc.tempProductInfs!=nil&&vc.tempProductInfs.count>0) {
                    [vc.dynamicProductInfs addObjectsFromArray:vc.tempProductInfs];
                    [vc.productCollect reloadData];
                    [vc syncProductInfs];
                }
            });
        });
    }];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.productCollect headerBeginRefreshing];
}

//获取商品数据
-(NSMutableArray*) getGoodsData:(BOOL)reset
{
    if (reset) {
        pindex=0;
    }
    if (pindex==0) {
        pindex=1;
    }else{
        if (![self hasMoreData:pindex pageCount:pgcount pageStep:PSIZE]) {
            return nil;
        }
        pindex++;
    }
    
    pgcount=120;
    NSMutableArray * results=[NSMutableArray array];
    for (int i=0;i<PSIZE; i++) {
        ProductInf * inf=[[ProductInf alloc] init];
        inf.brdimg=@"http://b30.photo.store.qq.com/psu?/10fc7dde-f511-46ec-a80e-d3ef9ab4a38d/3OCFbCvWy2W1gN2a6yFawnus7OzMIYxZLfadrX3qRBA!/m/YYTq8BEGBAAAYtBk7xEOAQAA&bo=8ABAAQAAAAABAJY!&rf=photolist";
        inf.brdname=@"品牌名";
        inf.productTitle=@"主题";
        switch (i%PSIZE) {//这里为了模拟瀑布流效果需要不同高度的图片
            case 0:
            {
                inf.prdPic=@"http://b30.photo.store.qq.com/psu?/10fc7dde-f511-46ec-a80e-d3ef9ab4a38d/j1ZIwyrsS5PnFsLRyqIZBiuZ9fCdyUKn2gOM0o0qAzk!/b/YUVs8hG.AgAAYqQ85hEgAAAA&bo=8AA*AQAAAAABAOk!";
            }
                break;
            case 1:
            {
                inf.prdPic=@"http://b79.photo.store.qq.com/psu?/V12M0lWm261Whn/nLxD1rRWvGdv0jfSwu6GRUEkxj8dyLIk80*IIoEA0Fo!/b/YSsYHi97jwAAYteZHy.qJgAA&bo=ngL2AQAAAAABAEw!&rf=viewer_4";
            }
                break;
            case 2:
            {
                inf.prdPic=@"http://b81.photo.store.qq.com/psu?/V12M0lWm261Whn/Kv9rdFTUM7ZhLAXCU5MLK1O0ennhS3fpBeqDMGh3Ly8!/b/YQEySTDhbwAAYnE1STCdXgAA&bo=owHwAQAAAAABAHQ!&rf=viewer_4";
            }
                break;
            case 3:
            {
                inf.prdPic=@"http://b81.photo.store.qq.com/psu?/V12M0lWm261Whn/Pey0NhNoj8vBAtisjWFYDNZEJa1.SyCnqhvmAagBxe8!/b/YeZHTzCMKwAAYm*nVjAWKwAA&bo=ngL2AQAAAAABAEw!&rf=viewer_4";
            }
                break;
            case 4:
            {
                inf.prdPic=@"http://b258.photo.store.qq.com/psb?/V12M0lWm3QcDvs/338I6ln4W2wkA2Y29Br3Jr6GF.hwtuSpazvp9c9PQv8!/b/dATYypnnIAAA&bo=gAJVAwAAAAABAPM!&w=176&h=235&rf=iphoto";
            }
                break;
            case 5:
            {
                inf.prdPic=@"http://b257.photo.store.qq.com/psb?/V12M0lWm3QcDvs/mcQK*18DqqLtIjgc1Y3Ax.H5E5De0y2QplNy*zL82bs!/b/dPZFNZkKGwAA&bo=gAJVAwAAAAABAPM!&w=138&h=184&rf=iphoto";
            }
                break;
            case 6:
            {
                inf.prdPic=@"http://b251.photo.store.qq.com/psb?/V12M0lWm3QcDvs/pZX6CZB12bbgOzFF7MjVe6pwrhrzlxub.2B2kTnUfBQ!/b/dLHUpJWwNAAA&bo=IANYAgAAAAABAF4!&w=279&h=209&rf=iphoto";
            }
                break;
            case 7:
            {
                inf.prdPic=@"http://b251.photo.store.qq.com/psb?/V12M0lWm3QcDvs/*P*hcK1ta5AYDhh4kyHA0hxV1m3xh6K*OP*lxrqE3E0!/b/dBe3npVUHQAA&bo=WAIgAwAAAAABAF4!&w=158&h=211&rf=iphoto";
            }
                break;
            case 8:
            {
                inf.prdPic=@"http://b253.photo.store.qq.com/psb?/V12M0lWm3QcDvs/KOUcRKfnZengwz3FESIfgUuvux9111qpsQCG4thwjfE!/b/dPN915bREAAA&bo=WAIgAwAAAAABAF4!&w=165&h=221&rf=iphoto";
            }
                break;
                
            default:
                break;
        }
        [results addObject:inf];
    }
    return results;
}

//是否还有更多数据
- (BOOL) hasMoreData:(int)indez pageCount:(int)pageCount pageStep:(int)pageStep
{
    //计算页数
    int pcount=pageCount%pageStep==0?pageCount/pageStep:pageCount/pageStep+1;
    if (indez>=pcount) {
        return NO;
    }
    return YES;
}

//同步下载产品图片
-(void) syncProductInfs
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int index=dynamicProductInfs.count-self.tempProductInfs.count;
        for (int i=index; i<dynamicProductInfs.count; i++) {
            ProductInf * inf=[dynamicProductInfs objectAtIndex:i];
            
            NSString *dir=[FileHandle getUnityCacheDirectory];
            NSString *saveFile=[inf.prdPic md5HexDigest];
            inf.flag=[NetHttpRequest downloadSync:inf.prdPic saveTo:dir fileName:saveFile];
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSIndexPath * indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                [productCollect reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
            });
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dynamicProductInfs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductShopCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ProductShopCell class]) forIndexPath:indexPath];
    ProductInf * inf=[dynamicProductInfs objectAtIndex:[indexPath row]];
    [cell initLayout:inf indexPath:indexPath width:COLUMN_WIDTH];
    
    NSString *dir=[FileHandle getUnityCacheDirectory];
    NSString *saveFile=[inf.prdPic md5HexDigest];
    UIImage * image=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",dir,saveFile]];
    [cell.productPic setImage:image];
    NSLog(@"索引位置--->%d",indexPath.row);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductInf * inf=[dynamicProductInfs objectAtIndex:[indexPath row]];
    NSString *dir=[FileHandle getUnityCacheDirectory];
    NSString *saveFile=[inf.prdPic md5HexDigest];
    UIImage * image=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",dir,saveFile]];
    if (image==nil) {
        image=[UIImage imageNamed:@"default_icon.jpg"];
    }
    //计算等比高度
    inf.picWidth=COLUMN_WIDTH;
    
    inf.picHeight=image.size.height*inf.picWidth/image.size.width;
    return [ProductShopCell heightForProductInf:inf width:COLUMN_WIDTH];
}

@end
