//
//  CommunityVC.m
//  brandshow
//
//  Created by lance on 14-4-21.
//  Copyright (c) 2014年 harry.xie. All rights reserved.
//

#import "CommunityVC.h"

#import "NetHttpRequest.h"
#import "AppDelegate.h"
#import "UserInf+Util.h"
#import "CommunityInf.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "FileHandle.h"
#import "NSString+Util.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"

#import "UICollectionViewWaterfallCell.h"
#import "UICollectionViewWaterfallLayout.h"
//展示的列数
#define COLUMN_COUNT 4
#define CELL_IDENTIFIER @"WaterfallCell"
#define COLLECTION_HEIGHT 200.0f

#define PSIZE 10

@interface CommunityVC ()<UICollectionViewDataSource, UICollectionViewDelegateWaterfallLayout>
{
}

//社区信息
@property (nonatomic, retain) NSMutableArray * tempCommunityInfs;
@property (nonatomic, retain) NSMutableArray * dynamicUnitys;//动态地添加下载完图片的数据
//请求社区信息的页码
@property(nonatomic,assign) int pindex;

@property (nonatomic,assign) int columnWidth;


@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) IBOutlet UIButton *moreBtn;

-(IBAction)moreAction:(id)sender;

@end

@implementation CommunityVC

@synthesize columnWidth;
@synthesize moreBtn;
@synthesize pindex;
@synthesize tempCommunityInfs;
@synthesize dynamicUnitys;

- (void)viewDidLoad
{
    [super viewDidLoad];
    tempCommunityInfs=[[NSMutableArray alloc] initWithCapacity:5];
    dynamicUnitys=[[NSMutableArray alloc] initWithCapacity:5];
    
    _collectionView=[self layoutCollectionView:15];
    [self.view addSubview:_collectionView];

    [self.view bringSubviewToFront:moreBtn];

    pindex=1;
    [self getCommunityInfs];
    
}


