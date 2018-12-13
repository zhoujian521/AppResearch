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

@property(nonatomic, strong) NSString *rawurl;

@property(nonatomic, strong) GethEthereumClient *ethClient;

@property(nonatomic, strong) NSString *keydir;

@property(nonatomic, copy) RCTPromiseResolveBlock resolveBlock;

@property(nonatomic, copy) RCTPromiseRejectBlock rejectBlock;

@end

@implementation RCTGethModule

RCT_EXPORT_MODULE();

+ (instancetype)sharedInstance:(NSString *)rawurl {
  if ((!rawurl || !rawurl.length) && _instance.rawurl) {
    rawurl = _instance.rawurl;
  }
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    if (_instance == nil) {
      _instance = [[self alloc] init];
      _instance.ethClient = [[GethEthereumClient alloc] init:rawurl];
      if (rawurl && rawurl.length) {
        _instance.rawurl = rawurl;
      }
      NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
      NSString *keydir = [documentsPath stringByAppendingPathComponent:@"keystore"];
      if (![FileManager fileExistsAtPath:keydir]) {
        [FileManager createDirectoryIfNotExists:keydir];
      }
      _instance.keydir = keydir;

      // TODO 1 参数如何构建&&传参
//      NSString *eth4fun = @"0xb5538753F2641A83409D2786790b42aC857C5340";
//      GethAddress *from = [[GethAddress alloc] initFromHex:eth4fun];
//      NSLog(@"from is %@", [from getHex]);
//      GethContext *context = [[GethContext alloc] init];
//      NSError *error = nil;
//      GethBigInt *bigInt = [_instance.ethClient getBalanceAt:context account:from number:-1 error:&error];
//      NSLog(@"balance ==> %@", [bigInt string]);
    }
  });
  return _instance;
}

// 初始化客户端
RCT_EXPORT_METHOD(init:(NSString *)rawurl) {
  if (!rawurl || !rawurl.length) {
    rawurl = @"ws://rinkeby03.milewan.com:8546";
  }
  [RCTGethModule sharedInstance:rawurl];
}


// 随机生成钱包
RCT_EXPORT_METHOD(generateWallet) {
  NSString *keydir = [RCTGethModule sharedInstance:nil].keydir;
  NSError * err = [NSError errorWithDomain:@"generateWallet" code:-1 userInfo:nil];
  GethAccount *wallet = [[[GethKeyStore alloc] init] newAccount:keydir error:&err];
  NSLog(@"wallet ==> %@",wallet);
}

RCT_EXPORT_METHOD(createKeyStore) {
  NSString *keydir = [RCTGethModule sharedInstance:nil].keydir;
  NSError *error = nil;
  NSArray *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:keydir error:&error];
  if (error) {
    // TODO 路径查询异常
    return;
  }
  if (fileArray.count) {
    // TODO 用户是否需要感知  危险
    [FileManager removeFileAtPath:keydir];
  }
  GethKeyStore *keyStore = [[GethKeyStore alloc] init:keydir scryptN:GethStandardScryptN scryptP:GethStandardScryptP];
  NSString *passphrase = @"11111111";
  NSError *err = nil;
  GethAccount *account = [keyStore newAccount:passphrase error:&err];
  
//  GethAccounts *accounts = [[GethAccounts alloc] initWithRef:@1];
//  long index = 1024;
//  BOOL isSet = [accounts set:index account:account error:nil];
//  if (!isSet) {
//    // 缓存 account 异常
//    return;
//  }
  GethAddress *address = [account getAddress];
  NSString *addressHex = [address getHex];
  NSLog(@"addressHex ==> %@",addressHex); // 0xE52643f85fa302bD414A8f2D00cc667561F35f36
}

RCT_EXPORT_METHOD(importKeyStore) {
//  NSError *error = nil;
//  NSArray *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:keydir error:&error];
//  if (error) {
//    // TODO 路径查询异常
//    return;
//  }
  NSString *keydir = [RCTGethModule sharedInstance:nil].keydir;
  NSString *filePath = [keydir stringByAppendingPathComponent:@"keystore.json"];
  NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
//  NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  GethKeyStore *keyStore = [[GethKeyStore alloc] init:keydir scryptN:GethStandardScryptN scryptP:GethStandardScryptP];
  NSError *err = nil;
  NSString *passphrase = @"11111111";
  NSString *newPassphrase = @"11111111";
  GethAccount *account = [keyStore importKey:data passphrase:passphrase newPassphrase:newPassphrase error:&err];
  GethAddress *address = [account getAddress];
  NSString *addressHex = [address getHex];
  NSLog(@"addressHex ==> %@",addressHex); // 0xE52643f85fa302bD414A8f2D00cc667561F35f36
}


