//
//  MBProgressHUD+Simple.m
//  BJEducation
//
//  Created by 辛亚鹏 on 10/29/14.
//  Copyright (c) 2014 com.bjhl. All rights reserved.
//

#import "MBProgressHUD+Simple.h"
#import "AppDelegate.h"

@implementation MBProgressHUD (Simple)

+ (void)showErrorThenHide:(NSString *)msg toView:(UIView *)view onHide:(void (^)())onHide
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    NSAssert1(view != nil, @"showLoading view没找到 %s", __FUNCTION__);
    if (view == nil) {
//        DDLogWarn(@"没找到view %s",__FUNCTION__);
        NSLog(@"没找到view %s",__FUNCTION__);
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud){
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    NSAssert1(hud != nil, @"hud为nil %s", __FUNCTION__);
    if (hud == nil) {
//        DDLogWarn(@"hud为nil %s",__FUNCTION__);
        NSLog(@"hud为nil %s",__FUNCTION__);
    }
//    [hud showErrorThenHide:msg onHide:onHide];
    [MBProgressHUD showMessageThenHide:msg toView:view onHide:onHide];
}

- (void)showErrorThenHide:(NSString *)msg
{
    [self showErrorThenHide:msg onHide:nil];
}


- (void)showErrorThenHide:(NSString *)msg onHide:(void (^)())onHide
{
    [self showMessageWithIcon:[UIImage imageNamed:@"ic_fo_wi.png"] message:msg hideDelay:3 onHide:onHide];
}

- (void)showSuccessThenHide:(NSString *)msg
{
    [self showSuccessThenHide:msg onHide:nil];
}

+ (void)showSuccessThenHide:(NSString *)msg toView:(UIView *)view onHide:(void (^)())onHide
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    NSAssert1(view != nil, @"showLoading view没找到 %s", __FUNCTION__);
    if (view == nil) {
//        DDLogWarn(@"没找到view %s",__FUNCTION__);
        NSLog(@"没找到view %s",__FUNCTION__);
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud){
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    NSAssert1(hud != nil, @"hud为nil %s", __FUNCTION__);
    if (hud == nil) {
//        DDLogWarn(@"hud为nil %s",__FUNCTION__);
        NSLog(@"hud为nil %s",__FUNCTION__);
    }
    [hud showSuccessThenHide:msg onHide:onHide];
    [MBProgressHUD showMessageThenHide:msg toView:view onHide:onHide];
}


- (void)showSuccessThenHide:(NSString *)msg onHide:(void (^)())onHide
{
    [self showMessageWithIcon:[UIImage imageNamed:@"ic_ri_wi.png"] message:msg hideDelay:1 onHide:onHide];
}



- (void)showMessageWithIcon:(UIImage *)iconImg message:(NSString *)msg hideDelay:(float)delay onHide:(void (^)())onHide
{
    if (msg == nil){
        [self hideAnimated:true];
        if (onHide){
            onHide();
        }
        return;
    }
    
    MBProgressHUD *hud = self;
    hud.detailsLabel.text = nil;
    hud.label.text = nil;
    hud.userInteractionEnabled = false;
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
//    hud.dimBackground = NO;
    hud.backgroundColor = [UIColor clearColor];
//    hud.opacity = 0.7;
    hud.bezelView.alpha = 0.7;
    [hud setUserInteractionEnabled:false];
    
    UIView *customView = [[UIView alloc] init];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:iconImg];
    [customView addSubview:iconView];
    CGRect iconFrame = iconView.frame;
    iconFrame.origin.y = 0;
    iconView.frame = iconFrame;
    //customView.frame = CGRectMake(0, 0, 12, 13.5);
    
    UILabel *textLbl = [[UILabel alloc] init];
    [textLbl setNumberOfLines:0];
    textLbl.backgroundColor = [UIColor clearColor];
    textLbl.font = [UIFont systemFontOfSize:16];
    textLbl.textColor = [UIColor whiteColor];
    [textLbl setText:msg];
    CGSize textSize;
    if ([msg respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        CGRect frame = [msg boundingRectWithSize:CGSizeMake(220, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[textLbl font]} context:nil];
        textSize = frame.size;
    }
    else
        textSize = [msg sizeWithFont:[textLbl font] forWidth:220 lineBreakMode:NSLineBreakByClipping];
    
    CGFloat strikeWidth = textSize.width;
//    CGFloat height = textSize.height > 13 ? textSize.height : 13;
    textLbl.frame = CGRectMake(5, CGRectGetMaxY(iconFrame)+10, strikeWidth, textSize.height);
    customView.frame = CGRectMake(0, 0, 10+ strikeWidth, CGRectGetMaxY(textLbl.frame));
    [customView addSubview:textLbl];
    
    iconFrame.origin.x = (customView.frame.size.width-iconFrame.size.width)/2;
    iconView.frame = iconFrame;
    
    /*
     [textLbl autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:5];
     [textLbl autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:iconView withOffset:5];
     [textLbl autoAlignAxis:ALAxisHorizontal toSameAxisOfView:iconView];
     */
    
    hud.customView = customView;
    [hud showAnimated:true];
    [hud hideAnimated:YES afterDelay:delay];
    
    if (onHide){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            onHide();
        });
    }
}