-(UICollectionView*) layoutCollectionView:(int) space
{
    //先设置宽度
    UICollectionViewWaterfallLayout *layout = [[UICollectionViewWaterfallLayout alloc] init];
    //设置内边距
    layout.sectionInset = UIEdgeInsetsMake(space, space, space, space);
    layout.delegate = self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    columnWidth=(self.collectionView.bounds.size.width-(COLUMN_COUNT*space)) / COLUMN_COUNT;
    layout.columnCount=COLUMN_COUNT;
    layout.itemWidth=columnWidth;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor lightGrayColor];
    
    [_collectionView registerClass:[UICollectionViewWaterfallCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFIER];
    return _collectionView;
}
//获取社区信息
-(void) getCommunityInfs
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary * dict=[NSMutableDictionary dictionaryWithCapacity:6];
        //查询类型 m=1 按品牌来查询  m=2 按店员来查询 此时必须传sid
        [dict setObject:@"1" forKey:@"m"];
        //店员ID 如果bid=0 查询所有品牌资讯 ，如果传bid不为0 是查对应该品牌的资讯;
        [dict setObject:@"46" forKey:@"bid"];
        //店员ID
        [dict setObject:@"0" forKey:@"sid"];
        //会员ID
        [dict setObject:@"0" forKey:@"mid"];
        [dict setObject:[NSString stringWithFormat:@"%d",PSIZE] forKey:@"psize"];
        [dict setObject:[NSString stringWithFormat:@"%d",pindex] forKey:@"pindex"];
        NSString* url=[Prefs getServicePhone:@"GetNews" dict:dict];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString* result=[NetHttpRequest callSyncURL:url];
            NSArray * infs=[[result objectFromJSONString] objectForKey:@"news"];

            NSMutableArray * other=[[NSMutableArray alloc] init];
            [other addObject:@"http://b34.photo.store.qq.com/psu?/10fc7dde-f511-46ec-a80e-d3ef9ab4a38d/yZSJ4.z36rqIp6AULxt6z0mDlWqRBiKUQNfYvwe.j8A!/b/YRX.iQ.ryAAAYjtGUxScUgAA&a=26&b=34&bo=sADcAAAAAAACAEg!"];
            [other addObject:@"http://b30.photo.store.qq.com/psu?/10fc7dde-f511-46ec-a80e-d3ef9ab4a38d/UHmMq63BXEPn53ugySleyrFjdjMQnmmBLbXYQIkk.cE!/b/YfFp7xGfAQAAYljN6hE8AQAA&bo=8ABAAQAAAAABAJY!&rf=viewer_4"];
            [other addObject:@"http://b30.photo.store.qq.com/psu?/10fc7dde-f511-46ec-a80e-d3ef9ab4a38d/j1ZIwyrsS5PnFsLRyqIZBiuZ9fCdyUKn2gOM0o0qAzk!/b/YUVs8hG.AgAAYqQ85hEgAAAA&bo=8AA*AQAAAAABAOk!&rf=viewer_4"];
            [other addObject:@"http://b30.photo.store.qq.com/psu?/10fc7dde-f511-46ec-a80e-d3ef9ab4a38d/3OCFbCvWy2W1gN2a6yFawnus7OzMIYxZLfadrX3qRBA!/b/YYTq8BEGBAAAYtBk7xEOAQAA&bo=8ABAAQAAAAABAJY!&rf=viewer_4"];
            [other addObject:@"http://a3.att.hudong.com/26/20/300428287219132997203813377_950.jpg"];
            [other addObject:@"http://b30.photo.store.qq.com/psu?/10fc7dde-f511-46ec-a80e-d3ef9ab4a38d/VlDaLVlaSUM.c0d8KL9ITrlag5nf1HROyBO1FKV3I1Y!/b/YSlo7xHfCQAAYoQ35hHpCgAA&bo=8ABAAQAAAAABAJY!&rf=viewer_4"];
            [other addObject:@"http://b30.photo.store.qq.com/psu?/10fc7dde-f511-46ec-a80e-d3ef9ab4a38d/AYlXalSmIL*qGzkW6HDI2SnoCrb7JvPAk7EjLG3LNfQ!/b/Yf5R7BFeAgAAYkk45hEsAAAA&bo=8ABAAQAAAAABAJY!&rf=viewer_4"];
            [tempCommunityInfs removeAllObjects];
            
            for (int i=0; i<36; i++) {//得到社区数据
                CommunityInf * inf=[[CommunityInf alloc] init];
                inf.title=[NSString stringWithFormat:@"标题>%d",i];
                NSString *content=@"社区详水电费那肯定是减肥你卡的减肥了空大师就发了卡电视剧弗拉德科夫容";
                if(i%2==0){
                    content=@"啥都离开房间了凯撒的减肥了卡斯加豆腐老卡机的";
                }
                inf.content=content;
                inf.picUnity=[other objectAtIndex:i%other.count];
                [self.tempCommunityInfs addObject:inf];
                [dynamicUnitys addObject:inf];
            }
            [_collectionView reloadData];
            [self syncUnityInfs];

        });
    });
}

//同步社区信息
-(void) syncUnityInfs
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int index=dynamicUnitys.count-self.tempCommunityInfs.count;
        for (int i=index; i<dynamicUnitys.count; i++) {
            CommunityInf * inf=[dynamicUnitys objectAtIndex:i];
            NSString *dir=[FileHandle getUnityCacheDirectory];
            NSString *saveFile=[inf.picUnity md5HexDigest];
            inf.flag=[NetHttpRequest downloadSync:inf.picUnity saveTo:dir fileName:saveFile];
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSIndexPath * indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                [_collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
            });
        }
    });
    
}

-(IBAction)moreAction:(id)sender
{
    [self getCommunityInfs];
}

