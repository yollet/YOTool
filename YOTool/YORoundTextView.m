//
//  YORoundTextView.m
//  YOTool
//
//  Created by jhj on 2022/2/24.
//  Copyright © 2022 jhj. All rights reserved.
//

#import "YORoundTextView.h"
#import <YOTool/YOTool.h>
#include <CoreText/CTLine.h>
#include <CoreText/CTRun.h>
#include <CoreText/CTFont.h>
#include <CoreText/CTStringAttributes.h>

@implementation YORoundTextView

typedef struct GlyphArcInfo {
    CGFloat            width;
    CGFloat            angle;
} GlyphArcInfo;

- (instancetype)initWithFrame:(CGRect)frame roundString:(NSString *)roundString font:(UIFont *)font radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle contextCenter:(CGPoint)contextCenter
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.roundString = roundString;
        self.radius = radius;
        self.startAngle = startAngle;
        self.endAngle = endAngle;
        self.contextCenter = contextCenter;
        self.font = font;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setBackColor:(UIColor *)backColor
{
    _backColor = backColor ? backColor : [UIColor whiteColor];
    self.backgroundColor = _backColor;
    [self setNeedsDisplay];
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    [self setNeedsDisplay];
}

- (void)setRoundString:(NSString *)roundString
{
    _roundString = roundString;
    self.attString = [self getAttStringWithString:roundString];
}

- (void)setAttString:(NSAttributedString *)attString
{
    _attString = attString;
    [self setNeedsDisplay];
}

- (void)setStartAngle:(CGFloat)startAngle
{
    _startAngle = startAngle;
    [self setNeedsDisplay];
}

- (void)setEndAngle:(CGFloat)endAngle
{
    _endAngle = endAngle;
    [self setNeedsDisplay];
}

- (void)setContextCenter:(CGPoint)contextCenter
{
    _contextCenter = contextCenter;
    [self setNeedsDisplay];
}

static void PrepareGlyphArcInfo(CTLineRef line, CFIndex glyphCount, GlyphArcInfo *glyphArcInfo, CGFloat spaceAngle)
{
    spaceAngle = -spaceAngle;
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
    glyphArcInfo[0].angle = (prevHalfWidth / lineLength) * spaceAngle; // 赋值角度  角度 = (首个glyph宽度 / 2.0 / 排版边距) * π

    // Divide the arc into slices such that each one covers the distance from one glyph's center to the next.
    CFIndex lineGlyphIndex = 1;
    for (; lineGlyphIndex < glyphCount; lineGlyphIndex++) {
        CGFloat halfWidth = glyphArcInfo[lineGlyphIndex].width / 2.0;
        CGFloat prevCenterToCenter = prevHalfWidth + halfWidth;
        glyphArcInfo[lineGlyphIndex].angle = (prevCenterToCenter / lineLength) * spaceAngle;

        prevHalfWidth = halfWidth;
        
        // prevCenterToCenter = 当前字符宽度 / 2.0 + 上一个字符宽度 / 2.0  即与上一个字符中心点的距离
    }
}

