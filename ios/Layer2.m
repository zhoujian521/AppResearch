//
//  Layer2.m
//  AppResearch
//
//  Created by zhoujian on 2018/12/14.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "Layer2.h"

@implementation Layer2

@synthesize firstName, lastName, urls;

- (NSString *)fullName {
  return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (NSString *)methodCalledInJs {
  return @"js 中 通过 window.layer2.methodCalledInJs 的方式调用";
}

- (NSString *)doFoo:(id)foo withBar:(id)bar{
  return [NSString stringWithFormat:@"doFoo:%@ withBar:%@", foo, bar];
}

- (NSString *)doFoo:(id)foo withBar:(id)bar withThird:(id)third{
  return [NSString stringWithFormat:@"doFoo:%@ withBar:%@, third:%@", foo, bar, third];
}

@end
