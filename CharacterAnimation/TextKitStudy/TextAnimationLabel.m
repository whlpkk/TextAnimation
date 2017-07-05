//
//  TextAnimationLabel.m
//  TextKitStudy
//
//  Created by YZK on 2017/7/4.
//  Copyright © 2017年 MOMO. All rights reserved.
//

#import "TextAnimationLabel.h"
#import "LayerAniamtion.h"

typedef void(^TextAnimationClosure)(void);

const CGFloat kUpDismissDistance = 15;

@interface TextAnimationLabel () <NSLayoutManagerDelegate>

@property (nonatomic,strong) NSArray<CATextLayer *> *oldCharacterTextLayers;
@property (nonatomic,strong) NSArray<CATextLayer *> *xinCharacterTextLayers;

@property (nonatomic,strong) NSTextStorage *textStorage;
@property (nonatomic,strong) NSLayoutManager *textLayoutManager;
@property (nonatomic,strong) NSTextContainer *textContainer;

@property (nonatomic,copy) TextAnimationClosure animationOut;
@property (nonatomic,copy) TextAnimationClosure animationIn;

@end

@implementation TextAnimationLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self textKitObjectSetup];
    }
    return self;
}

- (void)textKitObjectSetup {
    self.textStorage = [[NSTextStorage alloc] initWithString:@""];
    
    self.textLayoutManager = [[NSLayoutManager alloc] init];
    self.textLayoutManager.delegate = self;
    
    self.textContainer = [[NSTextContainer alloc] init];
    self.textContainer.size = self.bounds.size;
    self.textContainer.lineFragmentPadding = 0;
    self.textContainer.maximumNumberOfLines = self.numberOfLines;
    self.textContainer.lineBreakMode = self.lineBreakMode;
    
    [self.textStorage addLayoutManager:self.textLayoutManager];
    [self.textLayoutManager addTextContainer:self.textContainer];
}

#pragma mark - override 

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    self.textContainer.lineBreakMode = lineBreakMode;
    [super setLineBreakMode:lineBreakMode];
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    self.textContainer.maximumNumberOfLines = numberOfLines;
    [super setNumberOfLines:numberOfLines];
}

- (void)setBounds:(CGRect)bounds {
    self.textContainer.size = bounds.size;
    [super setBounds:bounds];
}

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    if (self.textStorage) {
        self.text = self.textStorage.string;
    }
}
- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    if (self.textStorage) {
        self.text = self.textStorage.string;
    }
}

- (void)setText:(NSString *)text {
//    [super setText:text];
    
    NSMutableParagraphStyle *paragraphyStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphyStyle.alignment = self.textAlignment;
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange textRange = NSMakeRange(0, text.length);
    [attributedText setAttributes:@{NSForegroundColorAttributeName:self.textColor,
                                    NSFontAttributeName:self.font,
                                    NSParagraphStyleAttributeName:paragraphyStyle}
                            range:textRange];
    self.attributedText = attributedText;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
//    [super setAttributedText:attributedText];
    
    [self cleanOutOldCharacterTextLayers];
    self.oldCharacterTextLayers = [NSArray arrayWithArray:self.xinCharacterTextLayers];
    [self.textStorage setAttributedString:attributedText];
    [self dismissAnimation:^{
        [self showAnimation:nil];
    }];
}
- (NSAttributedString *)attributedText {
    return self.textStorage;
}

#pragma mark -

- (void)cleanOutOldCharacterTextLayers {
    for (CATextLayer *textLayer in self.oldCharacterTextLayers) {
        [textLayer removeFromSuperlayer];
    }
    self.oldCharacterTextLayers = nil;
}

#pragma mark - animation 

- (void)dismissAnimation:(TextAnimationClosure)completion {
//    [self fallAnimationDismiss:completion];
    [self upSortedAnimationDismiss:completion];
}

- (void)showAnimation:(TextAnimationClosure)completion {
//    [self opacityRandomAnimationShow:completion];
    [self upSortedAnimationShow:completion];
}

