//
//  NewsXmlParser.h
//  SocialApp
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

@protocol NewsXmlParserDelegate <NSObject>

- (void)newsXmlParseringFailWithError:(NSError *)error;
- (void)newsXmlParseringWithResponse:(NSMutableArray *)array;

@end

@interface NewsXmlParser : NSObject<NSXMLParserDelegate>

@property(nonatomic, retain) id<NewsXmlParserDelegate> delegate;

- (void)startXmlParsingWithDelegate:(id)aDelegate;

@end
