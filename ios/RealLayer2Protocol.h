//
//  RealLayer2Protocol.h
//  AppResearch
//
//  Created by zhoujian on 2018/12/14.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RealLayer2Protocol <JSExport>

@property (nonatomic, retain) NSString *realName;

- (NSString *)realNameMethodCalledInJs;

JSExportAs(realDoFoo, - (NSString *)realDoFoo:(id)foo withBar:(id)bar withThird:(id)third);

@end

NS_ASSUME_NONNULL_END
