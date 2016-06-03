//
//  TaxRatesXmlParser.h
//  XMLParse
//
//  Created by Amar Kant Jha on 04/02/14.
//  Copyright (c) 2014 Amar Kant Jha. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YoutubeXmlParserDelegate <NSObject>

- (void)youtubeXmlParseringFailWithError:(NSError *)error;
- (void)youtubeXmlParseringWithResponse:(NSMutableArray *)array;

@end

@interface YoutubeXmlParser : NSObject<NSXMLParserDelegate>

@property(nonatomic, retain) id<YoutubeXmlParserDelegate> delegate;

- (void)startXmlParsingWithDelegate:(id)aDelegate;

@end
