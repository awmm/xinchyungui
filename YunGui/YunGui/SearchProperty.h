//
//  SearchProperty.h
//  YunGui
//
//  Created by Hanen 3G 01 on 15/11/17.
//  Copyright © 2015年 hanen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchPropertyDelegate  <NSObject>

- (void)bringBackChioceProperty:(NSString *)propertyName;

@end

@interface SearchProperty : UIViewController

@property (nonatomic, weak) id<SearchPropertyDelegate>delegate;

@property (nonatomic, strong) NSString * inputText;

@end