+ (void)showMessageThenHide:(NSString*) msg toView:(UIView*)view
{
    [self showMessageThenHide:msg toView:view onHide:nil];
}

+ (void)showMessageThenHide:(NSString *)msg toView:(UIView *)view onHide:(void (^)())onHide
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    NSAssert1(view != nil, @"showLoading view没找到 %s", __FUNCTION__);
    if (view == nil) {
//        DDLogWarn(@"没找到view %s",__FUNCTION__);
        NSLog(@"没找到view %s",__FUNCTION__);
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud){
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    NSAssert1(hud != nil, @"hud为nil %s", __FUNCTION__);
    if (hud == nil) {
        //        DDLogWarn(@"hud为nil %s",__FUNCTION__);
        NSLog(@"hud为nil %s",__FUNCTION__);
    }
    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    hud.detailsLabel.text = msg;
    
    // 再设置模式
    hud.mode = MBProgressHUDModeText;
    [hud setUserInteractionEnabled:false];
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
//    hud.dimBackground = NO;
    hud.backgroundColor = [UIColor clearColor];
    // 2秒之后再消失
    int hideInterval = 2;
    [hud hideAnimated:YES afterDelay:hideInterval];
    
    if (onHide){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(hideInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            onHide();
        });
    }
}

+ (void)closeLoadingView:(UIView *)toView
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:toView];
    if (hud) {
        [hud hideAnimated:YES];
    }
}

+ (MBProgressHUD*) showLoading:(NSString*)msg toView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    NSAssert1(view != nil, @"showLoading view没找到 %s", __FUNCTION__);
    if (view == nil) {
//        DDLogWarn(@"没找到view %s",__FUNCTION__);
        NSLog(@"没找到view %s",__FUNCTION__);
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
    NSAssert1(hud != nil, @"hud为nil %s", __FUNCTION__);
    if (hud == nil) {
//        DDLogWarn(@"hud为nil %s",__FUNCTION__);
        NSLog(@"hud为nil %s",__FUNCTION__);
    }
    hud.detailsLabel.text = msg;
    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    
    // 再设置模式
    hud.mode = MBProgressHUDModeIndeterminate;
    //[hud setUserInteractionEnabled:false];
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}

+ (void)showWindowSuccessThenHide:(NSString *)msg
{
    UIView *window = [[UIApplication sharedApplication].windows lastObject];
    NSAssert1(window != nil, @"showLoading window没找到 %s", __FUNCTION__);
    if (window == nil) {
//        DDLogWarn(@"没找到window %s",__FUNCTION__);
        NSLog(@"没找到window %s",__FUNCTION__);
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:window];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    }
    NSAssert1(hud != nil, @"hud为nil %s", __FUNCTION__);
    if (hud == nil) {
//        DDLogWarn(@"hud为nil %s",__FUNCTION__);
        NSLog(@"没找到window %s",__FUNCTION__);
    }
    [hud showSuccessThenHide:msg];
}