- (void)drawRect:(CGRect)rect
{
//    NSLog(@"...............%@", self.attString.string);
    if (self.attString == nil) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform t0 = CGContextGetCTM(context);


    CGFloat xScaleFactor = t0.a > 0 ? t0.a : -t0.a;
    CGFloat yScaleFactor = t0.d > 0 ? t0.d : -t0.d;
    t0 = CGAffineTransformInvert(t0); // 反转t0
    if (xScaleFactor != 1.0 || yScaleFactor != 1.0) {
        t0 = CGAffineTransformScale(t0, xScaleFactor, yScaleFactor); // 修正缩放倍数
    }
    CGContextConcatCTM(context, t0);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    // 翻转后角度也翻转
    CGFloat startAngle = - self.startAngle;
    CGFloat endAngle = - self.endAngle;
    CGFloat positionY = self.radius;
    CGFloat ctmAngle = - M_PI_2;
    
    // Draw a white background
    UIColor *backColor = self.backColor ? self.backColor : [UIColor whiteColor];
    [backColor set];
    UIRectFill(rect);
   
    
//    CGContextSetFillColorWithColor(context, [UIColor cyanColor].CGColor);
//    CGContextFillRect(context, self.layer.bounds);
    
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)self.attString);
    assert(line != NULL); // 创建排版
    
    CFIndex glyphCount = CTLineGetGlyphCount(line);
    if (glyphCount == 0) { // 获取字符总数
        CFRelease(line);
        return;
    }
    
    GlyphArcInfo *glyphArcInfo = (GlyphArcInfo *)calloc(glyphCount, sizeof(GlyphArcInfo)); // 创建GlyphArcInfo对象数组  GlyphArcInfo包含width和angle
    PrepareGlyphArcInfo(line, glyphCount, glyphArcInfo, endAngle - startAngle);
    
    // Move the origin from the lower left of the view nearer to its center.
    CGContextSaveGState(context); // 压栈当前的绘制状态 用于保存这之前的图形状态 之后做的任何修改都不影响栈堆中的拷贝
    CGContextTranslateCTM(context, self.contextCenter.x, self.contextCenter.y); // 将原点从视图的左下角移动到指定位置（坐标系向上为正）。
    
    
    /* 画一个圆弧用作参照
    // Stroke the arc in red for verification.
    CGContextBeginPath(context);
    // 绘制圆弧  参数依次为  context 中心点的x，中心点的y， 半径，第一个点角度，第二个点角度，是否顺时针
    CGContextAddArc(context, 0.0, 0.0, self.radius, 0, 2 * M_PI, 1);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0); // 红色线条
    CGContextStrokePath(context);
     */
    
    
    
    // 开始绘制图形
//    CGPoint textPosition = CGPointMake(0, - self.radius); // 绘制的起始坐标(向下为正) 由于进行了翻转 所以变成下面
    CGPoint textPosition = CGPointMake(0, positionY);
    CGContextSetTextPosition(context, textPosition.x, textPosition.y);
    
//    CGContextRotateCTM(context, self.startAngle + M_PI_2); // 将上下文逆时针旋转 使字体起始点到准确位置。 由于进行了翻转 所以变成下面
    CGContextRotateCTM(context, startAngle + ctmAngle);
    
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
            CGContextRotateCTM(context, - (glyphArcInfo[runGlyphIndex + glyphOffset].angle)); // 旋转当前图形状态 调整每个glyph的位置
            
            // Center this glyph by moving left by half its width.
            CGFloat glyphWidth = glyphArcInfo[runGlyphIndex + glyphOffset].width;
            CGFloat halfGlyphWidth = glyphWidth / 2.0;
            CGPoint positionForThisGlyph = CGPointMake(textPosition.x - halfGlyphWidth, textPosition.y); // 当前绘制点往前半个字距的点
            
            CGAffineTransform textMatrix = CTRunGetTextMatrix(run);
            textMatrix.tx = positionForThisGlyph.x;
            textMatrix.ty = positionForThisGlyph.y; // 设置当前文本位置
            CGContextSetTextMatrix(context, textMatrix); // 相当于CGContextSetTextPosition(context, positionForThisGlyph.x, positionForThisGlyph.y);  // 把绘制起点移到下一个字符的中心点
            
            CTRunDraw(run, context, glyphRange);
            
            textPosition.x -= glyphWidth; // 绘制点偏移当前字符间距
        }
        glyphOffset += runGlyphCount;
    }
    CGContextRestoreGState(context); // 一般与CGContextSaveGState成对出现 save将图形上下文推入栈顶，restore将图形上下文出栈 使上下文状态回到save前
    
    free(glyphArcInfo);
    CFRelease(line);
}

- (NSAttributedString *)getAttStringWithString:(NSString *)string
{
    // Create an attributed string with the current font and string.
    
    if (self.font == nil || string == nil) {
        return nil;
    }
//    NSLog(@"%@",  _font);
    
    // Create our attributes.
    NSDictionary *attributes = @{NSFontAttributeName: _font, NSLigatureAttributeName: @0, NSForegroundColorAttributeName:_textColor ? _textColor : [UIColor blackColor]};
    assert(attributes != nil);
    
    // Create the attributed string.
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    return attrString;
}

- (UIColor *)textColor
{
    return _textColor ? _textColor : [UIColor blackColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
