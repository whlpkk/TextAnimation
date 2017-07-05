//
//  ViewController.m
//  adfx
//
//  Created by YZK on 2017/6/24.
//  Copyright © 2017年 MOMO. All rights reserved.
//

#import "ViewController.h"
#import "POP.h"

@interface ViewController ()

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) UILabel *label2;
@property (nonatomic,strong) UIButton *btn;

@property (nonatomic,assign) CGFloat progress;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.btn setTitle:@"动画" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(animation1) forControlEvents:UIControlEventTouchUpInside];
    self.btn.frame = CGRectMake(0, 30, 100, 50);
    [self.view addSubview:self.btn];
    
    CGFloat width = 100;
    CGFloat height = 30;
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(50, 200, width, height)];
    self.contentView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.contentView];
    
    self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.label1.text = @"1234   5678";
    self.label1.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.label1];
    
    self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.label2.text = @"5678   1234";
    self.label2.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:self.label2];
    
    {
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -1.0/500;
        self.contentView.layer.sublayerTransform = transform;
        self.contentView.layer.anchorPointZ = -height/2;
    }
    
    CATransform3D transform = CATransform3DMakeTranslation(0, height/2, -height/2);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    self.label2.layer.transform = transform;
}

- (void)animation1 {
    static int i = 0;
    i++;
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/500;
    CATransform3D endTransform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    if (i%2) {
        CABasicAnimation *animation = [CABasicAnimation animation];
        animation.keyPath = @"sublayerTransform";
        animation.fromValue = [NSValue valueWithCATransform3D:transform];
        animation.toValue = [NSValue valueWithCATransform3D:endTransform];
        animation.duration = 5;
        [self.contentView.layer addAnimation:animation forKey:nil];
    }else {
        self.contentView.layer.sublayerTransform = transform;
    }

}

- (void)setProgress:(CGFloat)progress {
}



@end
