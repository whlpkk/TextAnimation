//
//  LayerAniamtion.h
//  TextKitStudy
//
//  Created by YZK on 2017/7/4.
//  Copyright © 2017年 MOMO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^EffectAnimatableLayerColsure)(void);

@interface LayerAniamtion : NSObject

+ (void)textLayerAnimationWithLayer:(CALayer *)layer
                           duration:(NSTimeInterval)duration
                              delay:(NSTimeInterval)delay
                          animation:(EffectAnimatableLayerColsure)animationColsure
                          comletion:(void (^)(BOOL flag))comletion;

@end
