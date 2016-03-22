//
//  DataTool.m
//  Marketing
//
//  Created by wmm on 16/2/26.
//  Copyright © 2016年 Hanen 3G 01. All rights reserved.
//

#import "DataTool.h"

@implementation DataTool

+ (void)sendGetWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successblock fail:(FailBlock)failblock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successblock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failblock(error);
    }];
}

+ (void)postWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(SuccessBlock)successBlock fail:(FailBlock)faileBlock
{
    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        faileBlock(error);
    }];
}

//+(NSString*)fileMD5:(NSString*)path
//{
//    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
//    if( handle== nil ) return @"ERROR GETTING FILE MD5"; // file didnt exist
//    
//    CC_MD5_CTX md5;
//    
//    CC_MD5_Init(&md5);
//
//    BOOL done = NO;
//    while(!done)
//    {
//        NSData* fileData = [handle readDataOfLength: CHUNK_SIZE ];
//        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
//        if( [fileData length] == 0 ) done = YES;
//    }
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    CC_MD5_Final(digest, &md5);
//    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",digest[0], digest[1],digest[2], digest[3],digest[4], digest[5],digest[6], digest[7],digest[8], digest[9],digest[10], digest[11],digest[12], digest[13], digest[14], digest[15]];
//    return s;
////}
//
//+ (NSString *) md5:(NSString *)str
//{
//    const char *cStr = [str UTF8String];
//    unsigned char result[16];
//    CC_MD5( cStr, strlen(cStr), result );
//    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3],result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]
//    ];
//}

+ (NSString*)getmd5WithString:(NSString *)string

{
    
    const char* original_str=[string UTF8String];
    
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    
    CC_MD5(original_str, strlen(original_str), digist);
    
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        
        [outPutStr appendFormat:@"%02X", digist[i]];// 小写 x 表示输出的是小写 MD5 ，大写 X 表示输出的是大写 MD5
        
    }
    
    return outPutStr;
    
}

+ (NSComparisonResult)compareArray: (NSDictionary *)otherDictionary
{
    NSDictionary *tempDictionary = (NSDictionary *)self;
    
    int number1 = [[[tempDictionary allKeys] objectAtIndex:0] characterAtIndex:0]; //65
    int number2 = [[[otherDictionary allKeys] objectAtIndex:0] characterAtIndex:0];
//    NSNumber *number1 = [[tempDictionary allKeys] objectAtIndex:0];
//    NSNumber *number2 = [[otherDictionary allKeys] objectAtIndex:0];
    
    NSNumber *numObj1 = [NSNumber numberWithInt:number1];
    NSNumber *numObj2 = [NSNumber numberWithInt:number2];
    
    NSComparisonResult result = [numObj1 compare:numObj2];
    
    return result == NSOrderedDescending; // 升序
    //    return result == NSOrderedAscending;  // 降序
}

+ (NSMutableDictionary *)addSignToDic:(NSMutableDictionary *)dictionary{
    
    [dictionary setObject:@"yeguan" forKey:@"app_key"];
    [dictionary setObject:@"json" forKey:@"format"];
    [dictionary setObject:[DateTool getCurrentDate] forKey:@"timestamp"];
    
    
    NSLog(@"dictionary%@",dictionary);
    NSArray *myKeys = [dictionary allKeys];
    NSArray *newArray = [myKeys sortedArrayUsingSelector:@selector(compare:)];
    NSLog(@"new array = %@",newArray);
    NSString *str1 = @"YUNGUI";
    for (NSString *key in newArray) {
        str1 = [NSString stringWithFormat:@"%@%@%@", str1, key ,[dictionary objectForKey:key]];
    }
    str1 = [NSString stringWithFormat:@"%@YUNGUI", str1];
    NSLog(@"%@",str1);
    NSString *sign = [self getmd5WithString:str1];
    [dictionary setObject:sign forKey:@"sign"];
    
    return dictionary;
}

#pragma mark - 私有方法
//将NSDictionary中的Null类型的项目转化成@""
+(NSDictionary *)nullDic:(NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        
        obj = [self changeType:obj];
        
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}

//将NSDictionary中的Null类型的项目转化成@""
+(NSArray *)nullArr:(NSArray *)myArr
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++)
    {
        id obj = myArr[i];
        
        obj = [self changeType:obj];
        
        [resArr addObject:obj];
    }
    return resArr;
}

//将NSString类型的原路返回
+(NSString *)stringToString:(NSString *)string
{
    return string;
}

//将Null类型的项目转化成@""
+(NSString *)nullToString
{
    return @" ";
}

#pragma mark - 公有方法
//类型识别:将所有的NSNull类型转化成@""
+(id)changeType:(id)myObj
{
    if ([myObj isKindOfClass:[NSDictionary class]])
    {
        return [self nullDic:myObj];
    }
    else if([myObj isKindOfClass:[NSArray class]])
    {
        return [self nullArr:myObj];
    }
    else if([myObj isKindOfClass:[NSString class]])
    {
        return [self stringToString:myObj];
    }
    else if([myObj isKindOfClass:[NSNull class]])
    {
        return [self nullToString];
    }
    else
    {
        return myObj;
    }
}

//+ (void)getReportByUrl:(NSString *)Id complationBlock:(void(^)(NSDictionary *dic))complation
//{
//    
//    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@(UID), @"uid", TOKEN, @"token", nil];
//    
//    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//    
//        [manager POST:WORK_REPORT_URL parameters:param success:^(AFHTTPRequestOperation *operation,id responseObject) {
//            __block NSDictionary *dic = responseObject;
//            //NSLog(@"___________________________________________________%@",responseObject);
//            if (complation) {
//                complation(dic);
//            }
//            
//        } failure:^(AFHTTPRequestOperation *operation,NSError *error)
//         {
//             NSLog(@"失败失败失败失败失败失败失败失败失败失败%@",error);
//         }];
//   // }
//
//}

@end
