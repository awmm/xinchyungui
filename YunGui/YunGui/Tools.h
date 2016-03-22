//
//  Tools.h
//  YunGui
//
//  Created by wmm on 15/11/9.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^SuccessBlock)(id data);
typedef void(^FailBlock)(NSError *error);

@interface Tools : NSObject

+ (void)showMessage:(NSString *)message view:(UIViewController *)viewController;//显示提示消息。

+ (BOOL)isDateThisDay:(NSString *)date;
+ (BOOL)isDateThisWeek:(NSString *)date;
+ (BOOL)isDateThisMonth:(NSString *)date;

//等待的小菊花。～_～
+ (void)showDial:(UIActivityIndicatorView *)activityIndicatorView;
+ (void)hideDial:(UIActivityIndicatorView *)activityIndicatorView;

+ (void)CheckDial:(UIActivityIndicatorView *)activityIndicatorView;

+ (void)sendUrlWith:(NSString *)urlStr parameter:(NSDictionary *)dict success:(SuccessBlock)successBlock fail:(FailBlock)faileBlock;

@end

@interface NSData(DataEx)

- (NSString *)base64Encoding;

@end

@interface NSString(StringEx)

+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;

+ (NSString *)macAddress;

- (NSString *)base64EncodedString;

- (NSDate *) stringToDate:string;

@end
