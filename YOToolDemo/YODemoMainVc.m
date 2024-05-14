//
//  YODemoMainVc.m
//  YOToolDemo
//
//  Created by jhj on 2019/4/25.
//  Copyright © 2019 jhj. All rights reserved.
//

#import "YODemoMainVc.h"
#import "UIView+YOTool.h"
#import "SecondVc.h"
#import <math.h>
#import "YORoundProgressView.h"
#import "YORoundExerciseProgress.h"
#import "RoundTextView.h"
#import "YORoundTextView.h"
#import <SVGKit/SVGKit.h>
#import <SVGKit/SVGKImage.h>
#import "YOSoundPlayTool.h"
#import "YOTool/YOTool.h"

@interface YODemoMainVc () <UITextFieldDelegate, YORoundExerciseProgressDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) UITextField *myField;
@property (nonatomic, strong) UIView *sloder;
@property (nonatomic, strong) YORoundProgressView *round;
@property (nonatomic, assign) CGPoint thisPoint;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGPoint viewCenter;
@property (nonatomic, assign) CGFloat angel;
@property (nonatomic, strong) UIView *sloderBack;

@property (nonatomic, assign) NSInteger btnTag;
@property (nonatomic, strong) YORoundExerciseProgress *progressBar;

@property (nonatomic, strong) YORoundTextView *roundText;

@property (nonatomic, assign) CGFloat roundRadius;
@property (nonatomic, assign) CGSize sliderSize;
@property (nonatomic, assign) CGSize textSize;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation YODemoMainVc



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    
    YOButton *btn = [YOButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:btn];
    btn.yo_setLeft(30).yo_setTop(66).yo_setWidth(100).yo_setHeight(30);
    btn.yo_setDefault(YORoundType);
    [btn addTarget:self action:@selector(showProgress) forControlEvents:UIControlEventTouchUpInside];
    
//    [self textSlider];
    
//    [self textRoundProgress];
    
//    [self textRoundText];
     
//    [self showSvgImage];
    
//    [self textCollectionView];
    
    
    
}

#pragma mark -- 进度条 --
- (void)showProgress
{
    YOProgressView *progressView = [[YOProgressView alloc] initWithFrame:CGRectMake(30, 120, 222, 20)];
    [self.view addSubview:progressView];
    
    [progressView addPanWithBlock:^(CGFloat progress) {
        NSLog(@"%f", progress);
    }];
}

#pragma mark -- textView --
- (void)showTextView
{
    YOTextView *textView = [[YOTextView alloc] initWithFrame:CGRectMake(20, 100, 222, 111)];
    [self.view addSubview:textView];
    
    
    textView.maxLength = 10;
    textView.showNum = YES;
    textView.placeholder = @"打分";
    textView.backgroundColor = [UIColor cyanColor];
    
    textView.topHeight = 15;
    textView.leftWidth = 15;
    
    
}

#pragma mark -- 播放音效 --
- (void)playSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"大红色" ofType:@"mp3"];
    NSLog(@"%@", path);
    [YOSoundPlayTool playSoundWithPath:path];
}

#pragma mark -- collectionView缩放 --
- (void)textCollectionView
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    YOCollectionFlowLayout *layout = [[YOCollectionFlowLayout alloc] init];
    layout.maxSize = CGSizeMake(250, 250);
    layout.minSize = CGSizeMake(200, 200);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, screenWidth, 500) collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"text"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.view addSubview:self.collectionView];
}

#pragma mark -- 环形进度条 --
- (void)textRoundProgress
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.roundRadius = 100;
    self.sliderSize = CGSizeMake(30, 40);
    self.textSize = CGSizeMake(80, 35);
    
    CGFloat outRadius = self.roundRadius + self.sliderSize.height / 2.0 + self.textSize.height / 2.0;
    CGFloat backWidth = (outRadius + self.textSize.height / 2.0) * 2.0;
    CGFloat lineWidth = 20;
    
//    self.textSize = CGSizeZero;
    
    
    self.progressBar = [[YORoundExerciseProgress alloc] initWithFrame:CGRectMake((screenWidth - backWidth) / 2.0, 200, backWidth, backWidth) radius:self.roundRadius sliderSize:self.sliderSize lineWidth:lineWidth lineBackColor:[UIColor lightGrayColor] lineColor:[UIColor cyanColor] backColor:[UIColor whiteColor] sliderImage:[UIImage imageNamed:@"IMG_4778"] textSize:self.textSize font:[UIFont systemFontOfSize:12]];
    self.progressBar.delegate = self;
//    self.progressBar.backgroundColor = [UIColor orangeColor];
    self.progressBar.textColor = [[YOMainTool sharedInstance] getRandomColorWithAlpha:1];
    self.progressBar.textSize = self.textSize;
    self.progressBar.maxSecond = 400;
    [self.view addSubview:_progressBar];
     
    
    
    
}