+ (void)showWindowErrorThenHide:(NSString *)msg
{
    UIView *window = [[UIApplication sharedApplication].windows lastObject];
    NSAssert1(window != nil, @"showLoading window没找到 %s", __FUNCTION__);
    if (window == nil) {
//        DDLogWarn(@"没找到window %s",__FUNCTION__);
        NSLog(@"没找到window %s",__FUNCTION__);
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:window];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    }
    NSAssert1(hud != nil, @"hud为nil %s", __FUNCTION__);
    if (hud == nil) {
//        DDLogWarn(@"hud为nil %s",__FUNCTION__);
        NSLog(@"hud为nil %s",__FUNCTION__);
    }
    [hud showErrorThenHide:msg];
}

+ (void)showWindowMessageThenHide:(NSString *)msg
{
    UIView *window = [[UIApplication sharedApplication].windows lastObject];
    NSAssert1(window != nil, @"showLoading window没找到 %s", __FUNCTION__);
    if (window == nil) {
//        DDLogWarn(@"没找到window %s",__FUNCTION__);
        NSLog(@"没找到window %s",__FUNCTION__);
    }
    [MBProgressHUD showMessageThenHide:msg toView:window];
}

+ (void) showWindowLoading:(NSString *)msg
{
    UIView *window = [[UIApplication sharedApplication].windows lastObject];
    NSAssert1(window != nil, @"showLoading window没找到 %s", __FUNCTION__);
    if (window == nil) {
//        DDLogWarn(@"没找到window %s",__FUNCTION__);
        NSLog(@"没找到window %s",__FUNCTION__);
    }
    [MBProgressHUD showLoading:msg toView:window];
}


+ (void)closeOnWindow
{
    UIView *window = [[UIApplication sharedApplication].windows lastObject];
    [[MBProgressHUD HUDForView:window] hideAnimated:true];
}
/*
+ (MBProgressHUD*) showAnimateLoading:(NSString *)message toView:(UIView *)view
{
    if (view == nil) view = [self getWindow];
    if (view == nil) {
//        DDLogWarn(@"没找到view %s",__FUNCTION__);
        NSLog(@"没找到view %s",__FUNCTION__);
    }
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
//    hud.opacity = 0;
    hud.bezelView.alpha = 0;
    
    int height = 140;
    if (message){
        CGSize fsize = [message getSizeWithFont:[UIFont systemFontOfSize:14] andWidth:200];
        height += fsize.height + 10;
    }
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, height)];
//    YLImageView *animateImg = [YLImageView newAutoLayoutView];
//    YLGIFImage *gifImg = (YLGIFImage *)[YLGIFImage imageNamed:@"ic_animate_loading.gif"];
//    animateImg.image = gifImg;
//    [customView addSubview:animateImg];
//    [animateImg autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
//    [animateImg autoAlignAxisToSuperviewAxis:ALAxisVertical];
//    [animateImg autoSetDimensionsToSize:CGSizeMake(140, 140)];
    
    if (message){
//        UILabel *lb = [UILabel newAutoLayoutView];
        UILabel *lb = [UILabel new];
        lb.text = message;
        lb.font = [UIFont systemFontOfSize:14];
        lb.numberOfLines = 0;
        lb.lineBreakMode = NSLineBreakByWordWrapping;
        lb.textAlignment = NSTextAlignmentCenter;
        [customView addSubview:lb];
//        [lb autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
//        [lb autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:0];
        //[lb autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:animateImg withOffset:10];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(0);
            make.trailing.offset(0);
        }];
    }
    
    hud.customView = customView;
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    
    return hud;
}
*/
+ (UIView *)getWindow
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    if (window.windowLevel==UIWindowLevelAlert) {
        NSInteger index = [UIApplication sharedApplication].windows.count-2;
        window = [[UIApplication sharedApplication].windows objectAtIndex:index];
    }
    return window;
}

@end
