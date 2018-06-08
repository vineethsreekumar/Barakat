//
//  XLPlainFlowLayout.m
//  XLPlainFlowLayout
//
//  Created by hebe on 15/7/30.
//  Copyright (c) 2015年 ___ZhangXiaoLiang___. All rights reserved.
//
//  工作邮箱E-mail: k52471@126.com

#import "XLPlainFlowLayout.h"

@implementation XLPlainFlowLayout

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _naviHeight = 64.0;
    }
    return self;
}


- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect
{
    //UICollectionViewLayoutAttributes：我称它为collectionView中的item（包括cell和header、footer这些）的《结构信息》
    //截取到父类所返回的数组（里面放的是当前屏幕所能展示的item的结构信息），并转化成不可变数组
    NSMutableArray *superArray = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    //创建存索引的数组，无符号（正整数），无序（不能通过下标取值），不可重复（重复的话会自动过滤）
    NSMutableIndexSet *noneHeaderSections = [NSMutableIndexSet indexSet];
    //遍历superArray，得到一个当前屏幕中所有的section数组
    for (UICollectionViewLayoutAttributes *attributes in superArray)
    {
        //如果当前的元素分类是一个cell，将cell所在的分区section加入数组，重复的话会自动过滤
        if (attributes.representedElementCategory == UICollectionElementCategoryCell)
        {
            [noneHeaderSections addIndex:attributes.indexPath.section];
        }
    }
    
    //遍历superArray，将当前屏幕中拥有的header的section从数组中移除，得到一个当前屏幕中没有header的section数组
    //正常情况下，随着手指往上移，header脱离屏幕会被系统回收而cell尚在，也会触发该方法
    for (UICollectionViewLayoutAttributes *attributes in superArray)
    {
        //如果当前的元素是一个header，将header所在的section从数组中移除
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader])
        {
            [noneHeaderSections removeIndex:attributes.indexPath.section];
        }
    }
    
    //遍历当前屏幕中没有header的section数组
    [noneHeaderSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop){
        
        //取到当前section中第一个item的indexPath
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        //获取当前section在正常情况下已经离开屏幕的header结构信息
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        
        //如果当前分区确实有因为离开屏幕而被系统回收的header
        if (attributes)
        {
            //将该header结构信息重新加入到superArray中去
            [superArray addObject:attributes];
        }
    }];
    
    //遍历superArray，改变header结构信息中的参数，使它可以在当前section还没完全离开屏幕的时候一直显示
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        
        //如果当前item是header
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader])
        {
            //得到当前header所在分区的cell的数量
            NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:attributes.indexPath.section];
            //得到第一个item的indexPath
            NSIndexPath *firstItemIndexPath = [NSIndexPath indexPathForItem:0 inSection:attributes.indexPath.section];
            //得到最后一个item的indexPath
            NSIndexPath *lastItemIndexPath = [NSIndexPath indexPathForItem:MAX(0, numberOfItemsInSection-1) inSection:attributes.indexPath.section];
            //得到第一个item和最后一个item的结构信息
            UICollectionViewLayoutAttributes *firstItemAttributes, *lastItemAttributes;
            if (numberOfItemsInSection>0)
            {
                //cell有值，则获取第一个cell和最后一个cell的结构信息
                firstItemAttributes = [self layoutAttributesForItemAtIndexPath:firstItemIndexPath];
                lastItemAttributes = [self layoutAttributesForItemAtIndexPath:lastItemIndexPath];
            }else
            {
                //cell没值,就新建一个UICollectionViewLayoutAttributes
                firstItemAttributes = [UICollectionViewLayoutAttributes new];
              
                CGFloat y = CGRectGetMaxY(attributes.frame)+self.sectionInset.top;
                firstItemAttributes.frame = CGRectMake(0, y, 0, 0);
                lastItemAttributes = firstItemAttributes;
            }
            
            CGRect rect = attributes.frame;
            
          //  NSLog( @"%@---bbbbb",NSStringFromCGRect(rect));
            
            CGFloat offset = self.collectionView.contentOffset.y + _naviHeight-40 ;
            CGFloat headerY = firstItemAttributes.frame.origin.y - rect.size.height - self.sectionInset.top;
            
            CGFloat maxY = MAX(offset,headerY);
                       CGFloat headerMissingY = CGRectGetMaxY(lastItemAttributes.frame) + self.sectionInset.bottom - rect.size.height;
            
            rect.origin.y = MIN(maxY,headerMissingY);
            attributes.frame = rect;
           
            attributes.zIndex = 7;
        }
    }
    
    return [superArray copy];
    
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    return YES;
}


@end
