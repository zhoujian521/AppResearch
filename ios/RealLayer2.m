//
//  RealLayer2.m
//  AppResearch
//
//  Created by zhoujian on 2018/12/14.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "RealLayer2.h"

@implementation RealLayer2

- (NSString *)realNameMethodCalledInJs{
  return @"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
}

- (NSString *)realDoFoo:(id)foo withBar:(id)bar withThird:(id)third {
  return [NSString stringWithFormat:@"doFoo:%@ withBar:%@, third:%@", foo, bar, third];
}

@end