#pragma mark -- 环形条加滑块 --
- (void)textSlider
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.round = [[YORoundProgressView alloc] initWithFrame:CGRectZero lineWidth:20 lineBackColor:[UIColor lightGrayColor] lineColor:[UIColor cyanColor] backColor:[UIColor whiteColor]];
    [self.view addSubview:self.round];
    
    self.round.yo_setLeft((screenWidth - 200) / 2.0).yo_setTop(150).yo_setWidth(200).yo_setHeight(200);
    self.round.progress = 100;
    
    self.sloderBack = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_sloderBack];
    
    self.sloder = [[UIView alloc] initWithFrame:CGRectZero];
    self.sloder.backgroundColor = [UIColor orangeColor];
    [self.sloderBack addSubview:_sloder];
    
    self.sloderBack.yo_setWidth(200 + 10).yo_setHeight(200 + 10).yo_setCenterX(self.round.yo_centerX).yo_setCenterY(self.round.yo_centerY);
    self.sloder.yo_setWidth(15).yo_setHeight(30).yo_setCenterX(self.sloderBack.yo_width / 2.0).yo_setTop(0);
    
    self.thisPoint = CGPointMake(_sloder.yo_centerX, _sloder.yo_centerY);
    
    self.radius = self.round.yo_height / 2.0;
    self.viewCenter = self.round.center;
    self.angel = M_PI / 2.0;
    
//    self.sloder.layer.anchorPoint = self.viewCenter;
//    self.sloder.center = self.thisPoint;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.sloder addGestureRecognizer:pan];
     
     
}

#pragma mark -- 弧形文字 --
- (void)textRoundText
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.roundText = [[YORoundTextView alloc] initWithFrame:CGRectZero];
    self.roundText.yo_setTop(200).yo_setWidth(250).yo_setHeight(350).yo_setCenterX(screenWidth / 2.0);
    self.roundText.radius = 100;
    self.roundText.contextCenter = CGPointMake(self.roundText.yo_width / 2.0, self.roundText.yo_height / 2.0);
    self.roundText.startAngle = ((90 - 30) / 180.0) * M_PI + M_PI;
    self.roundText.endAngle =  ((30 + 90) / 180.0) * M_PI + M_PI;
    self.roundText.font = [UIFont systemFontOfSize:17];
    self.roundText.roundString = @"13:22/14:00";
    self.roundText.backColor = [UIColor clearColor];
    [self.view addSubview:_roundText];
    
}

#pragma mark -- svg加载 --
- (void)showSvgImage
{
//    NSString *file = [[NSBundle mainBundle] pathForResource:@"21510" ofType:@"svg"];
//    NSData *data = [NSData dataWithContentsOfFile:file];
    
    
    
    SVGKImage *image = [SVGKImage imageNamed:@"21510"];
    image.size = CGSizeMake(100, 100);


    SVGKLayeredImageView *imageView = [[SVGKLayeredImageView alloc] initWithSVGKImage:image];
    [self.view addSubview:imageView];
//
//    imageView.frame = CGRectMake(100, 100, 100, 100);
//
//    CALayer *layer = [imageView.image layerWithIdentifier:@"make-me-a-hanzi-clip-0"];
//
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
//    animation.duration = 1;
//    animation.autoreverses = YES;
//    animation.repeatCount = 100000;
//    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(150, 150)];
//    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(-150, -150)];
//
//    [layer addAnimation:animation forKey:@"moveGreenSquare"];
    
    
    
    SVGKSource *source = [SVGKSourceLocalFile internalSourceAnywhereInBundle:[NSBundle mainBundle] usingName:@"21510"]; // svg来源创建

    SVGKParser *parser = [[SVGKParser alloc] initWithSource:source]; // 解析器实例
    [parser addDefaultSVGParserExtensions]; // 规范解析器添加

    SVGKParseResult *result = [parser parseSynchronously]; // 进行解析svg
    // 对于CSS3的动画 @keyframes 无法识别
    
    
    
//    SVGKImage *image = [SVGKImage imageNamed:@"21510"];
}

- (BOOL)progressBeginSlide:(CGFloat)angle
{
    CGFloat progress = angle / (2.0 * M_PI) > 1 ? 1 : angle / (2.0 * M_PI);
    self.progressBar.progress = progress * 100.0;
    self.progressBar.second = self.progressBar.maxSecond * progress;
    return YES;
}

- (BOOL)progressEndSlide:(CGFloat)angle
{
    CGFloat progress = angle / (2.0 * M_PI) > 1 ? 1 : angle / (2.0 * M_PI);
    self.progressBar.progress = progress * 100.0;
    self.progressBar.second = self.progressBar.maxSecond * progress;
    return YES;
}

