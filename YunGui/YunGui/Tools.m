//
//  Tools.m
//  YunGui
//
//  Created by wmm on 15/11/9.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import "Tools.h"
#import <CommonCrypto/CommonCrypto.h>
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import "AFHTTPRequestOperationManager.h"

@implementation Tools : NSObject

//显示提示信息。
+ (void)showMessage:(NSString *)message view:(UIViewController *)viewController
{
    @synchronized(self)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示"                                                                message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [viewController presentViewController:alert animated:YES completion:nil];
        
    }
}

//+ (BOOL)isDateThisDay:(NSString *)dateStr{
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",dateStr]];
//    
//    NSCalendar *gregorian = [[NSCalendar alloc]
//                             initWithCalendarIdentifier:NSGregorianCalendar];
//    [gregorian setFirstWeekday:2];
//    
//    NSDateComponents *dayComponents = [gregorian components:NSDayCalendarUnit fromDate:date toDate:[NSDate date] options:0];
//    // dayComponents.day  即为间隔的天数
//    NSLog(@"%@",dayComponents);
//    if(dayComponents.day == 0){
//        NSLog(@"day");
//        return YES;
//    }else{
//        return NO;
//    }
//}

//筛选条件当日
+ (BOOL)isDateThisDay:(NSString *)dateStr{
    if (dateStr == nil || [dateStr isEqualToString:@""]) return NO;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",dateStr]];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    NSDate *otherDate = [cal dateFromComponents:components];
    if([today isEqualToDate:otherDate]){
        NSLog(@"isDateThisDay");
        return YES;
    }
    return NO;
}
//本周
+ (BOOL)isDateThisWeek:(NSString *)dateStr{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",dateStr]];
    
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:now];
    
    // 得到星期几
    // 1(星期一) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 9 - weekDay;
    }
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
//    NSString *beginString = [dateFormatter stringFromDate:firstDayOfWeek];
//    NSString *endString = [dateFormatter stringFromDate:lastDayOfWeek];
//    NSString *s = [NSString stringWithFormat:@"%@-%@",beginString,endString];
//    NSLog(@"%@",s);
    
    if (([date compare:firstDayOfWeek]==NSOrderedDescending || [date compare:firstDayOfWeek]==NSOrderedSame) && ([date compare:lastDayOfWeek]==NSOrderedAscending || [date compare:lastDayOfWeek]==NSOrderedSame))
    {
        NSLog(@"isDateThisWeek");
        return YES;
    }else{
        return NO;
    }
}

//本周
//+ (BOOL)isDateThisWeek:(NSString *)dateStr{
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",dateStr]];
//    
//    
//    
//    NSDate *start;
//    NSTimeInterval extends;
//    
//    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
//    NSDate *today=[NSDate date];
//    
//    BOOL success= [cal rangeOfUnit:NSWeekCalendarUnit startDate:&start interval: &extends forDate:today];
//    
//    if(!success)
//        return NO;
//    
//    NSTimeInterval dateInSecs = [date timeIntervalSinceReferenceDate];
//    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
//    
//    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
//        NSLog(@"isDateThisWeek");
//        return YES;
//    }
//    else {
//        NSLog(@"isnotDateThisWeek");
//        return NO;
//    }
//}

//本月
+ (BOOL)isDateThisMonth:(NSString *)dateStr{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[dateFormatter dateFromString:dateStr];
    
    
    double interval = 0;
    NSDate *beginDate;
    NSDate *endDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
//    FirstDay := StrToDate(FormatDateTime('yyyy-MM-01', Now))
//    LastDay := IncMonth(FirstDay)-1;
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:[NSDate date]];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return NO;
    }
//    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
//    [myDateFormatter setDateFormat:@"YYYY.MM.dd"];
//    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
//    NSString *endString = [myDateFormatter stringFromDate:endDate];
//    NSString *s = [NSString stringWithFormat:@"%@-%@",beginString,endString];
    
    if (([date compare:beginDate]==NSOrderedDescending || [date compare:beginDate]==NSOrderedSame) && ([date compare:endDate]==NSOrderedAscending || [date compare:endDate]==NSOrderedSame))
    {
        NSLog(@"isDateThisMonth");
        return YES;
    }else{
        return NO;
    }
}

//等待小菊花。
+ (void)showDial:(UIActivityIndicatorView *)activityIndicatorView
{
    activityIndicatorView.hidden = NO;
    activityIndicatorView.window.userInteractionEnabled = NO;
}

+ (void)hideDial:(UIActivityIndicatorView *)activityIndicatorView
{
    activityIndicatorView.hidden = YES;
    activityIndicatorView.window.userInteractionEnabled = YES;
}

+ (void)CheckDial:(UIActivityIndicatorView *)activityIndicatorView
{
    if(activityIndicatorView.hidden == NO)
    {
        activityIndicatorView.hidden = YES;
        activityIndicatorView.window.userInteractionEnabled = YES;
    }
}

+ (void)sendUrlWith:(NSString *)urlStr parameter:(NSDictionary *)dict success:(SuccessBlock)successBlock fail:(FailBlock)faileBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //有时候将html纳入可请求的内容类型中
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        faileBlock(error);
    }];
}
@end

@implementation NSData(DataEx)

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
- (NSString *)base64Encoding
{
    if (self.length == 0)
        return @"";
    
    char *characters = malloc(self.length*3/2);
    
    if (characters == NULL)
        return @"";
    
    int end = self.length - 3;
    int index = 0;
    int charCount = 0;
    int n = 0;
    
    while (index <= end) {
        int d = (((int)(((char *)[self bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[self bytes])[index + 1]) & 0x0ff) << 8)
        | ((int)(((char *)[self bytes])[index + 2]) & 0x0ff);
        
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = encodingTable[d & 63];
        
        index += 3;
        
        if(n++ >= 14)
        {
            n = 0;
            characters[charCount++] = ' ';
        }
    }
    
    if(index == self.length - 2)
    {
        int d = (((int)(((char *)[self bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[self bytes])[index + 1]) & 255) << 8);
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = '=';
    }
    else if(index == self.length - 1)
    {
        int d = ((int)(((char *)[self bytes])[index]) & 0x0ff) << 16;
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = '=';
        characters[charCount++] = '=';
    }
    NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
    return rtnStr;
}

@end

@implementation NSString(StringEx)

static Byte iv[] = {1,2,3,4,5,6,7,8};

+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [data base64Encoding];
    }
    return ciphertext;
}

+ (NSString *)macAddress
{
    int mib[6];
    size_t len;
    char * buf;
    unsigned char * ptr;
    struct if_msghdr * ifm;
    struct sockaddr_dl * sdl;
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    if((mib[5] = if_nametoindex("en0")) == 0)
    {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    if(sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
    {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    if((buf = malloc(len)) == NULL)
    {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    if(sysctl(mib, 6, buf, &len, NULL, 0) < 0)
    {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

- (NSString *)base64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64Encoding];
}

- (NSDate *) stringToDate:string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

@end
