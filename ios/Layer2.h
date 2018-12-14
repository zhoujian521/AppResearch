//
//  Layer2.h
//  AppResearch
//
//  Created by zhoujian on 2018/12/14.
//  Copyright © 2018 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Layer2Protocol <JSExport>

@property (nonatomic, retain) NSDictionary *urls;

- (NSString *)fullName;

- (NSString *)methodCalledInJs;

- (NSString *)doFoo:(id)foo withBar:(id)bar;

JSExportAs(doFoo, - (NSString *)doFoo:(id)foo withBar:(id)bar withThird:(id)third);

@end

@interface Layer2 : NSObject <Layer2Protocol>

@property (nonatomic, copy) NSString *firstName;

@property (nonatomic, copy) NSString *lastName;

@end

NS_ASSUME_NONNULL_END