- (void)upSortedAnimationDismiss:(TextAnimationClosure)completion {
    NSInteger index = 0;
    for (CATextLayer *textLayer in self.oldCharacterTextLayers) {
        NSTimeInterval duration = 0.25;
        NSTimeInterval delay = index/20.0;
        CGFloat distance = kUpDismissDistance * -1;
        
        CATransform3D transform = CATransform3DMakeTranslation(0, distance, 0);
        
        [LayerAniamtion textLayerAnimationWithLayer:textLayer
                                           duration:duration
                                              delay:delay
                                          animation:^(void) {
                                              textLayer.transform = transform;
                                              textLayer.opacity = 0;
                                          } comletion:^(BOOL flag) {
                                              [textLayer removeFromSuperlayer];
                                              if ([textLayer isEqual:[self.oldCharacterTextLayers lastObject]]) {
                                                  if (completion) {
                                                      completion();
                                                  }
                                              }
                                          }];
        index++;
    }
}

- (void)fallAnimationDismiss:(TextAnimationClosure)completion {
    NSTimeInterval longestAnimationDuration = 0.0;
    NSInteger longestAniamtionIndex = -1;
    NSInteger index = 0;
    
    for (CATextLayer *textLayer in self.oldCharacterTextLayers) {
        NSTimeInterval duration = arc4random()%100 / 125.0 + 0.35;
        NSTimeInterval delay = arc4random_uniform(100)/500.0;
        CGFloat distance = arc4random()%50 + 25;
        CGFloat angle = ((double)arc4random())/M_PI_2 - M_PI_4;
        
        CATransform3D transform = CATransform3DMakeTranslation(0, distance, 0);
        transform = CATransform3DRotate(transform, angle, 0, 0, 1);
        
        if (delay + duration > longestAnimationDuration) {
            longestAnimationDuration = delay + duration;
            longestAniamtionIndex = index;
        }
        
        [LayerAniamtion textLayerAnimationWithLayer:textLayer
                                           duration:duration
                                              delay:delay
                                          animation:^(void) {
                                              textLayer.transform = transform;
                                              textLayer.opacity = 0;
                                          } comletion:^(BOOL flag) {
                                              [textLayer removeFromSuperlayer];
                                              if (self.oldCharacterTextLayers.count > longestAniamtionIndex &&
                                                  [textLayer isEqual:self.oldCharacterTextLayers[longestAniamtionIndex]]) {
                                                  if (completion) {
                                                      completion();
                                                  }
                                              }
                                          }];
        
        index++;
    }
}

- (void)upSortedAnimationShow:(TextAnimationClosure)completion {
    NSInteger index = 0;
    for (CATextLayer *textLayer in self.xinCharacterTextLayers) {
        NSTimeInterval duration = 0.25;
        NSTimeInterval delay = index/20.0;
        CGFloat distance = kUpDismissDistance;
        
        CATransform3D transform = CATransform3DMakeTranslation(0, distance, 0);
        textLayer.transform = transform;

        [LayerAniamtion textLayerAnimationWithLayer:textLayer
                                           duration:duration
                                              delay:delay
                                          animation:^(void) {
                                              textLayer.opacity = 1.0;
                                              textLayer.transform = CATransform3DIdentity;
                                          } comletion:^(BOOL flag) {
                                              if ([textLayer isEqual:[self.xinCharacterTextLayers lastObject]]) {
                                                  if (completion) {
                                                      completion();
                                                  }
                                              }
                                          }];
        index++;
    }
}


