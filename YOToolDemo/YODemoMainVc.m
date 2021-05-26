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

@interface YODemoMainVc () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *myField;

@end

@implementation YODemoMainVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    
    UIView *mineView = [[UIView alloc] initWithFrame:CGRectMake(22, 22, 222, 222)];
    mineView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:mineView];
    
    
    
//    NSLog(@"%f", mineView.left);
//    mineView.left -= 22;
    
//    NSLog(@"fitx == %f", [YOMainTool sharedInstance].fitX);
    
//    NSLog(@"width == %f", FitX(mineView.right));
    
    /**
    NSString *phone = [[YOMainTool sharedInstance] encryptPhoneNum:@"15000557067" index:3 lenth:4];
    NSLog(@"newStr = %@", phone);
    UILabel *label = [[UILabel alloc] initWithFrame:YORectMake(40, 300, 200, 30)];
    [label setAttributedText:[[YOMainTool sharedInstance] attributedStringWithRang:NSMakeRange(0, 3) str:phone font:[UIFont systemFontOfSize:12] color:[UIColor yellowColor]]];
    [self.view addSubview:label];
    
    NSString *oldStr = @"凤凰金卡和开发商可223";
    NSString *newStr = [[YOMainTool sharedInstance] replaceStr:oldStr withIndex:3 lenth:2 encryptStr:@"3"];
    NSLog(@"newStr == %@", newStr);
    [label setAttributedText:[[YOMainTool sharedInstance] getAttStrWithStr:newStr array:@[@"2", @"3"] font:[UIFont systemFontOfSize:17] textColor:[UIColor redColor]]];
    */
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"next" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    button.frame = YORectMake(40, 400, 100, 30);
    [self.view addSubview:button];
    
    
    /**
    NSLog(@"base64 %@", [[YOMainTool sharedInstance] base64Str:@"sdaww222"]);
    NSLog(@"base64 %@", [[YOMainTool sharedInstance] base64Str:@"sdaww222"]);
    
    self.myField = [[UITextField alloc] initWithFrame:YORectMake(40, 300, 200, 30)];
    self.myField.backgroundColor = [[YOMainTool sharedInstance] getRandomColorWithAlpha:1];
    self.myField.delegate = self;
    [self.view addSubview:_myField];
    */
    
    /*
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
    UIImage *image = [UIImage imageNamed:@"backborad"];
    [image roundImageWithSize:imageView.frame.size radius:imageView.myTHeight / 2.0 completion:^(UIImage * _Nonnull newImage) {
        imageView.image = newImage;
    }];
    [self.view addSubview:imageView];
     */
    
    /*
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 300, 200, 30) textColor:[UIColor cyanColor] font:20 textAlignment:1];
    label.text = @"ssffffffffffffffffs";
    [self.view addSubview:label];
     */
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem frame:CGRectMake(40, 400, 200, 40) title:@"nfak" titleColor:[UIColor redColor] backColor:[UIColor greenColor] font:30 radius:5];
//    [self.view addSubview:btn];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"field : %@", textField.text);
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"field no emjoy : %@", [[YOMainTool sharedInstance] converStrEmoji:_myField.text]);
    [self.myField resignFirstResponder];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
