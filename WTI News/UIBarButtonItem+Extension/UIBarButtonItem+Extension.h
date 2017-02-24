//
//  UIBarButtonItem+Extension.h
//  YoukuSimilar
//
//  Created by 吴韬 on 16/12/6.
//  Copyright © 2016年 吴韬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem *)barButtonItemTaget:(id)taget action:(SEL)action imageNormal:(NSString *)imageNormal imageHighlighted:(NSString *)imageHighlighted;

@end
