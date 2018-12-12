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
#import "FileManager.h"



static RCTGethModule *_instance = nil;

@interface RCTGethModule()

@property(nonatomic, strong) GethEthereumClient *ethClient;

@property(nonatomic, strong) NSString *keydir;

@property(nonatomic, copy) RCTPromiseResolveBlock resolveBlock;
@property(nonatomic, copy) RCTPromiseRejectBlock rejectBlock;


@end

@implementation RCTGethModule

RCT_EXPORT_MODULE();

+ (instancetype)sharedInstance:(NSString *)rawurl {
  __weak NSString *weakRawurl = rawurl;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (_instance == nil) {
      _instance = [[self alloc] init];
      _instance.ethClient = [[GethEthereumClient alloc] init:weakRawurl];
      NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
      NSString *keydir = [documentsPath stringByAppendingPathComponent:@"keystore"];
      if (![FileManager fileExistsAtPath:keydir]) {
        [FileManager createDirectoryIfNotExists:keydir];
      }
      _instance.keydir = keydir;
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


// 随机生成钱包
RCT_EXPORT_METHOD(generateWallet) {
  NSString *keydir = [RCTGethModule sharedInstance:nil].keydir;
  NSError * err = [NSError errorWithDomain:@"generateWallet" code:-1 userInfo:nil];
  GethAccount *wallet = [[[GethKeyStore alloc] init] newAccount:keydir error:&err];
  
  NSLog(@"err ==> %@",err);
  NSLog(@"wallet ==> %@",wallet);
}

RCT_EXPORT_METHOD(createKeyStore) {
  NSString *keydir = [RCTGethModule sharedInstance:nil].keydir;
  GethKeyStore *keyStore = [[GethKeyStore alloc] init:keydir scryptN:GethStandardScryptN scryptP:GethStandardScryptP];
  NSError *err = nil;
  GethAccount *account = [keyStore newAccount:keydir error:&err];
  GethAddress *address = [account getAddress];
  NSString *addressHex = [address getHex];
  NSLog(@"addressHex ==> %@",addressHex);
}

RCT_EXPORT_METHOD(importKeyStore:(NSData *)keyJSON passphrase:(NSString *)passphrase newPassphrase:(NSString *)newPassphrase) {
  NSError *error = nil;
  GethAccount *account = [[GethKeyStore alloc] importKey:keyJSON passphrase:passphrase newPassphrase:newPassphrase error:&error];
  GethAddress *address = [account getAddress];
  NSString *addressHex = [address getHex];
  NSLog(@"addressHex ==> %@",addressHex);
}

RCT_EXPORT_METHOD(transferEth) {
//  - (instancetype)init:(int64_t)nonce to:(GethAddress*)to amount:(GethBigInt*)amount gasLimit:(int64_t)gasLimit gasPrice:(GethBigInt*)gasPrice data:(NSData*)data;
  
  GethTransactOpts *transactOpts = [[GethTransactOpts alloc] init];
  [transactOpts setNonce:1];
  
  NSString *metaMask = @"0x38bCc5B8b793F544d86a94bd2AE94196567b865c";
  GethAddress *metaMaskAddress = [[GethAddress alloc] initFromHex:metaMask];
  [transactOpts setFrom:metaMaskAddress];
  
  GethBigInt *amount = [[GethBigInt alloc] init:2];
  [transactOpts setValue:amount];
  
  ino64_t gasLimit = 3;
  [transactOpts setGasLimit:gasLimit];
  
  GethBigInt *gasPrice = [[GethBigInt alloc] init:4];
  [transactOpts setGasPrice:gasPrice];
  
//  NSString *eth4fun = @"0xb5538753F2641A83409D2786790b42aC857C5340";
//  GethAddress *eth4funAddress = [[GethAddress alloc] initFromHex:eth4fun];
//  NSError *err = nil;
//  GethSigner *signer = [[[GethSigner alloc] init] sign:eth4funAddress p1:<#(GethTransaction *)#> error:&err];
//  NSLog(@"signer===>%@",signer);
  
  NSError *transferErr = nil;
  GethTransaction *transfer = [[[GethBoundContract alloc] init] transfer:transactOpts error:&transferErr];
  NSLog(@"transfer===>%@",transfer);
}

RCT_EXPORT_METHOD(transferTokens) {
  
}



























// 账户余额
RCT_EXPORT_METHOD(getBalance:(NSString *)account resolver:(RCTPromiseResolveBlock)resolver rejecter:(RCTPromiseRejectBlock)reject) {
  _resolveBlock = resolver;
  _rejectBlock = reject;
  GethContext *context = [[GethContext alloc] init];
  GethAddress *address = [[GethAddress alloc] initFromHex:account];
  GethEthereumClient *ethClient = [RCTGethModule sharedInstance:nil].ethClient;
  NSError *err;
  GethBigInt *bigInt = [ethClient getBalanceAt:context account:address number:-1 error:&err];
  
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



RCT_EXPORT_METHOD(doSomethingExpensive:(NSString *)param callback:(RCTResponseSenderBlock)callback) {
  NSLog(@"param => %@", param);
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [NSThread sleepForTimeInterval:3];
    callback(@[[NSNull null], @"DISPATCH_QUEUE_PRIORITY_DEFAULT"]);
  });
}

@end
