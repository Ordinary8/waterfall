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

#import "EGORefreshTableFooterView.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

#import "UICollectionViewWaterfallLayout.h"

#define PRODUCTCELL_IDENTIFIER @"ProductShopCell"
#define COLUMN_COUNT 3
#define COLLECTION_HEIGHT 200.0f
#define COLUMN_SPACE 20

#define COLLECT_OFFSETX 100

#define PSIZE 9

@interface MallAct ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewWaterfallLayoutDelegate,EGORefreshTableDelegate>
{
    int columnWidth;
}

@property (nonatomic,retain) UICollectionView *productCollection;
@property (nonatomic,retain) NSMutableArray * dynamicProductInfs;//动态商城数据---随加载动态变化
@property (nonatomic,retain) NSMutableArray * tempProductInfs;//临时请求数据

@property (nonatomic,retain) EGORefreshTableFooterView *refreshView;
@property (nonatomic,assign) BOOL reloading;//刷新状态

//请求商城的页码---根据请求数决定
@property(nonatomic,assign) int pindex;
//商城产品总数
@property(nonatomic,assign) int pgcount;

@end

@implementation MallAct

@synthesize productCollection;
@synthesize dynamicProductInfs;
@synthesize refreshView;
@synthesize reloading;

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
    self.tempProductInfs=[NSMutableArray array];
    columnWidth=((self.view.bounds.size.width-COLLECT_OFFSETX)) / COLUMN_COUNT;
    productCollection=[self layoutCollectionView:COLUMN_SPACE itemWidth:columnWidth];
    [self.view addSubview:productCollection];
    
    refreshView=[[EGORefreshTableFooterView alloc] initWithFrame:CGRectZero];
    refreshView.tag=2;
    refreshView.delegate = self;
    [self.productCollection addSubview:refreshView];
    [self setRefreshFrame];
    
}

-(UICollectionView*) layoutCollectionView:(int) space itemWidth:(int)itemWidth
{
    //先设置宽度
    UICollectionViewWaterfallLayout *layout = [[UICollectionViewWaterfallLayout alloc] init];
    //设置内边距
    layout.sectionInset = UIEdgeInsetsMake(space, space, space, space);
    
    layout.columnCount=COLUMN_COUNT;
    layout.itemWidth=itemWidth;
    layout.delegate = self;
    UICollectionView * collView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collView.frame=CGRectMake(COLLECT_OFFSETX, 10, self.view.bounds.size.width-COLLECT_OFFSETX, self.view.bounds.size.height);
    
    collView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    collView.dataSource = self;
    collView.delegate = self;
    
    collView.backgroundColor = [UIColor clearColor];
    collView.alwaysBounceVertical=YES;
    
    [collView registerClass:[ProductShopCell class]
        forCellWithReuseIdentifier:PRODUCTCELL_IDENTIFIER];
    return collView;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    pindex=0;
    
    if (dynamicProductInfs==nil) {
        dynamicProductInfs=[[NSMutableArray alloc] initWithCapacity:5];
    }else{
        [dynamicProductInfs removeAllObjects];
    }
    [productCollection reloadData];
    
    [self getGoodsData];
}

//获取商品数据
-(void) getGoodsData
{
    if (pindex==0) {
        pindex=1;
    }else{
        //计算页数
        int pcount=pgcount%PSIZE==0?pgcount/PSIZE:pgcount/PSIZE+1;
        if (pindex>=pcount) {
            [self.view makeToast:@"没有更多地数据了~"];
            self.reloading = NO;
            //可以退出加载提示
            [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.productCollection];
            return;
        }
        pindex++;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* result=@"这里将接口替换成了模拟数据,开发者可根据具体需求变更!图片都来源于我的空间";

        dispatch_sync(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.reloading = NO;
            //可以退出加载提示
            [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.productCollection];
            if ([NSString isNull:result]) {
                [self.view makeToast:@"请求失败!"];
            }else{
                pgcount=120;
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
                    [self.tempProductInfs addObject:inf];
                }
                if (self.tempProductInfs.count>0) {
                    [self.dynamicProductInfs addObjectsFromArray:self.tempProductInfs];
                    [productCollection reloadData];
                    [self syncProductInfs];
                }
            }
        });
    });

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
                [productCollection reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
            });
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self setRefreshFrame];
        });
    });
}

-(IBAction)moreAction:(id)sender
{
    [self getGoodsData];
}
//设置刷新控件---出现两个问题---数据少于一屏的时候下拉提示看不到,第二次多余的时候加载提示不能自动隐藏
-(void) setRefreshFrame
{
    int height=MAX(self.productCollection.frame.size.height, self.productCollection.contentSize.height);
    refreshView.frame=CGRectMake(0.0f, height, self.productCollection.frame.size.width, height);
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
    ProductShopCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:PRODUCTCELL_IDENTIFIER forIndexPath:indexPath];
    ProductInf * inf=[dynamicProductInfs objectAtIndex:[indexPath row]];
    [cell initLayout:inf indexPath:indexPath];
    
    NSString *dir=[FileHandle getUnityCacheDirectory];
    NSString *saveFile=[inf.prdPic md5HexDigest];
    UIImage * image=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",dir,saveFile]];
    [cell.productPic setImage:image];
    
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
    inf.picWidth=columnWidth-COLUMN_SPACE*2;
    
    inf.picHeight=image.size.height*inf.picWidth/image.size.width;
    return [ProductShopCell heightForProductInf:inf width:columnWidth withInsetHeight:COLUMN_SPACE*2];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{//滚动停止
    [refreshView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{//触发滚动
    [refreshView egoRefreshScrollViewDidEndDragging:scrollView];
}

//执行加载...
- (void)doneLoadingViewData{
    [self getGoodsData];
}
#pragma mark - 触发刷新
#pragma mark RefreshHeaderAndFooterViewDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    self.reloading = YES;
    [self performSelector:@selector(doneLoadingViewData) withObject:nil afterDelay:0];
}
- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return self.reloading;
}

- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    return [NSDate date];
}

@end
