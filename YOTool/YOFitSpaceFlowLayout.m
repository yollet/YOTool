//
//  YOFitSpaceFlowLayout.m
//  YOTool
//
//  Created by jhj on 2022/3/2.
//  Copyright © 2022 jhj. All rights reserved.
//

#import "YOFitSpaceFlowLayout.h"

@implementation YOFitSpaceFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];

    if (attributes.count <= 0) {
        return attributes;
    }

    CGFloat firstCellOriginX = ((UICollectionViewLayoutAttributes *)attributes[0]).frame.origin.x;
    for(int i = 1; i < attributes.count; i++) {

        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];

        // ========横向间距设置
       
        if (currentLayoutAttributes.frame.origin.x == firstCellOriginX) { // The first cell of a new row
            continue;
        }

        CGFloat prevOriginMaxX = CGRectGetMaxX(prevLayoutAttributes.frame);
        if ((currentLayoutAttributes.frame.origin.x - prevOriginMaxX) > self.landscapeSpace) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = prevOriginMaxX + self.landscapeSpace;
            currentLayoutAttributes.frame = frame;
        }

     }
    return attributes;
}

@end
