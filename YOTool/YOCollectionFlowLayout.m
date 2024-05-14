//
//  YOCollectionFlowLayout.m
//  YOTool
//
//  Created by jhj on 2021/5/26.
//  Copyright © 2021 jhj. All rights reserved.
//

#import "YOCollectionFlowLayout.h"
#import "YOTool.h"

@implementation YOCollectionFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.maxSize = CGSizeZero;
        self.minSize = CGSizeZero;
        self.itemSpace = 0;
    }
    return self;
}

// 监听边界变化
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

// 计算缩放比例
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    CGFloat itemMinHeight = self.minSize.height ? self.minSize.height : 100; // 最小高度
    CGFloat itemMaxHeight = self.maxSize.height ? self.maxSize.height : 150; // 最大高度
    CGFloat itemMaxWidth = self.maxSize.width ? self.maxSize.width : 150; // 最大cell宽度
    CGFloat itemMinWidth = itemMinHeight / itemMaxHeight * itemMaxWidth; // 最小cell宽度
    CGFloat itemSpace = self.itemSpace ? self.itemSpace : 12.0; // cell之间距离
    // 获取可视范围的cell
    NSArray *atts = [super layoutAttributesForElementsInRect:self.collectionView.bounds];
    for (UICollectionViewLayoutAttributes *attr in atts) {
        CGFloat centerSpace = fabs(attr.center.x - self.collectionView.contentOffset.x - self.collectionView.yo_width / 2.0); // 当前距离中心位置
        CGFloat maxSmallSc = (itemMinHeight * itemMinHeight) / (itemMaxHeight * itemMaxHeight); // 最大缩小比例
        CGFloat nextCenterSpace = self.collectionView.yo_width / 2.0 + itemMaxWidth / 2.0 + itemMinWidth / 2.0 + itemSpace; // 最小缩放所偏移的量
        CGFloat k = (1.0 - maxSmallSc) / nextCenterSpace; // 缩放系数
        CGFloat thisSc = 1.0 - k * centerSpace; // 缩放比例
        if (thisSc < maxSmallSc) {
            thisSc = maxSmallSc;
        }
        attr.transform = CGAffineTransformMakeScale(1, thisSc); // 根据具体需求做图形变化，此处为缩放
    }
    return atts;
}

// 矫正滑动结束后item的位置
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGPoint thisPoint = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity]; // 滚动位置
    CGRect rect = CGRectMake(thisPoint.x, 0, self.collectionView.yo_width, self.collectionView.yo_height);
    NSArray<UICollectionViewLayoutAttributes *> *atts = [super layoutAttributesForElementsInRect:rect];
    CGFloat thisItemSpace = 0; // 当前最近item中心偏移c值
    CGFloat thisItemFabsSpace = MAXFLOAT; // 当前最近item中心偏移绝对值
    for (UICollectionViewLayoutAttributes *attr in atts) {
        CGFloat space = attr.center.x - thisPoint.x - self.collectionView.yo_width / 2.0; // 当前距离中心位置
        CGFloat fabsSpace = fabs(space);
        if (fabsSpace < thisItemFabsSpace) {
            thisItemFabsSpace = fabsSpace;
            thisItemSpace = space;
        }
    }
    thisPoint.x += thisItemSpace;

    return thisPoint;
}

@end
