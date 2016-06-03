//
//  EventXmlParser.h
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EventXmlParserDelegate <NSObject>

- (void)eventXmlParseringFailWithError:(NSError *)error;
- (void)eventXmlParseringWithResponse:(NSMutableArray *)array;

@end

@interface EventXmlParser : NSObject<NSXMLParserDelegate>

@property(nonatomic, retain) id<EventXmlParserDelegate> delegate;

- (void)startXmlParsingWithDelegate:(id)aDelegate;

@end

