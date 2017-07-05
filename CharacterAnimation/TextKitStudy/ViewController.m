//
//  ViewController.m
//  TextKitStudy
//
//  Created by YZK on 2017/7/4.
//  Copyright © 2017年 MOMO. All rights reserved.
//

#import "ViewController.h"
#import "TextAnimationLabel.h"

@interface ViewController ()

@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) TextAnimationLabel *label2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    label.font = [UIFont fontWithName:@"Georgia-Italic" size:17];

//    {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 200, 30)];
////        label.font = [UIFont fontWithName:@"Georgia-Italic" size:17];
//        label.text = @"fffl1YoYoYff23You1fl23";
//        [self.view addSubview:label];
//        self.label1 = label;
//    }
    
    {
        TextAnimationLabel *label = [[TextAnimationLabel alloc] initWithFrame:CGRectMake(10, 160, 200, 30)];
//        label.font = [UIFont fontWithName:@"Georgia-Italic" size:17];
        label.text = @"fffl1YoYoYff23You1fl23";
        [self.view addSubview:label];
        self.label2 = label;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeText)];
    [self.view addGestureRecognizer:tap];
}

- (void)changeText {
    NSArray *textArray = @[@"jdslkdakl",@"xcvuiowm",@"晚会上大富科技",@"sldmflkmkxc"];
    
    NSString *text = textArray[arc4random_uniform(4)];
    self.label1.text = text;
    self.label2.text = text;
}



@end
