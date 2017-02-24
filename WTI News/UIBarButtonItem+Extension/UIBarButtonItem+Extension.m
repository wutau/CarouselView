//
//  UIBarButtonItem+Extension.m
//  YoukuSimilar
//
//  Created by 吴韬 on 16/12/6.
//  Copyright © 2016年 吴韬. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+AdjustFrame.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)barButtonItemTaget:(id)taget action:(SEL)action imageNormal:(NSString *)imageNormal imageHighlighted:(NSString *)imageHighlighted
{
    
    /** 设置导航栏上面的内容 */
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[UIImage imageNamed:imageNormal] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:imageHighlighted] forState:UIControlStateHighlighted];
    
    [button addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 这样创建出来之后添加到item中是不会显示出来的:  没有尺寸
    //    CGSize size = leftButton.currentBackgroundImage.size;
    //    leftButton.frame = CGRectMake(0, 0, 20, 30);

    button.size = button.currentBackgroundImage.size;
    
    // 谁push进来, 就从谁的左上角修改
    return  [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

@end
