//
//  HYWaterFlowLayout.m
//  UICollectionView的基本使用
//
//  Created by huanghy on 15/12/10.
//  Copyright © 2015年 huanghy. All rights reserved.
//

#import "HYWaterFlowLayout.h"

//默认的列数
static NSUInteger const HYDefaultColumns = 3;
//默认的行距
static CGFloat const HYDefaultRowMargin = 10.0;
//默认的列距
static CGFloat const HYDefaultColumnMargin = 10.0;
//默认的边距
static UIEdgeInsets const HYDefaultInsets = {10,10,10,10};
@interface HYWaterFlowLayout()
//定义数组记录所有列最大的Y值，以便于以后比较，找出最短的列
@property (nonatomic, strong) NSMutableArray *maxColumnYs;
//定义数组保存所有子控件的对象
@property (nonatomic, strong) NSMutableArray *attrsArray;
@end

@implementation HYWaterFlowLayout

/*
 1.prepareLayout
 2.collectionViewContentSize
 3.layoutAttributesForElementsInRect
 注意：当我们滚动UICollectionView的时候，会重复的调用layoutAttributesForElementsInRect方法
 以为第一次调用完毕layoutAttributesForElementsInRect方法时，self.maxColumnYs数组中存放的数据就变成了所有列最大的Y值，而下次调用的时候还是从这个数组中取出Y值来计算自控frame，所以导致了计算出来的Y值比较大
*/


//准备布局时调用
//在第一次显示的时候会调用
//一般情况下当调用者调用collectionView的reloadData刷新布局时调用
//一般情况下会在该方法中初始化一些必要的数据，只做一次，或者刷新之后需要重新设置的属性都会放在这个地方初始化
-(NSMutableArray *)maxColumnYs
{
    if (!_maxColumnYs) {
        _maxColumnYs = [NSMutableArray array];
        //初始化一下所有列的默认值
        for (int i = 0; i < HYDefaultColumns; i ++) {
            _maxColumnYs[i] = @(HYDefaultInsets.top);
        }
    }
    return _maxColumnYs;
}

-(void)prepareLayout
{
    [super prepareLayout];
    NSLog(@"%s",__func__);
    //每次计算之前重置保存每一列最大Y值的数据
    [self.maxColumnYs removeAllObjects];
    for (int i = 0; i < HYDefaultColumns; i ++) {
        _maxColumnYs[i] = @(HYDefaultInsets.top);
    }
    
    
    //1.获取当前collectionView中有多少个子控件
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    NSMutableArray *arrayM = [NSMutableArray array];
    //2.利用循环创建所有子控件对应的属性
    for (int i = 0; i < count; i ++) {
        NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:path];
        //3.将属性对象添加到数组中
        [arrayM addObject:attr];
    }
    
    //4.返回存储这所有子控件属性对象的数组
    self.attrsArray = arrayM;

}

//该方法用于返回collectionView上所有子控件的排布cell,补充视图，装饰视图
//返回的数组中存放这所有子控件对应的UICollectionViewLayoutAttributes对象
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return  self.attrsArray;
}

//用于放回指定位置的子控件的布局属性对象
//一个UICollectionViewLayoutAttributes对象就对应一个子控件的排布
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //1.创建对应位置的布局属性对象
#warning 注意：这个地方不能通过alloc init来创建布局属性对象，因为如果通过alloc init方法来创建，系统并不知道该属性属于谁（cell 补充视图 装饰视图）
//    UICollectionViewLayoutAttributes *attr = [[UICollectionViewLayoutAttributes alloc]init];
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
   
    //计算frame
    //宽度 = UICollectionView的宽度 - 左边间隙 - 右边间隙 - 中间的间隙
    //总共的间隙 = 左边间隙 + 右边间隙 +中间间隙
    CGFloat totalMarginH = HYDefaultInsets.left + HYDefaultInsets.right + (HYDefaultColumns - 1) *HYDefaultColumnMargin;
    CGFloat width = (self.collectionView.frame.size.width -totalMarginH)/HYDefaultColumns;
    CGFloat height = 50 +arc4random_uniform(200);
   // CGFloat height = width;
   
    //找到最短的列的列号
    //以及最短列的最大的Y值
    //取出第0列的Y值，假设第0列的Y值最小
    CGFloat destY = [self.maxColumnYs[0] doubleValue];
    NSUInteger destIndex = 0;
    for (int i = 0; i < HYDefaultColumns; i ++) {
        //取出其它列一次比较
        CGFloat tempY = [self.maxColumnYs[i] doubleValue];
        if (destY > tempY) {
            destY = tempY;
            destIndex = i;
        }
    }
    //x = 左边的边距 + （item的宽度 + 间隙）* 列号
    CGFloat x = HYDefaultInsets.left + (width +HYDefaultColumnMargin)*destIndex;
    //y = 最短列最大的Y + 间隙
    CGFloat y = destY + HYDefaultRowMargin;
    
    
    
    //2.设置子控件的位置
    attr.frame = CGRectMake(x, y, width, height);
    //3.返回布局属性对象
    
    self.maxColumnYs[destIndex] = @(CGRectGetMaxY(attr.frame));
    
    return attr;
}

//用于返回collectionView的滚动范围
-(CGSize)collectionViewContentSize
{
    //拿到所有列中最大的一列的Y值作为我们滚动的高度，然后再加上底部的间隙即可
    //return CGSizeMake(0,1000);
    CGFloat destY = [self.maxColumnYs[0] doubleValue];
    for (int i = 0; i < HYDefaultColumns; i ++) {
        //取出其它列一次比较
        CGFloat tempY = [self.maxColumnYs[i] doubleValue];
        if (destY < tempY) {
            destY = tempY;
        }
    }
    return CGSizeMake(0, destY + HYDefaultInsets.bottom);
}

@end
