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

static RCTGethModule *_instance = nil;

@interface RCTGethModule()

@property(nonatomic, strong) GethEthereumClient *ethClient;

@property(nonatomic, copy) RCTPromiseResolveBlock resolveBlock;
@property(nonatomic, copy) RCTPromiseRejectBlock rejectBlock;


@end

@implementation RCTGethModule {
  
  RCTResponseSenderBlock _afterCallback;
  RCTPromiseResolveBlock _resolveBlock;
  RCTPromiseRejectBlock _rejectBlock;
  
}

RCT_EXPORT_MODULE();

+ (instancetype)sharedInstance:(NSString *)rawurl {
  if (!rawurl || !rawurl.length) {
    rawurl = @"https://mainnet.infura.io";
  }
  __weak NSString *weakRawurl = rawurl;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (_instance == nil) {
      _instance = [[self alloc] init];
      _instance.ethClient = [[GethEthereumClient alloc] init:weakRawurl];
    }
  });
  return _instance;
}

// 初始化客户端
RCT_EXPORT_METHOD(init:(NSString *)rawurl) {
  if (!rawurl || !rawurl.length) {
    rawurl = @"https://mainnet.infura.io";
  }
  [RCTGethModule sharedInstance:rawurl];
}

// 账户余额
RCT_EXPORT_METHOD(getBalance:(NSString*)context account:(NSString *)account number:(int64_t)number resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)reject) {
  _resolveBlock = resolver;
  _rejectBlock = reject;
  GethContext *text = [[GethContext alloc] init];
  GethAddress *address = [[GethAddress alloc] initFromHex:account];
  GethEthereumClient *ethClient = [RCTGethModule sharedInstance:@""].ethClient;
  NSError *err;
  GethBigInt *bigInt = [ethClient getBalanceAt:text account:address number:-1 error:&err];
  
  if (!err) {
    _resolveBlock(@[[bigInt string]]);
  } else {
    NSError * err = [NSError errorWithDomain:@"getBalance" code:-1 userInfo:nil];
    _rejectBlock(@"-1", @"cancel", err);
  }
}

// 生成新钱包
RCT_REMAP_METHOD(newWallet, resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)reject) {
  _resolveBlock = resolver;
  _rejectBlock = reject;
  // TODO 路径下存在 keyStore => 删除创建新的 keyStore
  NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
  NSString *keydir = [documentsPath stringByAppendingPathComponent:@"keyStore"];
  
  GethKeyStore *keyStore = [[GethKeyStore alloc] init:keydir scryptN:GethStandardScryptN scryptP:GethStandardScryptP];
  
  NSError *err;
  GethAccount *account = [keyStore newAccount:keydir error:&err];
  GethAddress *address = [account getAddress];
  NSString *wallet = [address getHex];
  if (!err) {
    _resolveBlock(@[wallet]);
  } else {
    NSError * err = [NSError errorWithDomain:@"newAccount" code:-1 userInfo:nil];
    _rejectBlock(@"-1", @"cancel", err);
  }
}































RCT_EXPORT_METHOD(findEvents:(RCTResponseSenderBlock)callback) {
  _afterCallback = callback;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    NSArray *events = @[@"A", @"B"];
    self->_afterCallback(@[[NSNull null], events]);
  });
}

RCT_EXPORT_METHOD(doSomethingExpensive:(NSString *)param callback:(RCTResponseSenderBlock)callback) {
  NSLog(@"param => %@", param);
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [NSThread sleepForTimeInterval:3];
    callback(@[[NSNull null], @"DISPATCH_QUEUE_PRIORITY_DEFAULT"]);
  });
}

@end
