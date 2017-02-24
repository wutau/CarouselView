//
//  WTINavigationController.m
//  WTI News
//
//  Created by 吴韬 on 17/2/21.
//  Copyright © 2017年 吴韬. All rights reserved.
//

#import "WTINavigationController.h"

@interface WTINavigationController ()

@end

@implementation WTINavigationController

+ (void)initialize
{
    //当是WTINavigationCroller类时就修改外观，定义一次就全部决定
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[WTINavigationController class]]];
    [navigationBar setBackgroundColor: UICOLOR(255, 0, 0, 1)];
}

@end
