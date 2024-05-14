//
//  YOCollectionFlowLayout.h
//  YOTool
//
//  Created by jhj on 2021/5/26.
//  Copyright © 2021 jhj. All rights reserved.
//

// 用来做简单的根据移动距离缩放collect

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YOCollectionFlowLayout : UICollectionViewFlowLayout

// 最大尺寸 (缩放最大比例取决于高，缩放当前比例取决于宽和itemSpace)
@property (nonatomic, assign) CGSize maxSize;
// 最小尺寸
@property (nonatomic, assign) CGSize minSize;
@property (nonatomic, assign) CGFloat itemSpace;

@end

NS_ASSUME_NONNULL_END
