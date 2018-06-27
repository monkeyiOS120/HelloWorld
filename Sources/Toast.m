//
//  Toast.m
//  ZNG-Client
//
//  Created by Yadong Wang on 16/5/11.
//  Copyright © 2016年 monkey. All rights reserved.
//

#import "Toast.h"
//#import "MBProgressHUD+MS.h"

@interface Toast()<CAAnimationDelegate>
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,assign)NSUInteger state;
@property(nonatomic,assign)float keyBoardHeight;
@property(nonatomic,copy)NSString * lastText;//上一次的提示文本
@end

@implementation Toast

+(Toast *)makeText:(NSString *)text
{
    static Toast * toast=nil;
    static dispatch_once_t predicate;
//    dispatch_once(&predicate, ^{
//        toast=[[self alloc]init];
//    });
//    UIViewController * currentVc=[[SoftManager shareSoftManager]topViewController];
//    if(currentVc.view)
//    {
//        [MBProgressHUD showLineWithText:text textColor:nil view:[UIApplication sharedApplication].keyWindow];
//    }
    
    dispatch_once(&predicate, ^{
        toast=[[self alloc]init];
        toast.titleLabel=[[UILabel alloc]init];
        toast.titleLabel.textColor=[UIColor whiteColor];
        toast.titleLabel.textAlignment=NSTextAlignmentCenter;
        toast.titleLabel.font = [UIFont systemFontOfSize:14*SCALE_WIDTH];
        toast.titleLabel.layer.masksToBounds=YES;
        toast.titleLabel.numberOfLines=0;
        toast.titleLabel.layer.cornerRadius=(15*SCALE_WIDTH);
        toast.titleLabel.backgroundColor=[rkkOrangeColor colorWithAlphaComponent:0.95f];
//        [[NSNotificationCenter defaultCenter] addObserver:toast selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:toast selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        toast.keyBoardHeight=0;
        toast.lastText=@"";
    });
    if(!text || [text isEqualToString:@""])
    {
        return toast;
    }
    CGSize size=[text boundingRectWithSize:CGSizeMake(250*SCALE_WIDTH, 100*SCALE_WIDTH) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*SCALE_WIDTH]} context:nil].size;
    toast.titleLabel.frame=CGRectMake((SCREENWIDTH-size.width-54*SCALE_WIDTH)/2, -112*SCALE_WIDTH, size.width+54*SCALE_WIDTH, size.height+14*SCALE_WIDTH);
    toast.titleLabel.text=text;
    
    return toast;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(self.state==1)
    {
        self.state--;
        self.lastText=@"";
        [self.titleLabel.layer removeAnimationForKey:@"position.y"];
        [self.titleLabel removeFromSuperview];
    }
    else
    {
        self.state--;
    }
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    DLog(@"*-----HideKeyBoard");
    self.keyBoardHeight=0.0f;
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    DLog(@"*-----ShowKeyBoard");
    CGSize size=[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    self.keyBoardHeight=size.height;
}

-(void)show
{
//    return;
    NSLog(@"%f",SCALE_WIDTH);
    if(!self.titleLabel.text || [self.titleLabel.text isEqualToString:@""])//如果返回为空不显示
    {
        return;
    }
    else if([self.titleLabel.text isEqualToString:self.lastText])//如果提示内容相同不提示
    {
        return;
    }
    self.lastText=self.titleLabel.text;
    [self.titleLabel removeFromSuperview];
    self.titleLabel.alpha=1;
    self.state++;
//    [self.titleLabel.layer removeAllAnimations];
    [[UIApplication sharedApplication].keyWindow addSubview:self.titleLabel];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.titleLabel];
    
    CABasicAnimation * animation;
    CABasicAnimation *springAnimation1;
    if (@available(iOS 9.0, *)) {
        CASpringAnimation *springAnimation;
        springAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
        springAnimation.fromValue = @(-112);
        springAnimation.toValue = @(30+self.titleLabel.viewFrameHeight/2);
        //质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大
        springAnimation.mass = 10.0;
        //刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快
        springAnimation.stiffness = 200.0;
        //阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快
        springAnimation.damping = 200.0;
        //初始速率，动画视图的初始速度大小 Defaults to zero
        //速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
        springAnimation.initialVelocity = 10;
        springAnimation.repeatCount = 1;
        //估算时间 返回弹簧动画到停止时的估算时间，根据当前的动画参数估算
        springAnimation.duration=0.5;
        springAnimation.fillMode = kCAFillModeBoth;
        springAnimation1=springAnimation;
    }
    else
    {
        animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
        animation.duration = 0.5;
        animation.fromValue = @(-112);
        animation.toValue = @(30+self.titleLabel.viewFrameHeight/2);
        animation.removedOnCompletion=NO;
        animation.fillMode = kCAFillModeBoth;
    }
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation2.duration = 0.7;
    animation2.fromValue = @(30+self.titleLabel.viewFrameHeight/2);
    animation2.toValue = @(-112);
    animation2.beginTime = 1.3;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = 0.2;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnimation.fromValue = @(0.0);
    opacityAnimation.toValue = @(1.0);
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *opacityAnimation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation2.duration = 0.6;
    opacityAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnimation2.fromValue = @(1.0);
    opacityAnimation2.toValue = @(0.0);
    opacityAnimation2.fillMode = kCAFillModeForwards;
    opacityAnimation2.beginTime = 1.0;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 2.0;
    group.delegate=self;
    if ([[UIDevice currentDevice].systemVersion floatValue]>= 9.0)
    {
        group.animations = @[springAnimation1,opacityAnimation,opacityAnimation2,animation2];
    }
    else
    {
        group.animations = @[animation,opacityAnimation,opacityAnimation2,animation2];
    }
    
    [self.titleLabel.layer addAnimation:group forKey:nil];//@"springAnimation"];
    
    /*
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.titleLabel.alpha=0;
        DLog(@"动画开始");
    } completion:^(BOOL finished) {
        DLog(@"动画完成");
        if(self.state==1)
        {
            self.state=0;
            self.titleLabel.alpha=1;
            [self.titleLabel removeFromSuperview];
        }
        else
        {
            self.state--;
        }
    }];
     */
}
@end