//data: "0x"
//from: "0xb5538753F2641A83409D2786790b42aC857C5340"
//gasLimit: "0xc738"
//gasPrice: "0x2540be400"
//nonce: "0x6"
//to: "0x38bCc5B8b793F544d86a94bd2AE94196567b865c"
//value: "0xde0b6b3a7640000"

RCT_EXPORT_METHOD(transferEth) {
  GethEthereumClient *ethClient = [RCTGethModule sharedInstance:nil].ethClient;
  // TODO 1 参数如何构建&&传参
  NSString *eth4fun = @"0xb5538753F2641A83409D2786790b42aC857C5340";
  GethAddress *from = [[GethAddress alloc] initFromHex:eth4fun];
  NSLog(@"from is %@", [from getHex]);
  GethContext *context = [[GethContext alloc] init];

  int64_t nonce = 0x0;
  int64_t number = -1;
  NSError *error = nil;
//  BOOL isGet = [ethClient getPendingNonceAt:context account:from nonce:&nonce error:&error];
  BOOL isGet = [ethClient getNonceAt:context account:from number:number nonce:&nonce  error:&error];
  if (!isGet) {
    NSLog(@"生成 nonce 失败");
    // TODO 2 获取 nonce 失败的逻辑
  }  
  // toWei 的转换逻辑
  NSString *metaMask = @"0x38bCc5B8b793F544d86a94bd2AE94196567b865c";
  GethAddress *to = [[GethAddress alloc] initFromHex:metaMask];
//  GethBigInt *amount = [[GethBigInt alloc] init:0xde0b6b3a7640000]; // toWei
  GethBigInt *amount = [[GethBigInt alloc] init:0x000000000000001]; // toWei
  ino64_t gasLimit = 0xc738; // toWei
  GethBigInt *gasPrice = [[GethBigInt alloc] init:1e10]; // toWei
//  GethBigInt *gasPrice = [[GethBigInt alloc] init:0x000000001]; // toWei
  NSData *data = [NSData data];
  GethTransaction *transaction = [[GethTransaction alloc] init:nonce to:to amount:amount gasLimit:gasLimit gasPrice:gasPrice data:data];
  
//  - (GethTransaction*)signTx:(GethAccount*)account tx:(GethTransaction*)tx chainID:(GethBigInt*)chainID error:(NSError**)error;
  // TODO 3 GethKeyStore 缓存机制
  // TODO 4 GethAccount GethAccounts 如何存取
//  GethAccounts *accounts = [[GethAccounts alloc] init];
//  NSError *accountsErr = nil;
//  GethAccount *account = [accounts get:0 error:&accountsErr];
//  if (!account) {
//    // TODO 获取当前账户异常
//    return;
//  }
//   GethKeyStore *keyStore = [[GethKeyStore alloc] initWithRef:0];

  NSString *keydir = [RCTGethModule sharedInstance:nil].keydir;
  NSString *filePath = [keydir stringByAppendingPathComponent:@"keystore.json"];
  NSData *keyJSON = [[NSFileManager defaultManager] contentsAtPath:filePath];
  //  NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  GethKeyStore *keyStore = [[GethKeyStore alloc] init:keydir scryptN:GethStandardScryptN scryptP:GethStandardScryptP];
  NSError *err = nil;
  NSString *passphrase = @"11111111";
  NSString *newPassphrase = @"11111111";
  GethAccount *account = [keyStore importKey:keyJSON passphrase:passphrase newPassphrase:newPassphrase error:&err];
  NSLog(@"account ==> %@",[[account getAddress] getHex]);
  
  
  
  
  int64_t ethereumNetworkID = 4;
  GethBigInt *chainID = [[GethBigInt alloc] init:ethereumNetworkID];
  NSError *signedErr = nil;
//  GethTransaction *signedTx = [keyStore signTx:account tx:transaction chainID:chainID error:&signedErr];
  GethTransaction *signedTx = [keyStore signTxPassphrase:account passphrase:passphrase tx:transaction chainID:chainID error:&signedErr];
  
  NSError *sendErr = nil;
  BOOL isSend = [ethClient sendTransaction:context tx:signedTx error:&sendErr];
  NSLog(@"isSend ==> %d",isSend);
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
  NSLog(@"balance ==> %@", [bigInt string]);
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
