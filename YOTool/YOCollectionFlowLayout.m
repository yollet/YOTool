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

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    CGFloat itemMinHeight = 364.0; // 最小高度
    CGFloat itemMaxHeight = 422.0; // 最大高度
    CGFloat itemWidth = 327.0; // 最大cell宽度
    CGFloat itemSpace = 12.0; // cell之间距离
    // 获取可视范围的cell
    NSArray *atts = [super layoutAttributesForElementsInRect:self.collectionView.bounds];
    for (UICollectionViewLayoutAttributes *attr in atts) {
        CGFloat centerSpace = fabs(attr.center.x - self.collectionView.contentOffset.x - self.collectionView.yo_width / 2.0); // 当前距离中心位置
        CGFloat maxSmallSc = itemMinHeight / itemMaxHeight; // 最大缩小比例
        CGFloat nextCenterSpace = self.collectionView.yo_width / 2.0 + itemWidth / 2.0 + itemSpace; // 最小缩放所偏移的量
        CGFloat k = (1.0 - maxSmallSc) / nextCenterSpace; // 缩放系数
        CGFloat thisSc = 1.0 - k * centerSpace; // 缩放比例
        if (thisSc < maxSmallSc) {
            thisSc = maxSmallSc;
        }
        attr.transform = CGAffineTransformMakeScale(1, thisSc); // 根据具体需求做图形变化，此处为缩放
    }
    return atts;
}

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