- (BOOL)progressSliding:(CGFloat)angle
{
    CGFloat progress = angle / (2.0 * M_PI) > 1 ? 1 : angle / (2.0 * M_PI);
    self.progressBar.progress = progress * 100.0;
    self.progressBar.second = self.progressBar.maxSecond * progress;
    NSLog(@"---------------%f  %f", angle, progress);
    return YES;
}

- (BOOL)progressRoundBegin:(CGFloat)angle pan:(nonnull UIPanGestureRecognizer *)pan
{
    CGFloat progress = 0;
    self.progressBar.progress = progress * 100.0;
    self.progressBar.second = self.progressBar.maxSecond * progress;
    return NO;
}

- (BOOL)progressRoundEnd:(CGFloat)angle pan:(nonnull UIPanGestureRecognizer *)pan
{
    CGFloat progress = 1;
    self.progressBar.progress = progress * 100.0;
    self.progressBar.second = self.progressBar.maxSecond * progress;
    return NO;
}



- (void)btnAction
{
//    self.roundText.transform = CGAffineTransformMakeRotation(M_PI / 12.0 * _btnTag);
    self.progressBar.second = _btnTag;
    self.btnTag ++ ;
}

- (void)panAction:(UIPanGestureRecognizer *)pan
{
    CGPoint po1 = [pan locationInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGFloat angle = 0;
    CGPoint po2 = CGPointMake(po1.x - [UIScreen mainScreen].bounds.size.width / 2.0, 105 + 150 - 5 - po1.y);
    
    NSLog(@"%f, %f", po2.x, po2.y);
    
//    if (po2.x >= - (100 - 15) && po2.x <= 100 - 15) {
//        CGFloat xt = po2.x;
//        CGFloat yt = sqrt(100.0 * 100.0 / (po2.y * po2.y)) * (po2.y / fabs(po2.y));
        
//        angle = acos(po2.x / self.radius);
//        angle = atan2(po2.x, po2.y);
//    }
//    else if (po2.x >= - (100 - 15) && po2.x <= 100 - 15 && po2.y < 0) {
//        angle = acos(po2.x / self.radius) + M_PI / 2.0;
//    }
    
    angle = AngleFromNorth(CGPointMake(0, 0), po2, NO);
//    angle = atan(po2.y / po2.x);
    
    NSLog(@"angle == %f   angle == %f", angle / M_PI * 180, (M_PI / 2.0 - angle) / M_PI * 180.0);
    CGAffineTransform trans = CGAffineTransformIdentity;
    trans = CGAffineTransformMakeRotation(M_PI / 2.0 - angle);
//    self.sloderBack.layer.affineTransform = trans;
//    self.sloderBack.transform = CGAffineTransformIdentity;
    self.sloderBack.transform = trans;
    
//    trans = CGAffineTransformMakeTranslation(po1.x, po1.y);
//    self.sloder.layer.affineTransform = trans;
    
//    NSLog(@"%f  %f", po2.x, po2.y);
//    [pan setTranslation:CGPointZero inView:self.sloderBack];
}



static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x - p1.x, p2.y - p1.y);
//    float vmag = sqrt(v.x * v.x + v.y * v.y), result = 0;
    float result = 0;
//    v.x /= vmag;
//    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = radians;
    return (result >= 0 ? result : result + 2 * M_PI);
}

CGAffineTransform  GetCGAffineTransformRotateAroundPoint(float centerX, float centerY ,float x ,float y ,float angle)
{
    x = x - centerX; //计算(x,y)从(0,0)为原点的坐标系变换到(CenterX ，CenterY)为原点的坐标系下的坐标
    y = y - centerY; //(0，0)坐标系的右横轴、下竖轴是正轴,(CenterX,CenterY)坐标系的正轴也一样
 
    CGAffineTransform  trans = CGAffineTransformMakeTranslation(x, y);
    trans = CGAffineTransformRotate(trans,angle);
    trans = CGAffineTransformTranslate(trans,-x, -y);
    return trans;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSLog(@"field : %@", textField.text);
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"field no emjoy : %@", [[YOMainTool sharedInstance] converStrEmoji:_myField.text]);
//    [self.myField resignFirstResponder];
}

- (void)next
{
    /*
    SecondVc *vc = [[SecondVc alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
     */
    
//    [self showAlertWithTitle:@"dsa" info:@"fwefw" leftStr:@"ssd" rightStr:@"vds" type:allRedType leftBlock:nil rightBlock:nil];
    
    [self aaa:[NSNull null]];
}

- (void)aaa:(id)data
{
    NSString *str = data[3];
    NSLog(@"%@", str);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(250, 250);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"text" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor cyanColor];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
