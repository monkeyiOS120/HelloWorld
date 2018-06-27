//
//  Toast.h
//  ZNG-Client
//
//  Created by Yadong Wang on 16/5/11.
//  Copyright © 2016年 monkey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Toast : UIView
/*!
 @brief 初始化
 */
+(Toast *)makeText:(NSString *)text;

/*!
 @brief 显示出来
 */
-(void)show;
@end
