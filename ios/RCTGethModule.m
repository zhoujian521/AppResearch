//
//  RCTGethModule.m
//  AppResearch
//
//  Created by zhoujian on 2018/12/11.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import "RCTGethModule.h"
#import <React/RCTLog.h>
#import <Geth/Geth.h>

@implementation RCTGethModule {
  RCTResponseSenderBlock _afterCallback;
  
  RCTPromiseResolveBlock _resolveBlock;
  RCTPromiseRejectBlock _rejectBlock;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(addEvent:(NSString *)name location:(NSString *)location) {
  RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
}

RCT_EXPORT_METHOD(findEvents:(RCTResponseSenderBlock)callback) {
  _afterCallback = callback;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    NSArray *events = @[@"A", @"B"];
    self->_afterCallback(@[[NSNull null], events]);
  });
}


RCT_REMAP_METHOD(findEventsPromise, resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)reject){
  
  _resolveBlock=resolver;
  _rejectBlock=reject;
  
//  NSError * err=[NSError errorWithDomain:@"test" code:0 userInfo:nil];
//  _rejectBlock(@"0",@"cancel",err);
  
  _resolveBlock(@[@1, @2, @3]);
}

RCT_EXPORT_METHOD(doSomethingExpensive:(NSString *)param callback:(RCTResponseSenderBlock)callback) {
  NSLog(@"param => %@", param);
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [NSThread sleepForTimeInterval:3];
    callback(@[[NSNull null], @"DISPATCH_QUEUE_PRIORITY_DEFAULT"]);
  });
}

@end
