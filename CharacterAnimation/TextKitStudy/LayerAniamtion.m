//
//  LayerAniamtion.m
//  TextKitStudy
//
//  Created by YZK on 2017/7/4.
//  Copyright © 2017年 MOMO. All rights reserved.
//

#import "LayerAniamtion.h"

static NSString *kTextAnimationGroupKey = @"kTextAnimationGroupKey";

@interface LayerAniamtion () <CAAnimationDelegate>
@property (nonatomic,weak) CALayer *layer;
@property (nonatomic,copy) void (^comletion)(BOOL flag);
@end

@implementation LayerAniamtion

+ (void)textLayerAnimationWithLayer:(CALayer *)layer
                           duration:(NSTimeInterval)duration
                              delay:(NSTimeInterval)delay
                          animation:(EffectAnimatableLayerColsure)animationColsure
                          comletion:(void (^)(BOOL flag))comletion {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        LayerAniamtion *animationObj = [[LayerAniamtion alloc] init];
        animationObj.comletion = comletion;
        
        CALayer *olderLayer = [self animatableLayerCopy:layer];
        
        CALayer *newLayer = nil;
        if (animationColsure) {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            animationColsure();
            [CATransaction commit];
            newLayer = layer;
        }

        CAAnimationGroup *animationGroup = [animationObj groupAnimationWithLayerChanges:olderLayer newLayer:newLayer];
        if (!animationGroup) {
            if (comletion) {
                comletion(true);
            }
        }else {
            animationObj.layer = layer;
            
            animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animationGroup.beginTime = CACurrentMediaTime();
            animationGroup.duration = duration;
            animationGroup.delegate = animationObj;
            [layer addAnimation:animationGroup forKey:kTextAnimationGroupKey];
        }
    });
}


+ (CALayer *)animatableLayerCopy:(CALayer *)layer {
    CALayer *layerCopy = [CALayer layer];
    layerCopy.opacity = layer.opacity;
    layerCopy.bounds = layer.bounds;
    layerCopy.transform = layer.transform;
    layerCopy.position = layer.position;
    return layerCopy;
}

- (CAAnimationGroup *)groupAnimationWithLayerChanges:(CALayer *)olderLayer
                                            newLayer:(CALayer *)newLayer {
    
    NSMutableArray *animations = [NSMutableArray array];
    
    if ( !CGPointEqualToPoint(olderLayer.position, newLayer.position) ) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animation];
        basicAnimation.fromValue = [NSValue valueWithCGPoint:olderLayer.position];
        basicAnimation.toValue = [NSValue valueWithCGPoint:newLayer.position];
        basicAnimation.keyPath = @"position";
        [animations addObject:basicAnimation];
    }
    
    if ( !CGRectEqualToRect(olderLayer.bounds, newLayer.bounds) ) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animation];
        basicAnimation.fromValue = [NSValue valueWithCGRect:olderLayer.bounds];
        basicAnimation.toValue = [NSValue valueWithCGRect:newLayer.bounds];
        basicAnimation.keyPath = @"bounds";
        [animations addObject:basicAnimation];
    }
    
    if ( !CATransform3DEqualToTransform(olderLayer.transform, newLayer.transform) ) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animation];
        basicAnimation.fromValue = [NSValue valueWithCATransform3D:olderLayer.transform];
        basicAnimation.toValue = [NSValue valueWithCATransform3D:newLayer.transform];
        basicAnimation.keyPath = @"transform";
        [animations addObject:basicAnimation];
    }
    
    if ( olderLayer.opacity != newLayer.opacity ) {
        CABasicAnimation *basicAnimation = [CABasicAnimation animation];
        basicAnimation.fromValue = @(olderLayer.opacity);
        basicAnimation.toValue = @(newLayer.opacity);
        basicAnimation.keyPath = @"opacity";
        [animations addObject:basicAnimation];
    }
    
    CAAnimationGroup *animationGroup = nil;
    if (animations.count > 0) {
        animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = animations;
    }
    return animationGroup;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.comletion) {
        [self.layer removeAnimationForKey:kTextAnimationGroupKey];
        self.comletion(flag);
    }
}

@end
