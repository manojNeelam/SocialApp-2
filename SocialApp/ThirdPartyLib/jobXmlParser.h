//
//  jobXmlParser.h
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JobXmlParserDelegate <NSObject>

- (void)jobXmlParseringFailWithError:(NSError *)error;
- (void)jobXmlParseringWithResponse:(NSMutableArray *)array;

@end

@interface JobXmlParser : NSObject<NSXMLParserDelegate>

@property(nonatomic, retain) id<JobXmlParserDelegate> delegate;

- (void)startXmlParsingWithDelegate:(id)aDelegate;

@end