- (void)opacityRandomAnimationShow:(TextAnimationClosure)completion {
    NSTimeInterval longestAnimationDuration = 0.0;
    NSInteger longestAniamtionIndex = -1;
    NSInteger index = 0;
    
    for (CATextLayer *textLayer in self.xinCharacterTextLayers) {
        NSTimeInterval duration = arc4random()%200 / 100.0 + 0.25;
        NSTimeInterval delay = 0.06;
        
        if (delay + duration > longestAnimationDuration) {
            longestAnimationDuration = delay + duration;
            longestAniamtionIndex = index;
        }
        
        [LayerAniamtion textLayerAnimationWithLayer:textLayer
                                           duration:duration
                                              delay:delay
                                          animation:^(void) {
                                              textLayer.opacity = 1.0;
                                          } comletion:^(BOOL flag) {
                                              if (self.xinCharacterTextLayers.count > longestAniamtionIndex &&
                                                  [textLayer isEqual:self.xinCharacterTextLayers[longestAniamtionIndex]]) {
                                                  if (completion) {
                                                      completion();
                                                  }
                                              }
                                          }];
        
        index++;
    }
}

#pragma mark - NSLayoutManagerDelegate

- (void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(nullable NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag {
    [self calculateTextLayers];
}

#pragma mark - CalculateTextLayer

//讲每个
- (void)calculateTextLayers {
    
    self.xinCharacterTextLayers = nil;
    if (self.textStorage.length == 0) {
        return;
    }
    
    
    NSMutableArray *xinCharacterTextLayers = [NSMutableArray array];
    CGFloat scale = [UIScreen mainScreen].scale;
    
    NSMutableAttributedString *attributedString = self.textStorage;
    CGRect layoutRect = [self.textLayoutManager usedRectForTextContainer:self.textContainer];

    NSRange wordRange = NSMakeRange(0, self.textStorage.string.length);
    NSInteger index = wordRange.location;
    NSInteger totalLength = NSMaxRange(wordRange);
    while (index < totalLength) {
        //获取字形的范围
        NSRange glyphRange = NSMakeRange(index, 1);
        
        NSTextContainer *textContainer = [self.textLayoutManager textContainerForGlyphAtIndex:index effectiveRange:nil];
        
        //获取字形frame(相对于layoutRect)
        CGRect glyphRect = [self.textLayoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
        
        //rangeOfNominallySpacedGlyphsContainingIndex 返回给定index周围正常字距的range。
        NSRange kerningRange = [self.textLayoutManager rangeOfNominallySpacedGlyphsContainingIndex:index];
        if (kerningRange.location == index) {
            //这里也就是说，前一个字符不是正常的字距，需要调整字距。比如You。会在o进入这个判断，
            if (xinCharacterTextLayers.count > 0) {
                //如果前一个textlayer的frame.size.width不变大的话，当前的textLayer会遮挡住字体的一部分，比如“You”的Y右上角会被切掉一部分
                CATextLayer *previousLayer = xinCharacterTextLayers[xinCharacterTextLayers.count-1];
                CGRect frame = previousLayer.frame;
                frame.size.width = CGRectGetMaxX(glyphRect) - CGRectGetMinX(frame);
                previousLayer.frame = frame;
//                previousLayer.borderWidth = 1.0f;
            }
        }
        
        //中间垂直
        glyphRect.origin.y += (self.bounds.size.height/2)-(layoutRect.size.height/2);
        
        //根据glyphRange获取characterRange
        NSRange actualGlyphRange;
        NSRange characterRange = [self.textLayoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:&actualGlyphRange];
        
        //创建textLayer
        NSAttributedString *subText = [attributedString attributedSubstringFromRange:characterRange];
        CATextLayer *textLayer = [[CATextLayer alloc] init];
        textLayer.contentsScale = scale;
        textLayer.frame = glyphRect;
        textLayer.string = subText;
        textLayer.opacity = 0.0;
        
        //添加layer
        [self.layer addSublayer:textLayer];
        [xinCharacterTextLayers addObject:textLayer];

//        if (characterRange.length != glyphRange.length ||actualGlyphRange.length != glyphRange.length) {
//            NSLog(@"\ntext:%@\nglyphRange:%@\ncharacterRange:%@\nglyphRect:%@",subText.string,NSStringFromRange(glyphRange),NSStringFromRange(characterRange),NSStringFromCGRect(glyphRect));
//        }

        index += characterRange.length;
    }
    self.xinCharacterTextLayers = xinCharacterTextLayers;
}


@end
