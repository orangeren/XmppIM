//
//  NSDictionary+Add.h
//  iValet
//
//  Created by 任 on 2018/9/5.
//  Copyright © 2018年 i代. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Add)

- (NSDictionary *)jsonDict: (NSString *)key;

- (NSInteger)jsonInteger: (NSString *)key;

@end
