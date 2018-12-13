//
//  RNTWKWebViewManager.m
//  AppResearch
//
//  Created by zhoujian on 2018/12/13.
//  Copyright © 2018 Facebook. All rights reserved.
//



#import "RNTWKWebViewManager.h"
#import <UIKit/UIKit.h>

@implementation RNTWKWebViewManager

RCT_EXPORT_MODULE()
- (UIView *)view{
  UIView *view = [[UIView alloc] init];
  return view;
}

@end
