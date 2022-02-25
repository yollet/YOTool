//
//  RoundTextView.m
//  YOToolDemo
//
//  Created by jhj on 2022/2/23.
//  Copyright © 2022 jhj. All rights reserved.
//

#import "RoundTextView.h"
#include <CoreText/CTLine.h>
#include <CoreText/CTRun.h>
#include <CoreText/CTFont.h>
#include <CoreText/CTStringAttributes.h>

@implementation RoundTextView

typedef struct GlyphArcInfo {
    CGFloat            width;
    CGFloat            angle;    // in radians
} GlyphArcInfo;

static void PrepareGlyphArcInfo(CTLineRef line, CFIndex glyphCount, GlyphArcInfo *glyphArcInfo)
{
    NSArray *runArray = (__bridge NSArray *)CTLineGetGlyphRuns(line); // 获取CTRun(字符模块)数组
    
    // Examine each run in the line, updating glyphOffset to track how far along the run is in terms of glyphCount.
    
    CFIndex glyphOffset = 0; // 记录glyphArcInfo数组的当前下标
    for (id run in runArray) { // 遍历CTRun的对象数组
        CFIndex runGlyphCount = CTRunGetGlyphCount((__bridge CTRunRef)run); // 获取glyph（字形）的数量

        // Ask for the width of each glyph in turn.
        CFIndex runGlyphIndex = 0;
        for (; runGlyphIndex < runGlyphCount; runGlyphIndex++) {
            glyphArcInfo[runGlyphIndex + glyphOffset].width = CTRunGetTypographicBounds((__bridge CTRunRef)run, CFRangeMake(runGlyphIndex, 1), NULL, NULL, NULL); // 对glyphArcInfo数组中的元素赋值width = run中glyph的bounding box的width
        }

        glyphOffset += runGlyphCount;
    }

    double lineLength = CTLineGetTypographicBounds(line, NULL, NULL, NULL); // 计算排版边距

    CGFloat prevHalfWidth = glyphArcInfo[0].width / 2.0;
    glyphArcInfo[0].angle = (prevHalfWidth / lineLength) * M_PI; // 赋值角度  角度 = (首个glyph宽度 / 2.0 / 排版边距) * π

    // Divide the arc into slices such that each one covers the distance from one glyph's center to the next.
    CFIndex lineGlyphIndex = 1;
    for (; lineGlyphIndex < glyphCount; lineGlyphIndex++) {
        CGFloat halfWidth = glyphArcInfo[lineGlyphIndex].width / 2.0;
        CGFloat prevCenterToCenter = prevHalfWidth + halfWidth;
        glyphArcInfo[lineGlyphIndex].angle = (prevCenterToCenter / lineLength) * M_PI;

        prevHalfWidth = halfWidth;
        
        // prevCenterToCenter = 当前字符宽度 / 2.0 + 上一个字符宽度 / 2.0  即与上一个字符中心点的距离
    }
}

- (void)drawRect:(CGRect)rect
{
    if (self.attStr == NULL) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    // Draw a white background
    [[UIColor cyanColor] set];
    UIRectFill(rect);
    
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)self.attStr);
    assert(line != NULL); // 创建排版
    
    CFIndex glyphCount = CTLineGetGlyphCount(line);
    if (glyphCount == 0) { // 获取字符总数
        CFRelease(line);
        return;
    }
    
    GlyphArcInfo *glyphArcInfo = (GlyphArcInfo *)calloc(glyphCount, sizeof(GlyphArcInfo)); // 创建GlyphArcInfo对象数组  GlyphArcInfo包含width和angle
    PrepareGlyphArcInfo(line, glyphCount, glyphArcInfo);
    
    // Move the origin from the lower left of the view nearer to its center.
    CGContextSaveGState(context); // 压栈当前的绘制状态 用于保存这之前的图形状态 之后做的任何修改都不影响栈堆中的拷贝
    CGContextTranslateCTM(context, CGRectGetMidX(rect), CGRectGetMidY(rect) - self.radius / 2.0); // 将原点从视图的左下角移近其中心。
    
    
    // Stroke the arc in red for verification.
    CGContextBeginPath(context);
    // 绘制圆弧  参数依次为  context 中心点的x，中心点的y， 半径，第一个点角度，第二个点角度，是否顺时针（此处为画一个半圆）
    CGContextAddArc(context, 0.0, 0.0, self.radius, M_PI, 0.0, 1);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0); // 红色线条
    CGContextStrokePath(context);
    
    // Rotate the context 90 degrees counterclockwise.
    CGContextRotateCTM(context, M_PI_2); // 将上下文逆时针旋转90度。
    
    // 开始绘制图形
    CGPoint textPosition = CGPointMake(0.0, self.radius); // 绘制的起始坐标
    CGContextSetTextPosition(context, textPosition.x, textPosition.y);
    
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    CFIndex runCount = CFArrayGetCount(runArray);
    
    CFIndex glyphOffset = 0;
    CFIndex runIndex = 0;
    
    for (; runIndex < runCount; runIndex++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CFIndex runGlyphCount = CTRunGetGlyphCount(run);
        CFIndex runGlyphIndex = 0; // 记录glyphArcInfo下标
        for (; runGlyphIndex < runGlyphCount; runGlyphIndex++) {
            CFRange glyphRange = CFRangeMake(runGlyphIndex, 1);
            CGContextRotateCTM(context, -(glyphArcInfo[runGlyphIndex + glyphOffset].angle)); // 旋转当前图形状态
            
            // Center this glyph by moving left by half its width.
            CGFloat glyphWidth = glyphArcInfo[runGlyphIndex + glyphOffset].width;
            CGFloat halfGlyphWidth = glyphWidth / 2.0;
            CGPoint positionForThisGlyph = CGPointMake(textPosition.x - halfGlyphWidth, textPosition.y); // 计算当前glphy坐标中心点
            
            textPosition.x -= glyphWidth; // 绘制点偏移当前字符间距 / 2.0
            
            CGAffineTransform textMatrix = CTRunGetTextMatrix(run);
            textMatrix.tx = positionForThisGlyph.x;
            textMatrix.ty = positionForThisGlyph.y; // 设置当前文本位置
            CGContextSetTextMatrix(context, textMatrix);
            CTRunDraw(run, context, glyphRange);
        }
        glyphOffset += runGlyphCount;
    }
    CGContextRestoreGState(context); // 一般与CGContextSaveGState成对出现 save将图形上下文推入栈顶，restore将图形上下文出栈 使上下文状态回到save前
    
    free(glyphArcInfo);
    CFRelease(line);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
