//
//  NSString+DateFormater.m
//  SocialApp
//
//  Created by Vimal on 06/12/13.
//  Copyright (c) 2013 KPMG. All rights reserved.
//

#import "NSString+DateFormater.h"

@implementation NSString (DateFormater)

+ (NSString *)dateFromString:(NSString *)dateString
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* myDate = [dateFormatter dateFromString:dateString];
    NSLog(@"date = %@",[NSString stringWithFormat:@"%@",myDate])
    return dateString;
}

@end
