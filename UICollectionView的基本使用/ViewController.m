//
//  ViewController.m
//  UICollectionView的基本使用
//
//  Created by huanghy on 15/12/10.
//  Copyright © 2015年 huanghy. All rights reserved.
//
/*UICollectionView的使用步骤：
 1.创建UICollectionView
 2.创建布局对象
 3.成为UICollectionView的数据源
 4.实现数据源方法，告诉系统有多少组，多少行，每行显示什么内容即可
 
 
 
 */

#import "ViewController.h"
#import "HYWaterFlowLayout.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end
static NSString *const identifier = @"cell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //1.创建UICollectionView并设置控件的frame
    //UICollectionView must be initialized with a non-nil layout parameter
    //UICollectionView在初始化时必须传递一个非空layout参数
    
    /*
     *第一个参数：UICollectionView的尺寸
     *第二个参数:UICollectionView的布局对象
     */
    //布局对象：布局对象的作用就是用于控制UICollectionView中所有子控件的排布（cell,补充视图，装饰视图）
    //UICollectionViewLayout ,基类，根布局，内部默认没有实现任何的排布，所有子控件如何排布都需要我们自己编码实现
    //UICollectionViewFlowLayout ，流水布局，默认就是从左至右一个接一个的排布
   // UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    HYWaterFlowLayout *layout = [[HYWaterFlowLayout alloc]init];
    
    //layout.itemSize = CGSizeMake(100, 100);
    //设置垂直间隙
    //设置水平间隙
    //设置顶部的扩展区域
    //设置底部的扩展区域
    //设置四周的扩展区域
   //设置滚动方向
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    //在成为数据源之前告诉系统将来通过哪个类来创建UICollectionViewCell
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    //2设置UICollectionView的数据源为当前控制器
    collectionView.dataSource = self;
    
    collectionView.delegate = self;
    //3.添加UICollectionView到控制器的view上
    collectionView.backgroundColor = [UIColor redColor];
    [self.view addSubview:collectionView];
}
#pragma mark - dataSource
//UICollectionView一共有多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//UICollectionView每一组中需要展示多少个小方块
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return 50;
}
//UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        //1.从缓存中获取cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //UICollectionView和UITableView的区别，UICollectionView的dequeueReusableCellWithReuseIdentifier这个方法，如果去缓存池取，没有取到cell，那么该方法内部会自动创建一个cell，但是需要注意，通过哪一个类来创建cell必须有我们制定。
    //2.如果缓存池中没有，就创建一个新的
//    if (cell == nil) {
//#warning 注意：UICollectionViewCell的创建方法并没有让我们绑定标识符，所以会存在一定的问题；就是以后通过标识符无法获取。
//        cell = [[UICollectionViewCell alloc]init];
//    }
#warning 注意：默认情况下UICollectionViewCell是透明的，所以看不到
    cell.backgroundColor = [UIColor grayColor];
    
    return cell;
}


#pragma mark -delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%s,%d",__func__,(int)indexPath.row);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