/** 请求社区信息 */
-(void) requestCommunity:(NSString *)resultSel searchType:(int)type
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求社区信息
        NSLog(@"请求社区信息...");
        dispatch_sync(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            //更新数据
            
        });
    });
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//屏幕变化后改变布局
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation
                                            duration:duration];
    [self updateLayout];
}
//在横竖屏变化的时候切换
- (void)updateLayout
{
    UICollectionViewWaterfallLayout *layout =
    (UICollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    int columnWidth=(self.collectionView.bounds.size.width-(COLUMN_COUNT*15)) / COLUMN_COUNT;
    //计算列数和单元格宽度
    layout.columnCount = COLUMN_COUNT;
    layout.itemWidth = columnWidth;
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource  返回块数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dynamicUnitys.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//单元格是后调用
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     CommunityInf * inf=[dynamicUnitys objectAtIndex:[indexPath row]];
    
    UICollectionViewWaterfallCell* cell=(UICollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    [cell initLayout:inf];//先调整布局再设置值
    
    cell.labelBrand.text=@"洁丽雅";
    [cell.iconBrand setImageWithURL:[NSURL URLWithString:@"http://b30.photo.store.qq.com/psu?/10fc7dde-f511-46ec-a80e-d3ef9ab4a38d/WNCrSFFUIS8VQCn7AlmLL2rEGxbMpdXMLSkIOcBUqcI!/b/YW3s8BHZAwAAYgRZ7BHeAwAA&bo=gACAAAAAAAABACc!&rf=viewer_4"]];
    [cell.iconAdd addTarget:self action:@selector(iconAddAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.iconFavritor addTarget:self action:@selector(iconFavritorAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.iconShare addTarget:self action:@selector(iconShareAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.labelTitle.text=inf.title;
    
    cell.iconAdd.tag=[indexPath row];
    cell.iconFavritor.tag=[indexPath row];
    cell.iconShare.tag=[indexPath row];
    
    
//    [cell.picBtn setImageWithURL:[NSURL URLWithString:inf.picUnity] placeholderImage:[UIImage imageNamed:@"default_icon.jpg"] completed:^(UIImage *image,NSError *error,SDImageCacheType cacheType){
//        
//        if(!inf.flag){
//            if (image) {
//                inf.picWidth=columnWidth;
//                inf.picHeight=image.size.height/image.size.width*columnWidth;
//                inf.flag=YES;
//                NSLog(@"通知更新--->%d    %f   %f",[indexPath row],inf.picWidth,inf.picHeight);
//                [_collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
//            }
//        }
//        
//    }];
    
    NSString *dir=[FileHandle getUnityCacheDirectory];
    NSString *saveFile=[inf.picUnity md5HexDigest];
    UIImage * image=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",dir,saveFile]];
    if (image==nil) {
        [cell.picBtn setImage:[UIImage imageNamed:@"default_icon.jpg"]];
    }else{
        [cell.picBtn setImage:image];
    }
    cell.textContent.text=inf.content;
    cell.tag=[indexPath row];
    
    //返回单元格
    return cell;
}

-(void) iconFavritorAction:(UIButton *)sender
{
    NSLog(@"点击喜欢--->%ld",sender.tag);
}
-(void) iconAddAction:(UIButton *)sender
{
    NSLog(@"点击添加-->%ld",sender.tag);
}
-(void) iconShareAction:(UIButton *)sender
{
    NSLog(@"点击--->%ld",sender.tag);
}
#pragma mark - UICollectionViewWaterfallLayoutDelegate 
//返回对应行的需要留出的高度---这里只调用了一次
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewWaterfallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityInf * inf=[self.dynamicUnitys objectAtIndex:[indexPath row]];
    NSString *dir=[FileHandle getUnityCacheDirectory];
    NSString *saveFile=[inf.picUnity md5HexDigest];
    UIImage * image=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",dir,saveFile]];
    if (image==nil) {
        image=[UIImage imageNamed:@"default_icon.jpg"];
    }
    //计算等比高度
    inf.picWidth=columnWidth;
    inf.picHeight=image.size.height/image.size.width*columnWidth;
//    if (!inf.flag) {
//        UIImage * image=[UIImage imageNamed:@"default_icon.jpg"];
//        inf.picWidth=columnWidth;
//        inf.picHeight=image.size.height/image.size.width*columnWidth;
//    }
    return [UICollectionViewWaterfallCell heightForCommunityInf:inf width:columnWidth];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击项---->%ld",[indexPath row]);
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"反选-->%d",[indexPath row]);
}

@end